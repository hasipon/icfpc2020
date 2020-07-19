class GameLogic:
    def __init__(self):
        self.my_role = None
        self.game_response = None

    def send_join(self):
        return []

    def recv_join(self, join_response):
        static_game_info = join_response[2]
        self.my_role = static_game_info[1]
        if self.my_role == 0:
            # i am attacker
            pass
        else:
            # i am defender
            pass

    def send_start(self):
        return [446, 0, 0, 1]

    def recv_commands(self, data):
        self.game_response = data

    def send_commands(self):
        my_ship_id = None
        for (role, shipId, position, velocity, x4, x5, x6, x7), appliedCommands in self.game_response[3][2]:
            if role == self.my_role:
                my_ship_id = shipId

        print(f'my_ship_id = {my_ship_id}')

        return [[0, my_ship_id, (1, 1)]]
