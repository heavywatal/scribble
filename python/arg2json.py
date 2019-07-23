#!/usr/bin/env python
"""
"""
import argparse
import json
import sys


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('-v', '--verbose', action='store_true')
    parser.add_argument('-u', '--mutation_rate', default=0.1, type=float)
    parser.add_argument('-o', '--outdir', default="")
    return parser.parse_known_args()


def main():
    (args, rest) = parse_args()
    adict = vars(args)
    print(sys.argv, file=sys.stderr)
    print(rest, file=sys.stderr)
    print(json.dumps(adict, indent=2))


if __name__ == '__main__':
    main()
