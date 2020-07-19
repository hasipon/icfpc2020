from collections import namedtuple
import sys

sys.setrecursionlimit(100000)


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


def to_list(v0):
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


def interact(state, event):
    res = evalloop(Ap(Ap(Atom(":1338"), state), event))
    # Note: res will be modulatable here (consists of cons, nil and numbers only)
    flag, newState, data = to_list(res)
    if asNum(flag) == 0:
        return newState, data
    assert False
    # return interact(newState, SEND_TO_ALIEN_PROXY(data))


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
    counter = 0
    while True:
        print("counter: ", counter)
        counter += 1
        click = Ap(Ap(cons, Atom(vector.X)), Atom(vector.Y))
        state, images = interact(state, click)
        for image in get_images(images):
            print(image)
        print('----', flush=True)
        vector = input_vect()


main()
