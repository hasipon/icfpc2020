from typing import *


def modulate(o: Any) -> str:
    if isinstance(o, int):
        n = int(o)
        if n == 0:
            return "010"
        elif n > 0:
            head = "01"
        else:
            head = "10"
            n = -n
        width = 1 + (n.bit_length() - 1) // 4
        return head + "1" * width + "0" + ("{:0%db}" % (width * 4)).format(n)

    elif isinstance(o, list):
        ans = ""
        for e in o:
            ans += "11" + modulate(e)
        ans += "00"
        return ans

    elif isinstance(o, tuple):
        x, y = o
        return "11" + modulate(x) + modulate(y)

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