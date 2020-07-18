#!/usr/bin/env python3

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

    elif isinstance(o, List):
        ans = ""
        for e in o:
            ans += "11" + modulate(e)
        ans += "00"
        return ans

    else:
        raise ValueError("unsupported object type")


if __name__ == "__main__":
    for line in sys.stdin:
        if not line.strip():
            break

        o = eval(line) # dangerous

        print(modulate(o))
