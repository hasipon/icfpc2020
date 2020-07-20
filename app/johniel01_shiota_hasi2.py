
# 停止するAIを絶対に殺すマン

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

class Ship:
    def __init__(self, role, shipId, pos, v, param, heat, x6, x7):
        self.role = role
        self.shipId = shipId
        self.pos = pos
        self.v = v
        self.param = Param(param[0], param[1], param[2], param[3])
        self.heat = heat
        self.x6 = x6
        self.x7 = x7

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
        self.nextHistory = {}
        self.laser_enabled = True

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

    def is_enemy_stopping(self, ehistory):
        if len(ehistory) < 10:
            return False
        a = map(lambda x: self.ship_distance(x, ehistory[-1]) <= 5.0, ehistory[-10:])
        return reduce(lambda x, y: x and y, list(a))

    def send_commands(self):
        my_ship_id = None
        my_p = None
        my_v = None
        own_ship = None
        enemy_ship_id = None
        enemy_p = None
        enemy_v = None
        for (role, shipId, p, v, param, heat, x6, x7), appliedCommands in self.ships_data:
            ship = Ship(role, shipId, p, v, param, heat, x6, x7)
            if shipId not in self.histories:
                self.histories[shipId] = []
                self.nextHistory[shipId] = []
            self.histories[shipId].append(ship)
            if role == self.my_role:
                my_ship_id = shipId
                my_p = p
                my_v = v
                own_ship = ship
            else:
                enemy_ship_id = shipId
                enemy_p = p
                enemy_v = v

        if 64 <= own_ship.heat:
            self.laser_enabled = False

        if not self.plan_fixed:
            self.plan, tt = calc_plan(my_p, my_v, self.max_turn - self.game_tick, self.radius)
            if tt == self.max_turn - self.game_tick:
                self.plan_fixed = True
            self.plan = [-1] * self.game_tick + self.plan
            print('plan:', self.plan, 'tt:', tt)

        if self.game_tick < len(self.plan):
            return [[0, my_ship_id, self.plan[self.game_tick]]]

        if own_ship.heat == 0 and self.laser_enabled:
            target = (enemy_p[0] + enemy_v[0], enemy_p[1] + enemy_v[1])
            if self.distance(my_p, target) < 50.0:
                return [[2, my_ship_id, target, 60]]

        return []
