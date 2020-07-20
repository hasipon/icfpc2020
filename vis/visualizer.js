var __assign = (this && this.__assign) || Object.assign || function(t) {
    for (var s, i = 1, n = arguments.length; i < n; i++) {
        s = arguments[i];
        for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p))
            t[p] = s[p];
    }
    return t;
};
var ApiCommandType;
(function (ApiCommandType) {
    ApiCommandType[ApiCommandType["BurnFuel"] = 0] = "BurnFuel";
    ApiCommandType[ApiCommandType["Detonate"] = 1] = "Detonate";
    ApiCommandType[ApiCommandType["Shoot"] = 2] = "Shoot";
    ApiCommandType[ApiCommandType["SplitShip"] = 3] = "SplitShip";
})(ApiCommandType || (ApiCommandType = {}));
var ApiPlayerRole;
(function (ApiPlayerRole) {
    ApiPlayerRole[ApiPlayerRole["Attacker"] = 0] = "Attacker";
    ApiPlayerRole[ApiPlayerRole["Defender"] = 1] = "Defender";
})(ApiPlayerRole || (ApiPlayerRole = {}));
function run(logData, canvasDelta, done) {
    var canvasElement = document.getElementById("field");
    var consoleElement = document.getElementById("console");
    if (!canvasElement || !consoleElement)
        return;
    var canvas = canvasElement;
    var maybeCtx = canvas.getContext('2d');
    if (!maybeCtx)
        return;
    var ctx = maybeCtx;
    var cellSize = 10;
    var index = 0;
    var log = convertGameLog(logData);
    var showTrajectories = true;
    var autoPlayTimerId = 0;
    var timePerTick = 100;
    var resizeListener = function () {
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
    function keydown(ev) {
        if (!log.gameLog)
            return;
        var code = ev.code;
        //if (code === "ArrowRight" || code === "KeyD") {
        if (code === "ArrowRight") {
            rewind(1);
            stopAutoplay();
            //} else if (code === "ArrowLeft" || code === "KeyA") {
        }
        else if (code === "ArrowLeft") {
            rewind(-1);
            stopAutoplay();
        }
        else if (code === "Home" || code === "KeyQ") {
            index = 0;
            stopAutoplay();
        }
        else if (code === "End" || code === "KeyE") {
            index = log.gameLog.ticks.length - 1;
            stopAutoplay();
        }
        else if (code === "Equal")
            cellSize *= 1.2;
        else if (code === "Minus")
            cellSize /= 1.2;
        else if (code === "Comma") {
            timePerTick = Math.min(1000, timePerTick + 10);
            stopAutoplay();
            startAutoplay();
        }
        else if (code === "Period") {
            timePerTick = Math.max(20, timePerTick - 10);
            stopAutoplay();
            startAutoplay();
        }
        else if (code === "KeyP" || code === "Space") {
            if (autoPlayTimerId)
                stopAutoplay();
            else
                startAutoplay();
        }
        else
            return;
        ev.preventDefault();
        update();
    }
    function stopAutoplay() {
        clearTimeout(autoPlayTimerId);
        autoPlayTimerId = 0;
    }
    function startAutoplay() {
        autoPlayTimerId = setInterval(autoplayTick, timePerTick);
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
    function rewind(dir) {
        if (!log.gameLog)
            return;
        index = Math.min(log.gameLog.ticks.length - 1, Math.max(0, index + dir));
    }
    function update() {
        if (!log.gameLog)
            return;
        drawEvent(log.gameLog.ticks[index]);
    }
    function drawTrajectories(ships) {
        if (!showTrajectories)
            return;
        ctx.globalAlpha = 0.5;
        for (var _i = 0, ships_1 = ships; _i < ships_1.length; _i++) {
            var s = ships_1[_i];
            var points = simulate(s.ship, 15);
            var path = new Path2D();
            path.moveTo(toScreenX(s.ship.position.x + 0.5), toScreenY(s.ship.position.y + 0.5));
            for (var _a = 0, points_1 = points; _a < points_1.length; _a++) {
                var p = points_1[_a];
                var sx = toScreenX(p.x + 0.5);
                var sy = toScreenY(p.y + 0.5);
                path.lineTo(sx, sy);
            }
            ctx.strokeStyle = shipColor(s.ship);
            ctx.stroke(path);
        }
        ctx.globalAlpha = 1;
    }
    function drawEvent(tick) {
        var ships = tick.ships;
        adjustScale(ships);
        clearSpace();
        if (log.gameLog && log.gameLog.planet && log.gameLog.planet.safeRadius >= 0)
            drawSafePlace(log.gameLog.planet.safeRadius);
        if (log.gameLog && log.gameLog.planet && log.gameLog.planet.radius >= 0)
            drawPlanet(log.gameLog.planet.radius);
        drawTrajectories(ships);
        drawCommands(ships);
        for (var _i = 0, ships_2 = ships; _i < ships_2.length; _i++) {
            var ship = ships_2[_i];
            drawShip(ship.ship);
        }
        var consoleShips = "" + tick.tick;
        for (var _a = 0, ships_3 = ships; _a < ships_3.length; _a++) {
            var ship = ships_3[_a];
            consoleShips += "<p style=\"color: " + shipColor(ship.ship) + "\">" + JSON.stringify(ship) + "</p>";
        }
        if (consoleElement) {
            consoleElement.innerHTML = consoleShips;
        }
    }
    function drawLaser(ship, laserCommand) {
        var target = laserCommand.payload[0];
        var damage = laserCommand.payload[2];
        var damageDecreaseFactor = laserCommand.payload[3];
        var laser = new Path2D();
        laser.moveTo(toScreenX(ship.position.x + 0.5), toScreenY(ship.position.y + 0.5));
        laser.lineTo(toScreenX(target[0] + 0.5), toScreenY(target[1] + 0.5));
        ctx.fillStyle = "white";
        ctx.fill(createRect(target[0], target[1], getShootRadius(damage, damageDecreaseFactor)));
        ctx.strokeStyle = "yellow";
        ctx.stroke(laser);
    }
    function drawDetonation(ship, detonateCommand) {
        // const power = detonateCommand.payload[0];
        // const powerDecrease = detonateCommand.payload[1];
        // const r = power / powerDecrease - 1;
        var r = 10;
        ctx.fillStyle = "magenta";
        ctx.fill(createRect(ship.position.x, ship.position.y, r));
    }
    function drawCommands(ships) {
        for (var _i = 0, ships_4 = ships; _i < ships_4.length; _i++) {
            var ship = ships_4[_i];
            for (var _a = 0, _b = ship.appliedCommands; _a < _b.length; _a++) {
                var cmd = _b[_a];
                var appliedCommand = { type: cmd[0], payload: cmd.slice(1) };
                if (appliedCommand.type === ApiCommandType.Detonate)
                    drawDetonation(ship.ship, appliedCommand);
                else if (appliedCommand.type === ApiCommandType.Shoot)
                    drawLaser(ship.ship, appliedCommand);
            }
        }
    }
    function clearSpace() {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
    }
    function fitInScreen(pos) {
        var screenX = toScreenX(pos.x);
        var screenY = toScreenY(pos.y);
        return screenX > 0 && screenX < canvas.width && screenY > 0 && screenY < canvas.height;
    }
    function adjustScale(ships) {
        while (cellSize > 0.2 && ships.some(function (s) { return !fitInScreen(s.ship.position); }))
            cellSize /= 1.2;
    }
    function drawPlanet(radius) {
        ctx.fillStyle = "white";
        ctx.fill(createRect(0, 0, radius));
    }
    function drawSafePlace(radius) {
        ctx.fillStyle = "rgb(0,0,0)";
        ctx.fill(createRect(0, 0, radius));
    }
    function drawShip(ship) {
        var pos = ship.position;
        ctx.fillStyle = shipColor(ship);
        ctx.fill(createRect(pos.x, pos.y));
    }
    function simulate(ship, ticks) {
        var points = [];
        var s = {
            position: ship.position,
            velocity: ship.velocity,
        };
        for (var i = 0; i < ticks; i++) {
            var dx = Math.abs(s.position.x);
            var dy = Math.abs(s.position.y);
            var maxD = Math.max(dx, dy);
            var newV = __assign({}, s.velocity);
            if (log.gameLog && log.gameLog.planet && log.gameLog.planet.radius >= 0) {
                if (dx === maxD)
                    newV.x -= Math.sign(s.position.x);
                if (dy === maxD)
                    newV.y -= Math.sign(s.position.y);
            }
            s.velocity = newV;
            s.position = { x: s.position.x + s.velocity.x, y: s.position.y + s.velocity.y };
            points.push(s.position);
        }
        return points;
    }
    function toScreenX(gameX) {
        var originX = canvas.width / 2 - cellSize / 2;
        return originX + gameX * cellSize;
    }
    function toScreenY(gameY) {
        var originY = canvas.height / 2 - cellSize / 2;
        return originY + gameY * cellSize;
    }
    function createRect(gameX, gameY, radius) {
        if (radius === void 0) { radius = 0; }
        var res = new Path2D();
        var size = (2 * radius + 1) * cellSize;
        var left = toScreenX(gameX - radius);
        var top = toScreenY(gameY - radius);
        var minSize = 4;
        if (size < minSize) {
            left -= (minSize - size) / 2;
            top -= (minSize - size) / 2;
            size = minSize;
        }
        res.rect(left, top, size, size);
        return res;
    }
}
function convertGameLog(data) {
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
function convertPlayer(data) {
    return {
        role: data[0],
        score: data[1],
        status: data[2],
    };
}
function convertLogItem(data) {
    return {
        planet: data[0] && data[0][1] ? convertPlanet(data[0]) : undefined,
        ticks: data[1].map(convertTick),
    };
}
function convertPlanet(data) {
    return {
        radius: data[0],
        safeRadius: data[1],
    };
}
function convertTick(data) {
    return {
        tick: data[0],
        ships: data[1].map(createShipAndCommands)
    };
}
function createShipAndCommands(data) {
    return {
        ship: convertShip(data[0]),
        appliedCommands: data[1],
    };
}
function convertShip(data) {
    return {
        role: data[0],
        shipId: data[1],
        position: { x: data[2][0], y: data[2][1] },
        velocity: { x: data[3][0], y: data[3][1] },
        x4: data[4],
        x5: data[5],
        x6: data[6],
        x7: data[7],
    };
}
function getShootRadius(power, powerDecrease) {
    return 1;
    // let r = 0;
    // let p = power;
    // while (p !== 0) {
    //     r++;
    //     p = Math.floor(p / powerDecrease);
    // }
    // return r - 1;
}
function shipColor(ship) {
    return ship.role === ApiPlayerRole.Defender ? 'teal' : 'orange';
}
var ApiGameType;
(function (ApiGameType) {
    ApiGameType[ApiGameType["AttackDefense"] = 0] = "AttackDefense";
    ApiGameType[ApiGameType["Tutorial_Fly"] = 1] = "Tutorial_Fly";
    ApiGameType[ApiGameType["Tutorial_Detonate"] = 2] = "Tutorial_Detonate";
    ApiGameType[ApiGameType["Tutorial_Burn"] = 3] = "Tutorial_Burn";
    ApiGameType[ApiGameType["Tutorial_BurnWithOverheat"] = 4] = "Tutorial_BurnWithOverheat";
    ApiGameType[ApiGameType["Tutorial_Radiators"] = 5] = "Tutorial_Radiators";
    ApiGameType[ApiGameType["Tutorial_ShootOne"] = 6] = "Tutorial_ShootOne";
    ApiGameType[ApiGameType["Tutorial_ShootZeroTempTarget"] = 7] = "Tutorial_ShootZeroTempTarget";
    ApiGameType[ApiGameType["Tutorial_ShootAttackers"] = 8] = "Tutorial_ShootAttackers";
    ApiGameType[ApiGameType["Tutorial_FlyAndShootTarget"] = 9] = "Tutorial_FlyAndShootTarget";
    ApiGameType[ApiGameType["Tutorial_Split"] = 10] = "Tutorial_Split";
    ApiGameType[ApiGameType["Tutorial_Planet"] = 11] = "Tutorial_Planet";
    ApiGameType[ApiGameType["Tutorial_ShootSatellite"] = 12] = "Tutorial_ShootSatellite";
    ApiGameType[ApiGameType["Tutorial_KillDefenderBoss"] = 13] = "Tutorial_KillDefenderBoss";
})(ApiGameType || (ApiGameType = {}));
var ApiGameStatus;
(function (ApiGameStatus) {
    ApiGameStatus[ApiGameStatus["New"] = 0] = "New";
    ApiGameStatus[ApiGameStatus["Joined"] = 1] = "Joined";
    ApiGameStatus[ApiGameStatus["InProgress"] = 2] = "InProgress";
    ApiGameStatus[ApiGameStatus["Finished"] = 3] = "Finished";
})(ApiGameStatus || (ApiGameStatus = {}));
var ApiPlayerStatus;
(function (ApiPlayerStatus) {
    ApiPlayerStatus[ApiPlayerStatus["NotJoined"] = 0] = "NotJoined";
    ApiPlayerStatus[ApiPlayerStatus["Thinking"] = 1] = "Thinking";
    ApiPlayerStatus[ApiPlayerStatus["ReadyToGo"] = 2] = "ReadyToGo";
    ApiPlayerStatus[ApiPlayerStatus["Won"] = 3] = "Won";
    ApiPlayerStatus[ApiPlayerStatus["Lost"] = 4] = "Lost";
    ApiPlayerStatus[ApiPlayerStatus["Tied"] = 5] = "Tied";
})(ApiPlayerStatus || (ApiPlayerStatus = {}));
