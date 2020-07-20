import datetime
import importlib
import os
import subprocess
import threading
import json
import base64
import time
from pathlib import Path

import requests
from lib import modulate, demodulate_v2, conv, conv_cons


def main():
    server_url = "https://icfpc2020-api.testkontur.ru"
    api_key = os.getenv("APIKEY")

    def send(send_data):
        assert api_key is not None
        modulated = modulate(send_data)
        res = requests.post(f'{server_url}/aliens/send?apiKey={api_key}', data=modulated)
        if res.status_code != 200:
            print('Unexpected server response:')
            print('HTTP code:', res.status_code)
            print('Response body:', res.text)
            exit(2)
        res_data, _ = conv(list(demodulate_v2(res.text)), 0)
        converted = conv_cons(res_data)
        return converted

    response = send([1, 0])
    attacker_player_key = str(response[1][0][1])
    defender_player_key = str(response[1][1][1])

    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    now = (datetime.datetime.utcnow() + datetime.timedelta(hours=9)).strftime("%Y%m%d_%H%M%S")
    print(now)
    a = subprocess.Popen(f'PLAYERKEY={attacker_player_key} APIKEY={api_key} AI_NAME={os.getenv("ATTACKER_AI_NAME")} python3 local_main_cheat_test.py > ../logs/attacker_log_{now} 2> ../logs/attacker_err_log_{now}', shell=True)
    d = subprocess.Popen(f'PLAYERKEY={defender_player_key} APIKEY={api_key} AI_NAME={os.getenv("DEFENDER_AI_NAME")} python3 local_main_cheat_test.py > ../logs/defender_log_{now} 2> ../logs/defender_err_log_{now}', shell=True)
    a.communicate()
    d.communicate()
    print(Path(f'../logs/attacker_log_{now}').read_text())
    return

if __name__ == '__main__':
    main()