import os
from time import sleep

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

        width = 1 + (n.bit_length() - 1) // 4
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

    elif o is None:
        return "00"

    else:
        raise ValueError("unsupported object type" + type(o))


def demodulate_v2(s: str):
    i = 0
    while i < len(s):
        prefix = s[i:i + 2]
        i += 2
        if prefix == '00':
            yield 'nil'
        elif prefix == '11':
            yield 'ap'
            yield 'ap'
            yield 'cons'
        else:
            width = 0
            while s[i] != '0':
                width += 4
                i += 1
            i += 1
            if width == 0:
                v = 0
            else:
                v = int(s[i:i + width], 2)
            if prefix == '01':
                yield v
            else:
                yield -v
            i += width
    assert i == len(s)


class Atom(NamedTuple):
    Name: Any


class Ap(NamedTuple):
    Fun: Any
    Arg: Any


def conv(a, idx):
    if a[idx] == 'ap':
        v1, idx1 = conv(a, idx + 1)
        v2, idx2 = conv(a, idx1)
        return Ap(v1, v2), idx2
    else:
        return Atom(a[idx]), idx + 1


def conv_cons(v0):
    if isinstance(v0, Atom):
        if v0.Name == 'nil':
            return None
        return int(v0.Name)
    assert isinstance(v0, Ap)
    v1 = v0.Fun
    assert isinstance(v1, Ap)
    v2 = v1.Fun
    assert isinstance(v2, Atom)
    assert v2.Name == 'cons'
    x = conv_cons(v1.Arg)
    y = conv_cons(v0.Arg)
    if y is None:
        return [x]
    elif isinstance(y, list):
        return [x] + y
    else:
        return x, y


def main():
    server_url = ""
    player_key = ""
    api_key = ""
    if len(sys.argv) >= 2 and os.getenv("APKEY") is None:
        server_url = sys.argv[1]
        player_key = int(sys.argv[2])
    else:
        server_url = "https://icfpc2020-api.testkontur.ru"
        player_key = int(1113939892088752268)
        api_key = os.getenv("APIKEY")

    print('ServerUrl: %s; PlayerKey: %s' % (server_url, player_key))

    def send(send_data):
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

    counter = 0
    while True:
        counter += 1
        assert counter <= 20
        print("send JOIN")
        join_request = [2, player_key, []]
        join_response = send(join_request)
        if join_response[1] == 0:
            break
        sleep(0.5)

    print("send START")
    start_request = [3, player_key, [1, 0, 0, 0]]
    game_response = send(start_request)


if __name__ == '__main__':
    main()
