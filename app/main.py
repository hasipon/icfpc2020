import os

import requests
import sys
from typing import *


def modulate(o: Any) -> str:
    if isinstance(o, int):
        n = int(o)
        if n == 0:
            return "010"

        positive = 0 <= n
        n = abs(n)
        ans = ""

        if positive:
            ans += "01"
        else:
            ans += "10"

        width = 1 + (n.bit_length()-1)//4
        ans += "1" * width + "0"
        nstr = "{:b}".format(n)
        ans += "0" * (width * 4 - len(nstr)) + nstr
        return ans

    elif isinstance(o, Iterable):
        ans = ""
        for e in o:
            ans += "11" + modulate(e)
        ans += "00"
        return ans

    else:
        raise ValueError("unsupported object type")


def demodulate_num(s: str) -> (int, str):
    prefix = s[0:2]
    s = s[2:]
    width = s.find("0")
    if width == 0:
        return 0, s[1:]
    s = s[width+1:]
    num = int(s[:width*4], 2)
    s = s[width*4:]
    if prefix == "10":
        num *= -1
    return num, s


def demodulate_one(s: str) -> (Any, str):
    if len(s) < 2:
        raise ValueError("invalid length")

    prefix = s[0:2]
    if prefix == "11":
        ans = []
        while s[0:2] == "11":
            s = s[2:] # trim 11
            v, t = demodulate_one(s)
            ans.append(v)
            s = t
        if s[0:2] == "00":
            s = s[2:] # trim 00
        else:
            raise ValueError("expected nil but got", s)

        return ans, s
    elif prefix == "00":
        return None, s[2:]
    else:
        return demodulate_num(s)


def demodulate(s: str):
    ans, t = demodulate_one(s.strip())
    if t:
        raise ValueError("there are leftovers", t)
    return ans


def main():
    server_url = ""
    player_key = ""
    api_key = ""
    if len(sys.argv) >= 2:
        server_url = sys.argv[1]
        player_key = int(sys.argv[2])
    else:
        server_url = "https://icfpc2020-api.testkontur.ru"
        player_key = int(1113939892088752268)
        api_key = os.getenv("APIKEY")

    print('ServerUrl: %s; PlayerKey: %s' % (server_url, player_key))

    def send(send_data):
        res = requests.post(f'{server_url}/aliens/send?apiKey={api_key}', data=send_data)
        if res.status_code != 200:
            print('Unexpected server response:')
            print('HTTP code:', res.status_code)
            print('Response body:', res.text)
            exit(2)
        print('Server response:', res.text)
        demodulated = demodulate(res.text)
        print('demodulated Server response:', demodulated)
        return demodulated

    print("send JOIN")
    join_request = modulate([2, player_key, []])
    print(f"join_request = {repr(join_request)}")

    game_response = send(join_request)

    print("send START")
    start_request = modulate([3, player_key, [1, 0, 0, 0]])
    print(f"start_request = {repr(start_request)}")

    game_response = send(start_request)


if __name__ == '__main__':
    main()
