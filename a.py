import sys

sys.setrecursionlimit(100000)

class Node:
    def __init__(self, v):
        self.v = v

    def __repr__(self):
        return f'Node({repr(self.v)})'

    def __str__(self):
        if isinstance(self.v, list):
            return '*' + ''.join(f'({str(x)})' for x in self.v)
        if isinstance(self.v, str) and self.v in {'c', 'b'}:
            return self.v
        return f'({self.v})'

class Ap:
    def __init__(self, v1, v2):
        self.v1 = v1
        self.v2 = v2

    def __repr__(self):
        return f'Ap({repr(self.v1)}, {repr(self.v2)})'

    def __str__(self):
        return f'{str(self.v1)}({str(self.v2)})'

def conv(a, idx):
    if a[idx] == 'ap':
        v1, idx1 = conv(a, idx+1)
        v2, idx2 = conv(a, idx1)
        return Ap(v1, v2), idx2
    else:
        return Node(a[idx]), idx+1

class Main:
    def __init__(self):
        self.galaxy = {}
        with open('galaxy.txt') as f:
            for x in f:
                a = x.rstrip('\n').split(' = ')
                assert len(a) == 2
                r, _ = conv(a[1].split(' '), 0)
                self.galaxy[a[0]] = r

        x4 = Node('nil')
        while True:
            hoge = Ap(Ap(Ap(Node('interact'), Node(':1338')), x4), Ap(Ap(Node('cons'), Node('0')), Node('1')))
            result = self.evalloop(hoge)
            if result.v[0] == 'cons':
                x4 = result.v[1]
                print('1st', result.v[1])
                print('2nd', self.evalloop(result.v[2]))
                break
            else:
                break

    def evalloop(self, hoge):
        while True:
            # print(hoge)
            hoge1 = self.eval(hoge)
            if hoge1 is None:
                return hoge
            hoge = hoge1

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
                        car_cdr_y = Ap(car, Ap(cdr, a[2]))
                        car_cdr_cdr_y = Ap(car, Ap(cdr, Ap(cdr, a[2])))
                        # f38 x y = ifzero car(y) ( car(cdr(y)) , multipledraw(car(cdr(cdr(y)))) ) (interact x car(cdr(y)) send(car(cdr(cdr(y)))))
                        v1 = Ap(Ap(cons, car_cdr_y), Ap(Ap(cons, Ap(Node('multipledraw'), car_cdr_cdr_y)), Node('nil')))
                        v2 = Ap(Ap(Ap(Node('interact'), a[1]), car_cdr_y), Ap('send', car_cdr_cdr_y))
                        return Ap(Ap(Ap(Node('ifzero'), Ap(car, a[2])), v1), v2)
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
        else:
            assert isinstance(x, Node)
            if isinstance(x.v, str):
                if x.v[0] == ':':
                    return self.galaxy[x.v]
            return None


Main()
