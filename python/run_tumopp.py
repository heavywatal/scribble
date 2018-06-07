#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
"""
import itertools
import wtl.options as wopt
enumerator = itertools.count(1)


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
    for i, v in enumerate(wopt.cycle(arg_maker(), repeat)):
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
