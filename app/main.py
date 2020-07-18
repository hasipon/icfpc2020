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


def main():
    server_url = sys.argv[1]
    player_key = int(sys.argv[2])
    print('ServerUrl: %s; PlayerKey: %s' % (server_url, player_key))

    def send(send_data):
        res = requests.post(f'{server_url}/aliens/send', data=send_data)
        if res.status_code != 200:
            print('Unexpected server response:')
            print('HTTP code:', res.status_code)
            print('Response body:', res.text)
            exit(2)
        print('Server response:', res.text)
        return res.text

    print("send JOIN")
    join_request = modulate([2, player_key, []])
    print(f"join_request = {repr(join_request)}")

    send(join_request)


if __name__ == '__main__':
    main()
