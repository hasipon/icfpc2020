class GameLogic:
    def __init__(self):
        self.my_role = None
        self.static_game_info = None
        self.game_response = None

    def send_join(self):
        return []

    def recv_join(self, join_response):
        static_game_info = join_response[2]
        self.static_game_info = static_game_info
        self.my_role = static_game_info[1]
        if self.my_role == 0:
            # i am attacker
            pass
        else:
            # i am defender
            pass

    def send_start(self):
        return [self.static_game_info[2][0] - 194, 0, 16, 1]

    def recv_commands(self, data):
        self.game_response = data

    def send_commands(self):
        my_ship_id = None
        tx, ty = 0, 0
        ax, ay = 0, 0
        fuel = None
        for (role, shipId, (px, py), (vx, vy), x4, x5, x6, x7), appliedCommands in self.game_response[3][2]:
            if role == self.my_role:
                my_ship_id = shipId
                fuel = x4[0]
                print(f'p=({px},{py}) v=({vx},{vy})')
                if abs(px) >= abs(py):
                    ax = -1 if px > 0 else 1
                if abs(px) <= abs(py):
                    ay = -1 if py > 0 else 1
                if vx + ax > 0:
                    tx = 1
                elif vx + ax < 0:
                    tx = -1
                if vy + ay > 0:
                    ty = 1
                elif vy + ay < 0:
                    ty = -1

        print(f'a=({ax},{ay})')
        print(f't=({tx},{ty})')
        print(f'fuel={fuel}')

        print(f'my_ship_id = {my_ship_id}')
        res = []
        if tx != 0 or ty != 0 and fuel > 0:
            res.append([0, my_ship_id, (tx, ty)])
        return res
