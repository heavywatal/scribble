#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Simple wrapper of qsub command of PBS system
"""
import argparse
import subprocess
import os


def make_script(args, rest):
    executable = os.path.abspath(args.executable)
    assert os.access(executable, os.X_OK)
    lines = [
        '#!/bin/sh',
        'cd $PBS_O_WORKDIR',
        ' '.join([executable] + rest)
    ]
    return '\n'.join(lines) + '\n'


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-n', '--dry-run', action='store_true')
    parser.add_argument('-N', '--jobname')
    parser.add_argument('-j', '--ncpus', default=1, type=int)
    parser.add_argument('-m', '--mem', default=1, type=int)
    parser.add_argument('executable')
    (args, rest) = parser.parse_known_args()
    jobname = args.jobname or os.path.basename(args.executable)
    resource = 'select=1:ncpus={0.ncpus}:mem={0.mem}gb'.format(args)
    command = f'qsub -j oe -N {jobname} -l {resource}'
    if args.executable.endswith('.R'):
        qsub_R = os.path.join(os.path.dirname(__file__), 'qsub.R')
        command += f' -v NCPUS={args.ncpus},INFILE={args.executable} {qsub_R}'
        input = None
    else:
        script = make_script(args, rest)
        input = script.encode()
        print(script)
    print(command)
    if not args.dry_run:
        subprocess.run(command, input=input, shell=True)


if __name__ == '__main__':
    main()
