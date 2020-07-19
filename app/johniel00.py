import math
from functools import reduce
from lib import modulate, demodulate_v2, conv, conv_cons, calc_orbit, calc_life, calc_plan

class Ship:
    def __init__(self, role, shipId, pos, v, param, x5, x6, x7):
        self.role = role
        self.shipId = shipId
        self.pos = pos
        self.v = v
        self.param = param
        self.x5 = x5
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

        self.histories = {}
        self.turn = 0
        self.last_shot = 0;

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
        for (role, shipId, p, v, param, x5, x6, x7), appliedCommands in self.ships_data:
            ship = Ship(role, shipId, p, v, param, x5, x6, x7)
            if shipId not in self.histories:
                self.histories[shipId] = []
            self.histories[shipId].append(ship)
            if role == self.my_role:
                my_ship_id = shipId
                my_p = p
                my_v = v
                own_ship = ship

        print("TURN:", self.turn)
        print(self.turn - self.last_shot)
        res = []
        if 5 < self.turn - self.last_shot:
            for key in self.histories:
                if key == my_ship_id:
                    continue
                val = self.histories[key]
                print(self.ship_distance(own_ship, val[-1]))
                print(self.ship_distance(own_ship, val[-1]) < 50.0)
                print(self.is_enemy_stopping(val))
                if self.ship_distance(own_ship, val[-1]) < 50.0 and self.is_enemy_stopping(val):
                    res.append([2, my_ship_id, val[0].pos, 70])
                    self.last_shot = self.turn
                    break
        self.turn += 1

        if self.game_tick == 0:
            self.plan = calc_plan(my_p, my_v, self.max_turn, self.radius)
            print('plan:', self.plan)

        if self.game_tick < len(self.plan):
            res.append([0, my_ship_id, self.plan[self.game_tick]])

        return res
