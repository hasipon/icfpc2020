import math
from functools import reduce
from lib import modulate, demodulate_v2, conv, conv_cons, calc_orbit, calc_life, calc_plan

class Ship:
    def __init__(role, shipId, pos, v, param, x5, x6, x7):
        self.role = role
        self.shipId = shipId
        self.pos = p
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

        self.enemy_position_history = []
        self.turn = 0

    def send_start(self):
        return [50, self.resource - (50 * 1) - (20 * 12),  20, 1]

    def recv_commands(self, data):
        if data[3] is not None:
            self.game_tick = data[3][0]
            self.ships_data = data[3][2]

    def is_enemy_stopping(self):
        return 10 < len(self.enemy_position_history) and reduce(lambda x, y: x and y, map(lambda x: x == self.enemy_position_history[-1], self.enemy_position_history))

    def register_enemy_history(self, e):
        self.enemy_position_history.append(e)

    def ship_distance(self, o, e):
        x = (e.pos[0] - o.pos[0])
        y = (e.pos[1] - o.pos[1])
        return math.sqrt(x * x + y * y)

    def send_commands(self):
        my_ship_id = None
        my_p = None
        my_v = None
        enemy_ship = None
        own_ship = None
        for (role, shipId, p, v, param, x5, x6, x7), appliedCommands in self.ships_data:
            if role == self.my_role:
                my_ship_id = shipId
                my_p = p
                my_v = v
                own_ship = Ship(role, shipId, p, v, param, x5, x6, x7)
            else:
                enemy_ship = Ship(role, shipId, p, v, param, x5, x6, x7)
        res = []

        self.register_enemy_history(enemy_ship)
        if self.turn % 10 == 0 and self.ship_distance(own_ship, enemy_ship) < 50.0 and self.is_enemy_stopping():
            res.append([2, enemy_ship.shipId, enemy_ship.pos, 100])

        if self.game_tick == 0:
            self.plan = calc_plan(my_p, my_v, self.max_turn, self.radius)
            print('plan:', self.plan)

        if self.game_tick < len(self.plan):
            res.append([0, my_ship_id, self.plan[self.game_tick]])

        self.turn += 1
        return res
