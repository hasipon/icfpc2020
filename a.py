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

class Picture:
    def __init__(self, v):
        self.v = v

    def __repr__(self):
        return f'Picture({repr(self.v)})'

    def __str__(self):
        return f'(picture{repr(self.v)})'

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
        self.cache = {}
        self.galaxy = {}
        with open('galaxy.txt') as f:
            for x in f:
                a = x.rstrip('\n').split(' = ')
                assert len(a) == 2
                r, _ = conv(a[1].split(' '), 0)
                self.galaxy[a[0]] = r

        x4 = Node('nil')
        x40 = None
        for counter in range(40016):
            self.cache = {}
            if counter < 8:
                hoge = Ap(Ap(Ap(Node('interact'), Node(':1338')), x4), Ap(Ap(Node('cons'), Node('0')), Node('0')))
            elif counter == 8:
                hoge = Ap(Ap(Ap(Node('interact'), Node(':1338')), x4), Ap(Ap(Node('cons'), Node('8')), Node('4')))
            elif counter == 9:
                hoge = Ap(Ap(Ap(Node('interact'), Node(':1338')), x4), Ap(Ap(Node('cons'), Node('2')), Node('-8')))
            elif counter == 10:
                hoge = Ap(Ap(Ap(Node('interact'), Node(':1338')), x4), Ap(Ap(Node('cons'), Node('3')), Node('6')))
            elif counter == 11:
                hoge = Ap(Ap(Ap(Node('interact'), Node(':1338')), x4), Ap(Ap(Node('cons'), Node('0')), Node('-14')))
            elif counter == 12:
                hoge = Ap(Ap(Ap(Node('interact'), Node(':1338')), x4), Ap(Ap(Node('cons'), Node('-4')), Node('10')))
            elif counter == 13:
                hoge = Ap(Ap(Ap(Node('interact'), Node(':1338')), x4), Ap(Ap(Node('cons'), Node('9')), Node('-3')))
            elif counter == 14:
                hoge = Ap(Ap(Ap(Node('interact'), Node(':1338')), x4), Ap(Ap(Node('cons'), Node('-4')), Node('10')))
            elif counter == 15:
                hoge = Ap(Ap(Ap(Node('interact'), Node(':1338')), x4), Ap(Ap(Node('cons'), Node('1')), Node('4')))
            elif counter == 16:
                hoge = Ap(Ap(Ap(Node('interact'), Node(':1338')), x4), Ap(Ap(Node('cons'), Node('0')), Node('0')))
            else:
                hoge = Ap(Ap(Ap(Node('interact'), Node(':1338')), x4), Ap(Ap(Node('cons'), Node('0')), Node('0')))
            result = self.evalloop(hoge)
            if isinstance(result, Node) and len(result.v) == 3 and result.v[0] == 'cons':
                x4 = result.v[1]
                drawings = self.evalloop(result.v[2])
                if isinstance(drawings, Node) and len(drawings.v) == 3 and drawings.v[0] == 'cons':
                    pictures = self.evalloop(drawings.v[1])
                    while True:
                        print(pictures, flush=True)
                        if isinstance(pictures, Node) and len(pictures.v) == 3 and pictures.v[0] == 'cons':
                            assert isinstance(pictures.v[1], Picture)
                            print(pictures.v[1].v, flush=True)
                            pictures = self.evalloop(pictures.v[2])
                        else:
                            break
            else:
                print(result)
                break
            print('----', flush=True)

    def evalloop(self, hoge):
        hoge0 = str(hoge)
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
                        v1 = str(self.evalloop(a[1]))
                        if v1 == '*(cons)((0))((nil))':
                            # [1, 57107]
                            return Ap(Ap(Node('cons'), Node('1')), Ap(Ap(Node('cons'), Node('57107')), Node('nil')))
                        assert False
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
