import os
import requests
import sys
import time

from collections import namedtuple
from demodulate import demodulate
from functools import reduce
from modulate import modulate
from pathlib import Path

sys.setrecursionlimit(100000)

baseurl = 'https://icfpc2020-api.testkontur.ru'
apikey = os.getenv('APIKEY')

def call_send_api(data) -> str:
    r = requests.post(f'{baseurl}/aliens/send?apiKey={apikey}', data=data)
    time.sleep(0.5)
    assert r.status_code == 200
    return r.text


class Node(namedtuple('Node', ['v'])):
    __slots__ = ()

    def __repr__(self):
        return f'Node({repr(self.v)})'

    def __str__(self):
        if isinstance(self.v, list):
            return '*' + ''.join(f'({str(x)})' for x in self.v)
        if isinstance(self.v, str) and self.v in {'c', 'b'}:
            return self.v
        return f'({self.v})'

    def __eq__(self, other):
        if isinstance(other, Node):
            return self.v == other.v
        else:
            return False

    def __hash__(self):
        if isinstance(self.v, list):
            r = 0
            for x in self.v:
                r ^= hash(x)
                r *= 3
            return r
        else:
            try:
                return hash(self.v)
            except:
                print('Node error', flush=True)
                sys.exit(1)

class Picture(namedtuple('Picture', ['v'])):
    __slots__ = ()

    def __repr__(self):
        return f'Picture({repr(self.v)})'

    def __str__(self):
        return f'(picture)'

    def __eq__(self, other):
        if isinstance(other, Picture):
            return self.v == other.v
        else:
            return False

    def __hash__(self):
        if isinstance(self.v, list):
            r = 0
            for x in self.v:
                r ^= hash(x)
                r *= 3
            return r
        else:
            print('Picture error', flush=True)
            sys.exit(1)

class Ap(namedtuple('Ap', ['v1', 'v2'])):
    __slots__ = ()

    def __repr__(self):
        return f'Ap({repr(self.v1)}, {repr(self.v2)})'

    def __str__(self):
        return f'{str(self.v1)}({str(self.v2)})'

    def __eq__(self, other):
        if isinstance(other, Ap):
            return self.v1 == other.v1 and self.v2 == other.v2
        else:
            return False

    def __hash__(self):
        try:
            h1 = hash(self.v1)
            h2 = hash(self.v2)
            return h1 ^ (3 * h2)
        except:
            print('Ap error', flush=True)
            sys.exit(1)

def conv(a, idx):
    if a[idx] == 'ap':
        v1, idx1 = conv(a, idx+1)
        v2, idx2 = conv(a, idx1)
        return Ap(v1, v2), idx2
    else:
        return Node(a[idx]), idx+1

class Main:
    def __init__(self):
        self.cache = {}
        self.galaxy = {}
        with open('galaxy.txt') as f:
            for x in f:
                a = x.rstrip('\n').split(' = ')
                assert len(a) == 2
                r, _ = conv(a[1].split(' '), 0)
                self.galaxy[a[0]] = r

        history = []
        x4 = Node('nil')
        counter = 0
        while True:
            print("counter: ", counter)
            counter += 1
            x = str(int(input('x: ')))
            y = str(int(input('y: ')))
            history.append(f'{x}_{y}')
            pp = Path('rcache') / '_'.join(history)
            if pp.exists():
                with pp.open() as f:
                    x4 = eval(f.readline())
                    while True:
                        line = f.readline()
                        if not line:
                            break
                        print(eval(line), flush=True)
            else:
                hoge = Ap(Ap(Ap(Node('interact'), Node(':1338')), x4), Ap(Ap(Node('cons'), Node(x)), Node(y)))
                result = self.evalloop(hoge)
                if isinstance(result, Node) and len(result.v) == 3 and result.v[0] == 'cons':
                    with pp.open('w') as f:
                        x4 = result.v[1]
                        f.write(f'{repr(x4)}\n')
                        drawings = self.evalloop(result.v[2])
                        if isinstance(drawings, Node) and len(drawings.v) == 3 and drawings.v[0] == 'cons':
                            pictures = self.evalloop(drawings.v[1])
                            while True:
                                print(pictures, flush=True)
                                f.write(f'{repr(pictures)}\n')
                                if isinstance(pictures, Node) and len(pictures.v) == 3 and pictures.v[0] == 'cons':
                                    assert isinstance(pictures.v[1], Picture)
                                    print(pictures.v[1].v, flush=True)
                                    f.write(f'{repr(pictures.v[1].v)}\n')
                                    pictures = self.evalloop(pictures.v[2])
                                else:
                                    break
                else:
                    print(result)
                    break
            print('----', flush=True)

    def evalloop(self, hoge):
        hoge0 = hoge
        if hoge0 in self.cache:
            return self.cache[hoge0]
        while True:
            # print(hoge)
            hoge1 = self.eval(hoge)
            if hoge1 is None:
                # print('input', hoge0)
                # print('output', hoge)
                self.cache[hoge0] = hoge
                return hoge
            hoge = hoge1

    def point(self, x):
        v1 = self.evalloop(x)
        assert isinstance(v1, Node)
        assert isinstance(v1.v, list)
        assert len(v1.v) == 3
        assert v1.v[0] == 'cons'
        r1 = self.evalloop(v1.v[1])
        r2 = self.evalloop(v1.v[2])
        assert isinstance(r1, Node)
        assert isinstance(r2, Node)
        return (int(r1.v), int(r2.v))

    def draw(self, x):
        result = []
        while True:
            v1 = self.evalloop(x)
            assert isinstance(v1, Node)
            if v1.v == 'nil':
                break
            assert isinstance(v1.v, list)
            assert len(v1.v) == 3
            assert v1.v[0] == 'cons'
            x0 = self.point(v1.v[1])
            result.append(x0)
            x = v1.v[2]
        # print(result)
        return Picture(result)

    def multipledraw(self, x):
        v1 = self.evalloop(x)
        assert isinstance(v1, Node)
        if v1.v == 'nil':
            return Node('nil')
        assert isinstance(v1.v, list)
        assert len(v1.v) == 3
        assert v1.v[0] == 'cons'
        x0 = self.draw(v1.v[1])
        x1 = v1.v[2]
        return Ap(Ap(Node('cons'), x0), Ap(Node('multipledraw'), x1))

    def cons_2_pyarray(self, x):
        x = self.evalloop(x)
        a = []
        while True:
            if str(x) == '(nil)':
                break
            a.append(self.evalloop(Ap(Node('car'), x)).v[0])
            x = self.evalloop(Ap(Node('cdr'), x))
        return list(map(int, a))

    def pyarray_2_cons(self, a):
        a.reverse()
        a = map(str, a)
        a, _ = conv(reduce(lambda x, y: ['ap', 'ap', 'cons', y] + x, a, ['nil']), 0)
        return a

    def eval(self, x):
        if isinstance(x, Ap):
            if isinstance(x.v1, Node):
                if isinstance(x.v1.v, str):
                    if x.v1.v[0] == ':':
                        return Ap(self.galaxy[x.v1.v], x.v2)
                    a = [x.v1.v, x.v2]
                else:
                    assert isinstance(x.v1.v, list)
                    a = x.v1.v + [x.v2]
                if a[0] == 'c':
                    if len(a) < 4:
                        return Node(a)
                    else:
                        # c x y z = x z y
                        return Ap(Ap(a[1], a[3]), a[2])
                elif a[0] == 'b':
                    if len(a) < 4:
                        return Node(a)
                    else:
                        # b x y z = x (y z)
                        return Ap(a[1], Ap(a[2], a[3]))
                elif a[0] == 's':
                    if len(a) < 4:
                        return Node(a)
                    else:
                        # s x y z = x z (y z)
                        return Ap(Ap(a[1], a[3]), Ap(a[2], a[3]))
                elif a[0] == 't':
                    if len(a) < 3:
                        return Node(a)
                    else:
                        # t x y = x
                        return a[1]
                elif a[0] == 'f':
                    if len(a) < 3:
                        return Node(a)
                    else:
                        # f x y = y
                        return a[2]
                elif a[0] == 'i':
                    if len(a) < 2:
                        return Node(a)
                    else:
                        # i x = x
                        return a[1]
                elif a[0] == 'cons':
                    if len(a) < 4:
                        return Node(a)
                    else:
                        # cons x y z = z x y
                        return Ap(Ap(a[3], a[1]), a[2])
                elif a[0] == 'interact':
                    if len(a) < 4:
                        return Node(a)
                    else:
                        # interact x y z = f38 x (x y z)
                        return Ap(Ap(Node('f38'), a[1]), Ap(Ap(a[1], a[2]), a[3]))
                elif a[0] == 'f38':
                    if len(a) < 3:
                        return Node(a)
                    else:
                        car = Node('car')
                        cdr = Node('cdr')
                        cons = Node('cons')
                        flag = self.evalloop(Ap(car, a[2]))
                        assert isinstance(flag, Node)
                        car_cdr_y = Ap(car, Ap(cdr, a[2]))
                        car_cdr_cdr_y = Ap(car, Ap(cdr, Ap(cdr, a[2])))
                        if flag.v == '0':
                            return Ap(Ap(cons, Ap(Node('i'), car_cdr_y)), Ap(Ap(cons, Ap(Node('multipledraw'), car_cdr_cdr_y)), Node('nil')))
                        if flag.v == '1':
                            print('send?', self.evalloop(car_cdr_cdr_y))
                            return Ap(Ap(Ap(Node('interact'), a[1]), Ap(Node('i'), car_cdr_y)), Ap(Node('send'), car_cdr_cdr_y))
                elif a[0] == 'send':
                    if len(a) < 2:
                        return Node(a)
                    else:
                        v1 = self.evalloop(a[1])
                        print(v1)
                        print(self.cons_2_pyarray(v1))
                        print(modulate(self.cons_2_pyarray(v1)))
                        response = call_send_api(modulate(self.cons_2_pyarray(v1)))
                        print(response)
                        print(demodulate(response))
                        print(self.pyarray_2_cons(demodulate(response)))
                        return self.pyarray_2_cons(demodulate(response))
                elif a[0] == 'car':
                    if len(a) < 2:
                        return Node(a)
                    else:
                        return self.evalloop(Ap(a[1], Node('t')))
                elif a[0] == 'cdr':
                    if len(a) < 2:
                        return Node(a)
                    else:
                        return self.evalloop(Ap(a[1], Node('f')))
                elif a[0] == 'isnil':
                    if len(a) < 2:
                        return Node(a)
                    else:
                        v1 = self.evalloop(a[1])
                        if isinstance(v1, Node):
                            if v1.v == 'nil':
                                return Node('t')
                            else:
                                # print(f"!!! isnil ({v1.v})")
                                return Node('f')
                        else:
                            return Node('f')
                elif a[0] == 'multipledraw':
                    if len(a) < 2:
                        return Node(a)
                    else:
                        return self.multipledraw(a[1])
                elif a[0] == 'draw':
                    if len(a) < 2:
                        return Node(a)
                    else:
                        return self.draw(a[1])
                elif a[0] == 'eq':
                    if len(a) < 3:
                        return Node(a)
                    else:
                        v1 = self.evalloop(a[1])
                        v2 = self.evalloop(a[2])
                        if isinstance(v1, Node) and isinstance(v2, Node) and isinstance(v1.v, str) and isinstance(v2.v, str):
                            # print(f"!!! eq ({v1.v}) ({v2.v})")
                            if int(v1.v) == int(v2.v):
                                return Node('t')
                            else:
                                return Node('f')
                        assert False, (v1, v2)
                elif a[0] == 'lt':
                    if len(a) < 3:
                        return Node(a)
                    else:
                        v1 = self.evalloop(a[1])
                        v2 = self.evalloop(a[2])
                        if isinstance(v1, Node) and isinstance(v2, Node) and isinstance(v1.v, str) and isinstance(v2.v, str):
                            # print(f"!!! lt ({v1.v}) ({v2.v})")
                            if int(v1.v) < int(v2.v):
                                return Node('t')
                            else:
                                return Node('f')
                        assert False, (v1, v2)
                elif a[0] == 'add':
                    if len(a) < 3:
                        return Node(a)
                    else:
                        v1 = self.evalloop(a[1])
                        v2 = self.evalloop(a[2])
                        if isinstance(v1, Node) and isinstance(v2, Node) and isinstance(v1.v, str) and isinstance(v2.v, str):
                            # print(f"!!! add ({v1.v}) ({v2.v})")
                            return Node(str(int(v1.v) + int(v2.v)))
                        assert False, (v1, v2)
                elif a[0] == 'mul':
                    if len(a) < 3:
                        return Node(a)
                    else:
                        v1 = self.evalloop(a[1])
                        v2 = self.evalloop(a[2])
                        if isinstance(v1, Node) and isinstance(v2, Node) and isinstance(v1.v, str) and isinstance(v2.v, str):
                            # print(f"!!! mul ({v1.v}) ({v2.v})")
                            return Node(str(int(v1.v) * int(v2.v)))
                        assert False, (v1, v2)
                elif a[0] == 'div':
                    if len(a) < 3:
                        return Node(a)
                    else:
                        v1 = self.evalloop(a[1])
                        v2 = self.evalloop(a[2])
                        if isinstance(v1, Node) and isinstance(v2, Node) and isinstance(v1.v, str) and isinstance(v2.v, str):
                            # print(f"!!! div ({v1.v}) ({v2.v})")
                            v1 = int(v1.v)
                            v2 = int(v2.v)
                            assert v2 != 0
                            if v2 < 0:
                                v1 = -v1
                                v2 = -v2
                            if v1 < 0:
                                pass
                                return Node(str(-((-v1) // v2)))
                            else:
                                return Node(str(v1 // v2))
                        assert False, (v1, v2)
                elif a[0] == 'neg':
                    if len(a) < 2:
                        return Node(a)
                    else:
                        v1 = self.evalloop(a[1])
                        if isinstance(v1, Node) and isinstance(v1.v, str):
                            # print(f"!!! neg ({v1.v})")
                            return Node(str(-int(v1.v)))
                        assert False, (v1, v2)
                elif a[0] == 'ifzero':
                    if len(a) < 4:
                        return Node(a)
                    else:
                        v1 = self.evalloop(a[1])
                        if isinstance(v1, Node) and isinstance(v1.v, str):
                            if v1.v == '0':
                                return a[2]
                            elif v1.v == '1':
                                return a[3]
                        assert False, (v1, v2)
                else:
                    assert False, a
            else:
                return Ap(self.eval(x.v1), x.v2)
        elif isinstance(x, Picture):
            return x
        else:
            assert isinstance(x, Node), x
            if isinstance(x.v, str):
                if x.v[0] == ':':
                    return self.galaxy[x.v]
            return None


inst = Main()
#for x, y in inst.cache.items():
#    print(x)
#    print(y)
#    print("----")
