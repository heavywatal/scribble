#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
"""
import itertools
import wtl.options as wopt
enumerator = itertools.count(1)
now = wopt.now()


def args_stem():
    const = ['-D3', '-k100', '-Pfill']
    params = wopt.OrderedDict()
    params['p'] = ['0.4', '0.6', '0.8']
    params['r'] = ['5', '10', '20']
    params['d'] = ['0.00', '0.01', '0.05']
    for d in wopt.product(params):
        yield (d, const)


def args_deathmigra():
    const = ['-D3', '-k100', '-Chex']
    params = wopt.OrderedDict()
    params['P'] = ['push', 'pushn', 'pushne', 'fill', 'empty']
    params['d'] = ['0.0', '0.1', '0.2']
    params['m'] = ['0.0', '1.0', '2.0']
    for d in wopt.product(params):
        yield (d, const)


def args_spatial():
    const = ['-D3', '-d0']
    params = wopt.OrderedDict()
    params['C'] = ['neumann', 'moore', 'hex']
    params['P'] = ['push', 'fill', 'empty']
    params['k'] = ['1', '1e6']
    for d in wopt.product(params):
        yield (d, const)


def args_all():
    const = ['-N16384']
    params = wopt.OrderedDict()
    params['D'] = [2, 3]
    params['C'] = ['neumann', 'moore', 'hex']
    params['P'] = ['push', 'pushn', 'pushne', 'fillpush', 'fill', 'empty']
    params['S'] = ['random', 'even']
    for d in wopt.product(params):
        yield (d, const)


def iter_args(arg_maker, rest, repeat, skip):
    const = ['tumopp'] + rest
    now = wopt.now()
    for i, v in enumerate(wopt.cycle(arg_maker(), repeat)):
        print(v)
        if i < skip:
            continue
        args = wopt.make_args(v[0])
        label = '_'.join([wopt.join(args), now, format(i, '03d')])
        yield const + args + v[1] + ['--outdir=' + label]


def make_outdir(args=[]):
    prefix = 'tumopp'
    label = wopt.join(args)
    pid = format(next(enumerator), '03d')
    return '--out_dir=' + '_'.join([prefix, label, now, pid])


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
    wopt.map_async(it, args.jobs, args.dry_run)
    print('End of ' + __file__)


if __name__ == '__main__':
    main()
