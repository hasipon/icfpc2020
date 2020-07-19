import os
import requests
import sys
from lib import modulate, demodulate_v2, conv, conv_cons
import importlib


def main():
    server_url = sys.argv[1]
    player_key = int(sys.argv[2])
    print('ServerUrl: %s; PlayerKey: %s' % (server_url, player_key))

    def send(send_data):
        print('request:', send_data)
        modulated = modulate(send_data)
        print('mod request:', modulated)
        res = requests.post(f'{server_url}/aliens/send', data=modulated)
        if res.status_code != 200:
            print('Unexpected server response:')
            print('HTTP code:', res.status_code)
            print('Response body:', res.text)
            exit(2)
        print('response:', res.text)
        res_data, _ = conv(list(demodulate_v2(res.text)), 0)
        converted = conv_cons(res_data)
        print('dem response:', converted)
        return converted

    logic = importlib.import_module(os.getenv("AI_NAME")).GameLogic()

    print("send JOIN")
    join_request = [2, player_key, logic.send_join()]
    join_response = send(join_request)
    if join_response[1] != 0:
        return
    logic.recv_join(join_response)

    print("send START")
    start_request = [3, player_key, logic.send_start()]
    game_response = send(start_request)
    logic.recv_commands(game_response)

    while True:
        if game_response[1] != 1:
            break

        print("send COMMANDS")
        commands_request = [4, player_key, logic.send_commands()]
        game_response = send(commands_request)
        logic.recv_commands(game_response)


if __name__ == '__main__':
    main()
