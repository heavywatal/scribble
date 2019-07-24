"""Simple wrapper of qsub command of PBS system
"""
import argparse
import subprocess
import os


def make_script(args):
    args[0] = os.path.abspath(args[0])
    assert os.access(args[0], os.X_OK)
    lines = [
        '#!/bin/sh',
        'cd $PBS_O_WORKDIR',
        ' '.join(args)
    ]
    return '\n'.join(lines) + '\n'


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-n', '--dry-run', action='store_true')
    parser.add_argument('-N', '--jobname')
    parser.add_argument('-j', '--ncpus', default=1, type=int)
    parser.add_argument('-m', '--mem', default=1, type=int)
    parser.add_argument('positional', nargs='+')
    args = parser.parse_args()
    executable = args.positional[0]
    jobname = args.jobname or os.path.basename(executable)
    resource = 'select=1:ncpus={0.ncpus}:mem={0.mem}gb'.format(args)
    command = f'qsub -j oe -N {jobname} -l {resource}'
    if executable.endswith('.R'):
        qsub_R = os.path.join(os.path.dirname(__file__), 'qsub.R')
        command += f' -v NCPUS={args.ncpus},INFILE={executable} {qsub_R}'
        input = None
    else:
        script = make_script(args.positional)
        input = script.encode()
        print(script)
    print(command)
    if not args.dry_run:
        subprocess.run(command, input=input, shell=True)


if __name__ == '__main__':
    main()
