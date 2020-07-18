
#!/usr/bin/env python3

import sys
from typing import *


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


if __name__ == "__main__":
    for line in sys.stdin:
        if not line.strip():
            break
        print(demodulate(line))
