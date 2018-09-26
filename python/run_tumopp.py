#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""https://heavywatal.github.io/tumopp/
"""
import itertools
import random
import wtl.options as wopt


def generate(params):
    d = wopt.OrderedDict()
    for key, gen in params.items():
        d[key] = gen()
    return d


def has_invalid_combination(d):
    return ((d['L'] in ('step', 'linear')) and
            (d['P'] not in ('random', 'mindrag')))


def size():
    const = ['-D3', '-Chex']
    params = wopt.OrderedDict()
    params['N'] = ['5000', '10000', '20000', '40000']
    params['L'] = ['const', 'linear']
    params['P'] = ['random', 'mindrag']
    params['k'] = ['1', '1e6']
    params['d'] = ['0.0', '0.2']
    params['m'] = ['0.0', '2.0']
    for d in wopt.product(params):
        yield (d, const)


def prior():
    const = ['-N50000', '-D3', '-Chex', '-k100']
    params = wopt.OrderedDict()
    params['L'] = lambda: random.choice(['const', 'step', 'linear'])
    params['P'] = lambda: random.choice(['random', 'roulette', 'mindrag'])
    params['d'] = lambda: random.uniform(0.0, 0.3)
    params['m'] = lambda: random.uniform(0.0, 10.0)
    params['p'] = lambda: random.uniform(0.2, 1.0)
    params['r'] = lambda: random.randint(2, 20)
    while True:
        while True:
            d = generate(params)
            if not has_invalid_combination(d):
                break
        yield (d, const)


def stem():
    const = ['-N40000', '-D2', '-Chex', '-Pmindrag', '-k100']
    params = wopt.OrderedDict()
    params['p'] = ['0.2', '0.6', '1.0']
    params['r'] = ['5', '10', '20']
    params['d'] = ['0.0', '0.1']
    params['m'] = ['0.0', '2.0']
    for d in wopt.product(params):
        yield (d, const)


def deathmigra():
    const = ['-N40000', '-D2', '-Chex', '-k100']
    params = wopt.OrderedDict()
    params['L'] = ['const', 'step', 'linear']
    params['P'] = ['random', 'mindrag']
    params['d'] = ['0.0', '0.1', '0.2']
    params['m'] = ['0.0', '1.0', '2.0']
    for d in wopt.product(params):
        yield (d, const)


def spatial():
    const = ['-N40000', '-D2', '-Chex']
    params = wopt.OrderedDict()
    params['L'] = ['const', 'step', 'linear']
    params['P'] = ['random', 'roulette', 'mindrag']
    params['k'] = ['1', '1e6']
    for d in wopt.product(params):
        yield (d, const)


def iter_args(arg_maker, rest, repeat, skip):
    const = ['tumopp'] + rest
    now = wopt.now()
    if arg_maker == prior:
        it = itertools.islice(arg_maker(), repeat)
    else:
        it = wopt.cycle(arg_maker(), repeat)
    for i, v in enumerate(it):
        if i < skip:
            continue
        args = wopt.make_args(v[0])
        label = '_'.join([wopt.join(args), now, format(i, '03d')])
        yield const + args + v[1] + ['--outdir=' + label]


def main():
    arg_makers = {k: v for k, v in globals().items()
                  if callable(v) and k not in ('main', 'iter_args')}
    parser = wopt.ArgumentParser()
    parser.add_argument('function', choices=arg_makers)
    (args, rest) = parser.parse_known_args()
    print("cpu_count(): {}".format(wopt.cpu_count()))
    print('{} jobs * {} threads/job'.format(args.jobs, args.parallel))

    fun = arg_makers[args.function]
    it = iter_args(fun, rest, args.repeat, args.skip)
    wopt.map_async(it, args.jobs, args.dry_run, outdir=args.outdir)
    print('End of ' + __file__)


if __name__ == '__main__':
    main()
