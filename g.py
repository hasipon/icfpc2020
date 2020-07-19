from logic import Vect, run


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
    def inputs():
        while True:
            yield input_vect()

    a = run(inputs())

    counter = 0
    while True:
        print("counter: ", counter)
        counter += 1
        while True:
            x = next(a)
            if x is None:
                break
            print(x)
        print('----', flush=True)


main()
