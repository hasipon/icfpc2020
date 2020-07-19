## a.py
cui evaluator

```
$ APIKEY=XXXXX python3 a.py
```

## b.py
gui mode of a.py

```
$ APIKEY=XXXXX python3 b.py
```

## profile

1. execute a.py with cProfile
```
$ python3 -m cProfile -o a.profile a.py
```

2. show profile
```
$ python3 show_profile.py a.profile
```

output sxample
```
Sat Jul 18 13:46:18 2020    profile

         991986612 function calls (753553044 primitive calls) in 309.913 seconds

   Ordered by: cumulative time
   List reduced from 38 to 10 due to restriction <10>

   ncalls  tottime  percall  cumtime  percall filename:lineno(function)
        1    0.000    0.000  309.913  309.913 {built-in method builtins.exec}
        1    0.000    0.000  309.913  309.913 a.py:1(<module>)
        1    0.069    0.069  309.913  309.913 a.py:49(__init__)
474688/106    7.419    0.000  309.733    2.922 a.py:104(evalloop)
71736544/459   58.634    0.000  309.702    0.675 a.py:158(eval)
166482310/356838  130.705    0.000  219.738    0.001 a.py:37(__str__)
       67    0.000    0.000  161.235    2.406 a.py:146(multipledraw)
       48    0.023    0.000  158.182    3.295 a.py:130(draw)
166957123/166943442   64.199    0.000   89.136    0.000 a.py:12(__str__)
498785914   37.441    0.000   37.441    0.000 {built-in method builtins.isinstance}


309.913032
```
