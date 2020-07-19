enum ApiCommandType {
    BurnFuel = 0,
    Detonate = 1,
    Shoot = 2,
    SplitShip = 3
}

enum ApiPlayerRole {
    Attacker = 0,
    Defender = 1,
}

export default function run(logData: ILogData, canvasDelta: number, done?: () => void) {
    const canvasElement = document.getElementById("field");
    const consoleElement = document.getElementById("console");

    if (!canvasElement || !consoleElement) return;

    const canvas = canvasElement as HTMLCanvasElement;
    const maybeCtx = canvas.getContext('2d');
    if (!maybeCtx) return;
    const ctx = maybeCtx as CanvasRenderingContext2D;

    let cellSize = 10;
    let index = 0;
    let log = convertGameLog(logData);
    let showTrajectories = true;
    let autoPlayTimerId: number = 0;
    let timePerTick = 100;

    const resizeListener = () => {
        resize();
        update();
    };    
    window.addEventListener('resize', resizeListener);

    document.body.addEventListener('keydown', keydown);
    canvas.addEventListener('click', click);

    resize();
    update();
    startAutoplay();

    function resize() {
        canvas.width = window.innerWidth - 64;
        canvas.height = window.innerHeight - 260 + canvasDelta;
    }

    function keydown(ev: KeyboardEvent) {
        if (!log.gameLog) return;
        const code = ev.code;
        //if (code === "ArrowRight" || code === "KeyD") {
        if (code === "ArrowRight") {
            rewind(1);
            stopAutoplay();
        //} else if (code === "ArrowLeft" || code === "KeyA") {
        } else if (code === "ArrowLeft") {
            rewind(-1);
            stopAutoplay();
        } else if (code === "Home" || code === "KeyQ") {
            index = 0;
            stopAutoplay();
        } else if (code === "End" || code === "KeyE") {
            index = log.gameLog.ticks.length - 1;
            stopAutoplay();
        } else if (code === "Equal")
            cellSize *= 1.2;
        else if (code === "Minus")
            cellSize /= 1.2;
        else if (code === "Comma") {
            timePerTick = Math.min(1000, timePerTick + 10);
            stopAutoplay();
            startAutoplay();
        } else if (code === "Period") {
            timePerTick = Math.max(20, timePerTick - 10);
            stopAutoplay();
            startAutoplay();
        } else if (code === "KeyP" || code === "Space") {
            if (autoPlayTimerId)
                stopAutoplay();
            else
                startAutoplay();
        } else return;
        ev.preventDefault();
        update();
    }
    
    function stopAutoplay() {
        clearTimeout(autoPlayTimerId);        
        autoPlayTimerId = 0;
    }

    function startAutoplay() {
        autoPlayTimerId = setInterval(autoplayTick, timePerTick) as any as number;
    }

    function autoplayTick() {
        rewind(1);
        update();
        if (log.gameLog && index >= log.gameLog.ticks.length - 1) {
            stopAutoplay();
            if (done) {
                window.removeEventListener('resize', resizeListener);
                document.body.removeEventListener('keydown', keydown);
                canvas.removeEventListener('click', click);
                done();
            }
        }
    }

    function click() {
        showTrajectories = !showTrajectories;
        update();
    }

    function rewind(dir: 1 | -1) {
        if (!log.gameLog) return
        index = Math.min(log.gameLog.ticks.length - 1, Math.max(0, index + dir));
    }

    function update() {
        if (!log.gameLog) return;
        drawEvent(log.gameLog.ticks[index]);
    }

    function drawTrajectories(ships: IShipAndCommands[]) {
        if (!showTrajectories) return;
        ctx.globalAlpha = 0.5;
        for (let s of ships) {
            const points = simulate(s.ship, 15);
            const path = new Path2D();
            path.moveTo(toScreenX(s.ship.position.x + 0.5), toScreenY(s.ship.position.y + 0.5));
            for (let p of points) {
                let sx = toScreenX(p.x + 0.5);
                let sy = toScreenY(p.y + 0.5);
                path.lineTo(sx, sy);
            }
            ctx.strokeStyle = shipColor(s.ship);
            ctx.stroke(path);
        }
        ctx.globalAlpha = 1;
    }

    function drawEvent(tick: ITick) {
        const ships = tick.ships;

        adjustScale(ships);
        clearSpace();
        if (log.gameLog && log.gameLog.planet && log.gameLog.planet.safeRadius >= 0)
            drawSafePlace(log.gameLog.planet.safeRadius);
        if (log.gameLog && log.gameLog.planet && log.gameLog.planet.radius >= 0)
            drawPlanet(log.gameLog.planet.radius);
        drawTrajectories(ships);
        drawCommands(ships);
        for (const ship of ships) {
            drawShip(ship.ship);
        }
        let consoleShips = `${tick.tick}`;
        for (const ship of ships) {
            consoleShips += `<p style="color: ${shipColor(ship.ship)}">${JSON.stringify(ship)}</p>`;
        }
        if (consoleElement) {
            consoleElement.innerHTML = consoleShips;
        }
    }

    function drawLaser(ship: IShip, laserCommand: ILaserCommand) {
        const target = laserCommand.payload[0];
        const damage = laserCommand.payload[2];
        const damageDecreaseFactor = laserCommand.payload[3];
        const laser = new Path2D();
        laser.moveTo(toScreenX(ship.position.x + 0.5), toScreenY(ship.position.y + 0.5));
        laser.lineTo(toScreenX(target[0] + 0.5), toScreenY(target[1] + 0.5));
        ctx.fillStyle = "white";
        ctx.fill(createRect(target[0], target[1], getShootRadius(damage, damageDecreaseFactor)));
        ctx.strokeStyle = "yellow";
        ctx.stroke(laser);
    }

    function drawDetonation(ship: IShip, detonateCommand: IDetonateCommand) {
        // const power = detonateCommand.payload[0];
        // const powerDecrease = detonateCommand.payload[1];
        // const r = power / powerDecrease - 1;
        const r = 10;
        ctx.fillStyle = "magenta";
        ctx.fill(createRect(ship.position.x, ship.position.y, r));
    }

    function drawCommands(ships: IShipAndCommands[]) {
        for (let ship of ships)
            for (let cmd of ship.appliedCommands) {
                let appliedCommand = {type: cmd[0], payload: cmd.slice(1)};
                if (appliedCommand.type === ApiCommandType.Detonate) drawDetonation(ship.ship, appliedCommand);
                else if (appliedCommand.type === ApiCommandType.Shoot) drawLaser(ship.ship, appliedCommand);
            }
    }

    function clearSpace() {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
    }

    function fitInScreen(pos: V) {
        const screenX = toScreenX(pos.x);
        const screenY = toScreenY(pos.y);
        return screenX > 0 && screenX < canvas.width && screenY > 0 && screenY < canvas.height;
    }

    function adjustScale(ships: IShipAndCommands[]) {
        while (cellSize > 0.2 && ships.some(s => !fitInScreen(s.ship.position)))
            cellSize /= 1.2;
    }

    function drawPlanet(radius: number) {
        ctx.fillStyle = "white";
        ctx.fill(createRect(0, 0, radius));
    }

    function drawSafePlace(radius: number) {
        ctx.fillStyle = "rgb(0,0,0)";
        ctx.fill(createRect(0, 0, radius));
    }

    function drawShip(ship: IShip) {
        const pos = ship.position;
        ctx.fillStyle = shipColor(ship);
        ctx.fill(createRect(pos.x, pos.y));
    }

    function simulate(ship: IShip, ticks: number) {
        const points = [];
        const s = {
            position: ship.position,
            velocity: ship.velocity,
        };
        for (let i = 0; i < ticks; i++) {
            const dx = Math.abs(s.position.x);
            const dy = Math.abs(s.position.y);
            const maxD = Math.max(dx, dy);
            const newV = {...s.velocity};
            if (log.gameLog && log.gameLog.planet && log.gameLog.planet.radius >= 0) {
                if (dx === maxD)
                    newV.x -= Math.sign(s.position.x);
                if (dy === maxD)
                    newV.y -= Math.sign(s.position.y);
            }
            s.velocity = newV;
            s.position = {x: s.position.x + s.velocity.x, y: s.position.y + s.velocity.y};
            points.push(s.position);
        }
        return points;
    }

    function toScreenX(gameX: number) {
        const originX = canvas.width / 2 - cellSize / 2;
        return originX + gameX * cellSize;
    }

    function toScreenY(gameY: number) {
        const originY = canvas.height / 2 - cellSize / 2;
        return originY + gameY * cellSize;
    }

    function createRect(gameX: number, gameY: number, radius = 0) {
        const res = new Path2D();
        let size = (2 * radius + 1) * cellSize;
        let left = toScreenX(gameX - radius);
        let top = toScreenY(gameY - radius);
        const minSize = 4;
        if (size < minSize) {
            left -= (minSize - size) / 2;
            top -= (minSize - size) / 2;
            size = minSize;
        }
        res.rect(left, top, size, size);
        return res;
    }
}

function convertGameLog(data: ILogData): IGameLogs {
    return {
        isSucceeded: data[0],
        gameType: data[1],
        gameStatus: data[2],
        ticks: data[3],
        players: data[4].map(convertPlayer),
        gameLog: data[5] && data[5][0] !== 0
            ? convertLogItem(data[5])
            : undefined,
    };
}

function convertPlayer(data: number[]): IPlayer {
    return {
        role: data[0],
        score: data[1],
        status: data[2],
    }
}

function convertLogItem(data: any[]): ApiGameLog {
    return {
        planet: data[0] && data[0][1] ? convertPlanet(data[0]) : undefined,
        ticks: data[1].map(convertTick),
    }
}

function convertPlanet(data: number[]): IPlanet {
    return {
        radius: data[0],
        safeRadius: data[1],
    }
}

function convertTick(data: any[]): ITick {
    return {
        tick: data[0],
        ships: data[1].map(createShipAndCommands)
    };
}

function createShipAndCommands(data: any[]): IShipAndCommands {
    return {
        ship: convertShip(data[0]),
        appliedCommands: data[1],
    }
}

function convertShip(data: any[]): IShip {
    return {
        role: data[0],
        shipId: data[1],
        position: {x: data[2][0], y: data[2][1]},
        velocity: {x: data[3][0], y: data[3][1]},
        x4: data[4],
        x5: data[5],
        x6: data[6],
        x7: data[7],
    };
}

function getShootRadius(power: number, powerDecrease: number) {
    return 1;
    // let r = 0;
    // let p = power;
    // while (p !== 0) {
    //     r++;
    //     p = Math.floor(p / powerDecrease);
    // }
    // return r - 1;
}

function shipColor(ship: IShip) {
    return ship.role === ApiPlayerRole.Defender ? 'teal' : 'orange';
}


// ------------ Models ----------------- 

export type ILogData = [0 | 1, ApiGameType, ApiGameStatus, number, number[][], any[]];

interface IGameLogs {
    isSucceeded: 0 | 1;
    gameType: ApiGameType;
    gameStatus: ApiGameStatus;
    ticks: number;
    players: IPlayer[];
    gameLog?: ApiGameLog
}

enum ApiGameType {
    AttackDefense = 0,
    Tutorial_Fly = 1,
    Tutorial_Detonate = 2,
    Tutorial_Burn = 3,
    Tutorial_BurnWithOverheat = 4,
    Tutorial_Radiators = 5,
    Tutorial_ShootOne = 6,
    Tutorial_ShootZeroTempTarget = 7,
    Tutorial_ShootAttackers = 8,
    Tutorial_FlyAndShootTarget = 9,
    Tutorial_Split = 10,
    Tutorial_Planet = 11,
    Tutorial_ShootSatellite = 12,
    Tutorial_KillDefenderBoss = 13,
}

enum ApiGameStatus {
    New = 0,
    Joined = 1,
    InProgress = 2,
    Finished = 3
}

interface IPlayer {
    role: ApiPlayerRole;
    score: number;
    status: ApiPlayerStatus;
}

enum ApiPlayerStatus {
    NotJoined = 0,
    Thinking = 1,
    ReadyToGo = 2,
    Won = 3,
    Lost = 4,
    Tied = 5,
}

interface ApiGameLog {
    planet?: IPlanet;
    ticks: ITick[];
}

interface IPlanet {
    radius: number;
    safeRadius: number;
}

interface ITick {
    tick: number;
    ships: IShipAndCommands[];
}

interface IShipAndCommands {
    ship: IShip;
    appliedCommands: any[];
}

interface IShip {
    role: ApiPlayerRole;
    shipId: number;
    position: V;
    velocity: V;
    x4: number[];
    x5: number;
    x6: number;
    x7: number;
}

interface V {
    x: number;
    y: number;
}

type ICommand = IDetonateCommand | ILaserCommand;

interface IDetonateCommand {
    type: ApiCommandType.Detonate;
    payload: [number, number];
}

interface ILaserCommand {
    type: ApiCommandType.Shoot;
    payload: [[number, number], number, number, number];
}
