from typing import *

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
    for l in range(0, 5):
        for p in range(1 << (3 * l)):
            a = [directions[(p >> (3 * i)) & 7] for i in range(l)]
            orbit = calc_orbit(my_p, my_v, a, max_turn)
            b = calc_life(orbit, radius)
            if b == max_turn:
                return a
            if b > life:
                plan = a
                life = b
    return plan


def calc_plan2(my_p, my_v, max_turn, radius):
    plan = None
    life = -1
    for l in range(0, 3):
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


class GameLogic:
    def __init__(self, static_game_info):
        self.max_turn = static_game_info[0]
        self.my_role = static_game_info[1]
        self.resource = static_game_info[2][0]
        # unknown static_game_info[2][1]
        # unknown static_game_info[2][2]
        self.radius = None
        self.safe_radius = None
        if static_game_info[3] is not None:
            self.radius = static_game_info[3][0]
            self.safe_radius = static_game_info[3][1]
        self.game_tick = None
        self.ships_data = None
        self.tmp_ship_ids = set()

    def send_start(self):
        x1 = 0
        x2 = 16
        x3 = 16
        x0 = self.resource - 4 * x1 - 12 * x2 - 2 * x3
        assert x0 >= 0
        return [x0, x1, x2, x3]

    def recv_commands(self, data):
        if data[3] is not None:
            self.game_tick = data[3][0]
            self.ships_data = data[3][2]

    def send_commands(self):
        my_ships = []
        for (role, shipId, p, v, x4, x5, x6, x7), appliedCommands in self.ships_data:
            if role == self.my_role:
                my_ships.append((shipId, p, v, x4))
        print('my_ships', my_ships)

        if self.game_tick < 3:
            my_ship_id, my_p, my_v, my_x4 = my_ships[0]
            plan = calc_plan(my_p, my_v, 20, self.radius)
            res = []
            for my_ship_id, my_p, my_v, my_x4 in my_ships:
                if plan:
                    res.append([0, my_ship_id, plan[0]])
                res.append([3, my_ship_id, [x // 2 for x in my_x4]])
            return res
        elif self.game_tick == 3:
            res = []
            for i, (my_ship_id, my_p, my_v, my_x4) in enumerate(my_ships):
                res.append([0, my_ship_id, directions[i]])
            return res
        elif self.game_tick == 4:
            res = []
            for my_ship_id, my_p, my_v, my_x4 in my_ships:
                plan = calc_plan(my_p, my_v, 20, self.radius)
                if plan:
                    res.append([0, my_ship_id, plan[0]])
                res.append([3, my_ship_id, [x // 2 for x in my_x4]])
                self.tmp_ship_ids.add(my_ship_id)
            return res
        elif self.game_tick == 5:
            res = []
            for my_ship_id, my_p, my_v, my_x4 in my_ships:
                res.append([0, my_ship_id, (1, 0) if my_ship_id in self.tmp_ship_ids else (-1, 0)])
                self.tmp_ship_ids.add(my_ship_id)
            return res
        elif self.game_tick >= 10:
            res = []
            for i, (my_ship_id, my_p, my_v, my_x4) in enumerate(my_ships):
                res.append([1, my_ship_id])
            return res
        else:
            res = []
            for my_ship_id, my_p, my_v, my_x4 in my_ships:
                if my_ship_id in self.tmp_ship_ids:
                    tt = self.max_turn - self.game_tick
                    plan, life = calc_plan2(my_p, my_v, tt, self.radius)
                    if plan and my_x4[0] > 0:
                        res.append([0, my_ship_id, plan[0]])
                    if life == tt:
                        print(f'survive: {my_ship_id}')
                        self.tmp_ship_ids.remove(my_ship_id)
                    elif my_x4[0] == 0:
                        print(f'empty: {my_ship_id}')
                        self.tmp_ship_ids.remove(my_ship_id)
            return res
