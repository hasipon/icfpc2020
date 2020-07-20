
from typing import *
import math
from functools import reduce
from lib import modulate, demodulate_v2, conv, conv_cons

directions = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]

def calc_orbit(p0: Tuple[int, int], v0: Tuple[int, int], aa: List[Tuple[int, int]], d: int):
    p = p0
    v = v0
    orbit = [p0]
    for i in range(d-1):
        ax, ay = 0, 0
        if abs(p[0]) >= abs(p[1]):
            ax = -1 if p[0] > 0 else 1
        if abs(p[0]) <= abs(p[1]):
            ay = -1 if p[1] > 0 else 1
        if i < len(aa):
            ax -= aa[i][0]
            ay -= aa[i][1]
        v = (v[0] + ax, v[1] + ay)
        p = (p[0] + v[0], p[1] + v[1])
        orbit.append(p)
    return orbit


def calc_life(orbit: List[Tuple[int, int]], radius: int):
    for i, p in enumerate(orbit):
        if max(abs(p[0]), abs(p[1])) <= radius:
            return i
    return len(orbit)


def calc_plan(my_p, my_v, max_turn, radius):
    plan = None
    life = -1
    for l in range(1, 4):
        for p in range(1 << (3 * l)):
            a = [directions[(p >> (3 * i)) & 7] for i in range(l)]
            orbit = calc_orbit(my_p, my_v, a, max_turn)
            b = calc_life(orbit, radius)
            if b == max_turn:
                return a, b
            if b > life:
                plan = a
                life = b
    return plan, life

class Param:
    def __init__(self, fuel, shoot, cooling, dup):
        self.fuel = fuel
        self.shoot = shoot
        self.cooling = cooling
        self.dup = dup

class P:
    def __init__(self, x, y):
        self.x = x
        self.y = y

class Ship:
    def __init__(self, role, ship_id, pos, v, param, heat, x6, x7):
        self.role = role
        self.ship_id = ship_id
        self.pos = pos
        self.v = v
        self.param = Param(param[0], param[1], param[2], param[3])
        self.heat = heat
        self.x6 = x6
        self.x7 = x7
    def next_position(self):
        return (self.pos[0] + self.v[0], self.pos[1] + self.v[1])

class GameLogic:
    def __init__(self, static_game_info):
        self.max_turn = static_game_info[0]
        self.my_role = static_game_info[1]
        self.resource = static_game_info[2][0]
        self.radius = None
        self.safe_radius = None
        if static_game_info[3] is not None:
            self.radius = static_game_info[3][0]
            self.safe_radius = static_game_info[3][1]
        self.game_tick = None
        self.ships_data = None
        self.plan = None
        self.plan_fixed = False

        self.histories = {}
        self.next_history = {}
        self.laser_enabled = True
        self.target_id = None

    def send_start(self):
        return [20, (self.resource - (20 * 1) - (20 * 12) - (1 * 2)) // 4,  20, 1]

    def recv_commands(self, data):
        if data[3] is not None:
            self.game_tick = data[3][0]
            self.ships_data = data[3][2]

    def distance(self, a, b):
        x = (a[0] - b[0])
        y = (a[1] - b[1])
        return math.sqrt(x * x + y * y)

    def ship_distance(self, o, e):
        return self.distance(o.pos, e.pos)

    def laser_efficiency(self, th):
        return math.cos(th + 8.0) * math.cos(th * 24.0)

    def angle(self, x, y):
        return math.atan2(y, x)

    def send_commands(self):
        print(f'game_tick = {self.game_tick}', flush=True)
        if self.game_tick >= self.max_turn // 2 and self.my_role == 0:
            return self.send_commands2()
        else:
            return self.send_commands1()

    def send_commands1(self):
        my_ship_id = None
        my_p = None
        my_v = None
        own_ship = None

        current_ship_ids = set([])
        for (role, ship_id, p, v, param, heat, x6, x7), appliedCommands in self.ships_data:
            current_ship_ids.add(ship_id)

            ship = Ship(role, ship_id, p, v, param, heat, x6, x7)
            if ship_id not in self.histories:
                self.histories[ship_id] = []
                self.next_history[ship_id] = []
            self.histories[ship_id].append(ship)
            if role == self.my_role:
                my_ship_id = ship_id
                my_p = p
                my_v = v
                own_ship = ship

        for key in list(self.histories.keys()):
            if key not in current_ship_ids:
                self.histories.pop(key)
                self.next_history.pop(key)

        if 64 <= own_ship.heat:
            self.laser_enabled = False

        if self.target_id not in current_ship_ids:
            self.target_id = None

        res = []

        if not self.plan_fixed:
            self.plan, tt = calc_plan(my_p, my_v, self.max_turn - self.game_tick, self.radius)
            if tt == self.max_turn - self.game_tick:
                self.plan_fixed = True
            self.plan = [-1] * self.game_tick + self.plan
            print('plan:', self.plan, 'tt:', tt)

        if self.game_tick < len(self.plan):
            res.append([0, my_ship_id, self.plan[self.game_tick]])

        # 攻撃対象が決まっていなければ決める
        if own_ship.heat == 0 and self.laser_enabled and self.target_id is None:
            mx = -100
            for key in current_ship_ids:
                if key == my_ship_id:
                    continue
                enemy = self.histories[key][-1]
                npos = enemy.next_position()
                myship = self.histories[my_ship_id][-1]
                th = self.angle(npos[0] - myship.pos[0], npos[1] - myship.pos[1])
                eff = self.laser_efficiency(th)
                if mx < eff:
                    mx = eff
                    self.target_id = enemy.ship_id

        # 対象があれば攻撃する
        if own_ship.heat == 0 and self.laser_enabled and self.target_id is not None:
            enemy = self.histories[self.target_id][-1]
            npos = enemy.next_position()
            shooting_param = [2, my_ship_id, npos, 60]
            res.append(shooting_param)

        return res

    def send_commands2(self):
        my_ship_id, my_p, my_v, my_fuel = None, None, None, None
        enemies = []
        for (role, ship_id, p, v, param, heat, x6, x7), appliedCommands in self.ships_data:
            if role == self.my_role:
                my_ship_id = ship_id
                my_p = p
                my_v = v
                my_fuel = param[0]
            else:
                enemies.append((ship_id, p, v))

        if len(enemies) != 1:
            return self.send_commands1()
        en_shi_id, en_p, en_v = enemies[0]

        def dist(p0, p1):
            return max(abs(p0[0] - p1[0]), abs(p0[1] - p1[1]))

        def calc_score(a0, a1):
            for i, (p0, p1) in enumerate(zip(a0[2:], a1[2:])):
                if max(abs(p1[0]), abs(p1[1])) <= self.radius:
                    return 1 << 30
                if dist(p0, p1) <= 1:
                    return i
            return 1 << 30

        remaining_time = self.max_turn - self.game_tick
        enemy_orbit = calc_orbit(en_p, en_v, [], remaining_time)
        selected = None
        score = 1 << 30
        for l in range(0, 3):
            if l >= my_fuel - 3:
                break
            for p in range(1 << (3 * l)):
                a = [directions[(p >> (3 * i)) & 7] for i in range(l)]
                o = calc_orbit(my_p, my_v, a, remaining_time)
                if l == 0 and dist(enemy_orbit[1], o[1]) <= 1:
                    return [[1, my_ship_id]]
                s = calc_score(enemy_orbit, o) + (4 * l)
                if s < score:
                    selected = a
                    score = s
        print(f'score = {score} selected = {selected}')

        if selected:
            return [[0, my_ship_id, selected[0]]]

        return []
