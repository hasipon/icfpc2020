import os
import pickle
from pathlib import Path

import requests
import sys
import time

from collections import namedtuple
from modulate import modulate

sys.setrecursionlimit(100000)

baseurl = 'https://icfpc2020-api.testkontur.ru'
apikey = os.getenv('APIKEY')
assert apikey is not None


def call_send_api(data) -> str:
    r = requests.post(f'{baseurl}/aliens/send?apiKey={apikey}', data=data)
    time.sleep(0.5)
    assert r.status_code == 200
    return r.text


class Atom:
    def __init__(self, name):
        self.Name = name
        self.Evaluated = None

    def __repr__(self):
        return f'Atom({repr(self.Name)})'

    def __str__(self):
        return f'({self.Name})'


class Ap:
    def __init__(self, fun, arg):
        self.Fun = fun
        self.Arg = arg
        self.Evaluated = None

    def __repr__(self):
        return f'Ap({repr(self.Fun)}, {repr(self.Arg)})'

    def __str__(self):
        return f'{str(self.Fun)}({str(self.Arg)})'


class Vect(namedtuple('Vect', ['X', 'Y'])):
    __slots__ = ()


def conv(a, idx):
    if a[idx] == 'ap':
        v1, idx1 = conv(a, idx+1)
        v2, idx2 = conv(a, idx1)
        return Ap(v1, v2), idx2
    else:
        return Atom(a[idx]), idx+1


def load_functions():
    res = {}
    with open('galaxy.txt') as f:
        for x in f:
            a = x.rstrip('\n').split(' = ')
            assert len(a) == 2
            r, _ = conv(a[1].split(' '), 0)
            res[a[0]] = r
    return res


cons = Atom("cons")
t = Atom("t")
f = Atom("f")
nil = Atom("nil")
functions = load_functions()


def evalCons(a, b):
    res = Ap(Ap(cons, evalloop(a)), evalloop(b))
    res.Evaluated = res
    return res


def asNum(n):
    assert isinstance(n, Atom)
    return int(n.Name)


def div(v1: int, v2: int):
    assert v2 != 0
    if v2 < 0:
        v1 = -v1
        v2 = -v2
    if v1 < 0:
        return -((-v1) // v2)
    else:
        return v1 // v2


def tryEval(expr):
    if expr.Evaluated is not None:
        return expr.Evaluated
    if isinstance(expr, Atom):
        if expr.Name in functions:
            return functions[expr.Name]
    if isinstance(expr, Ap):
        fun = evalloop(expr.Fun)
        x = expr.Arg
        if isinstance(fun, Atom):
            if fun.Name == "neg": return Atom(-asNum(evalloop(x)))
            if fun.Name == "i": return x
            if fun.Name == "nil": return t
            if fun.Name == "isnil": return Ap(x, Ap(t, Ap(t, f)))
            if fun.Name == "car": return Ap(x, t)
            if fun.Name == "cdr": return Ap(x, f)
        if isinstance(fun, Ap):
            fun2 = evalloop(fun.Fun)
            y = fun.Arg
            if isinstance(fun2, Atom):
                if fun2.Name == "t": return y
                if fun2.Name == "f": return x
                if fun2.Name == "add": return Atom(asNum(evalloop(x)) + asNum(evalloop(y)))
                if fun2.Name == "mul": return Atom(asNum(evalloop(x)) * asNum(evalloop(y)))
                if fun2.Name == "div": return Atom(div(asNum(evalloop(y)), asNum(evalloop(x))))
                if fun2.Name == "lt": return t if asNum(evalloop(y)) < asNum(evalloop(x)) else f
                if fun2.Name == "eq": return t if asNum(evalloop(x)) == asNum(evalloop(y)) else f
                if fun2.Name == "cons": return evalCons(y, x)
            if isinstance(fun2, Ap):
                fun3 = evalloop(fun2.Fun)
                z = fun2.Arg
                if isinstance(fun3, Atom):
                    if fun3.Name == "s": return Ap(Ap(z, x), Ap(y, x))
                    if fun3.Name == "c": return Ap(Ap(z, x), y)
                    if fun3.Name == "b": return Ap(z, Ap(y, x))
                    if fun3.Name == "cons": return Ap(Ap(x, z), y)
    return expr


def evalloop(expr):
    if expr.Evaluated is not None:
        return expr.Evaluated
    initialExpr = expr
    while True:
        result = tryEval(expr)
        if result == expr:
            initialExpr.Evaluated = result
            return result
        expr = result


def iterate(v0):
    a = []
    while True:
        if isinstance(v0, Atom):
            assert v0.Name == 'nil'
            break
        assert isinstance(v0, Ap)
        v1 = v0.Fun
        assert isinstance(v1, Ap)
        v2 = v1.Fun
        assert isinstance(v2, Atom)
        assert v2.Name == 'cons'
        v3 = v1.Arg
        a.append(v3)
        v0 = v0.Arg
    return a


def get_cood(v0):
    assert isinstance(v0, Ap)
    v1 = v0.Fun
    assert isinstance(v1, Ap)
    v2 = v1.Fun
    assert isinstance(v2, Atom)
    assert v2.Name == 'cons'
    x = v1.Arg
    y = v0.Arg
    assert isinstance(x, Atom)
    assert isinstance(y, Atom)
    return int(x.Name), int(y.Name)


def get_image(v0):
    while True:
        if isinstance(v0, Atom):
            assert v0.Name == 'nil'
            break
        assert isinstance(v0, Ap)
        v1 = v0.Fun
        assert isinstance(v1, Ap)
        v2 = v1.Fun
        assert isinstance(v2, Atom)
        assert v2.Name == 'cons'
        v3 = v1.Arg
        yield get_cood(v3)
        v0 = v0.Arg


def get_images(v0):
    while True:
        if isinstance(v0, Atom):
            assert v0.Name == 'nil'
            break
        assert isinstance(v0, Ap)
        v1 = v0.Fun
        assert isinstance(v1, Ap)
        v2 = v1.Fun
        assert isinstance(v2, Atom)
        assert v2.Name == 'cons'
        v3 = v1.Arg
        yield list(get_image(v3))
        v0 = v0.Arg


def read_data(v0):
    if isinstance(v0, Atom):
        if v0.Name == 'nil':
            return []
        return int(v0.Name)
    assert isinstance(v0, Ap)
    a = []
    for x in iterate(v0):
        a.append(read_data(x))
    return a


def serialize(v):
    if v is None:
        yield 'nil'
    elif isinstance(v, int):
        yield v
    else:
        for x in v:
            yield 'ap'
            yield 'ap'
            yield 'cons'
            for y in serialize(x):
                yield y
        yield 'nil'


def demodulate_v2(s: str):
    i = 0
    while i < len(s):
        prefix = s[i:i+2]
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
                v = int(s[i:i+width], 2)
            if prefix == '01':
                yield v
            else:
                yield -v
            i += width
    assert i == len(s)


def send(data):
    req_data = read_data(data)
    print(f'req_data={repr(req_data)}')
    modulated = modulate(req_data)
    print(f'modulated={repr(modulated)}')
    response = call_send_api(modulated)
    print(f'response={repr(response)}')
    demodulated = list(demodulate_v2(response))
    event_data, _ = conv(demodulated, 0)
    return event_data


def interact(state, event):
    while True:
        res = evalloop(Ap(Ap(Atom(":1338"), state), event))
        # Note: res will be modulatable here (consists of cons, nil and numbers only)
        flag, state, data = list(iterate(res))
        if asNum(flag) == 0:
            return state, data
        assert asNum(flag) == 1
        event = send(data)


def input_vect():
    while True:
        try:
            x = int(input('x: '))
        except ValueError:
            continue
        break

    while True:
        try:
            y = int(input('y: '))
        except ValueError:
            continue
        break

    return Vect(x, y)


def main():
    state = nil
    vector = Vect(0, 0)
    history = []
    while True:
        print("counter: ", len(history))
        history.append(f'{vector.X}_{vector.Y}')
        pp = Path('rcache_v2') / '_'.join(history)
        ok = False
        if pp.exists():
            with pp.open() as fp:
                try:
                    state_tmp = pickle.loads(eval(fp.readline()))
                    state = state_tmp
                    ok = True
                    while True:
                        line = fp.readline()
                        if not line:
                            break
                        print(eval(line))
                except MemoryError:
                    pass
        if not ok:
            with pp.open('w') as fp:
                state, images = interact(state, Ap(Ap(cons, Atom(vector.X)), Atom(vector.Y)))
                fp.write(f'{repr(pickle.dumps(state))}\n')
                for image in get_images(images):
                    print(image)
                    fp.write(f'{repr(image)}\n')
        print('----', flush=True)
        vector = input_vect()


main()
