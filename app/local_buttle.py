import importlib
import os
import subprocess
import threading

import requests
from lib import modulate, demodulate_v2, conv, conv_cons


def main():
    server_url = "https://icfpc2020-api.testkontur.ru"
    api_key = os.getenv("APIKEY")

    def send(send_data):
        assert api_key is not None
        print('request:', send_data)
        modulated = modulate(send_data)
        print('mod request:', modulated)
        res = requests.post(f'{server_url}/aliens/send?apiKey={api_key}', data=modulated)
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

    print("send CREATE")
    response = send([1, 0])
    attacker_player_key = str(response[1][0][1])
    defender_player_key = str(response[1][1][1])

    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    print(os.getcwd())
    a = subprocess.Popen(f'PLAYERKEY={attacker_player_key} APIKEY={api_key} AI_NAME={os.getenv("ATTACKER_AI_NAME")} python local_main.py > ../logs/attacker_log 2> ../logs/attacker_err_log', shell=True)
    d = subprocess.Popen(f'PLAYERKEY={defender_player_key} APIKEY={api_key} AI_NAME={os.getenv("DEFENDER_AI_NAME")} python local_main.py > ../logs/defender_log 2> ../logs/defender_err_log', shell=True)
    a.communicate()
    d.communicate()
    print(send([5, int(attacker_player_key)]))

if __name__ == '__main__':
    main()