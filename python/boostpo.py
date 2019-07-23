#!/usr/bin/env python
"""
Parse boost::program_options description
"""
import sys
import re


def collect_short_long_pairs(text):
    rex = re.compile(r'-(\w).+?--(\S+)')
    return {m.group(1): m.group(2) for m in rex.finditer(text)}


def print_as_R_list(pairs):
    print('list(')
    for key, value in pairs.items():
        print('  {} = "{}",'.format(key, value))
    print(')')


if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('infile', nargs='?', type=argparse.FileType('r'),
                        default=sys.stdin)
    parser.add_argument('outfile', nargs='?', type=argparse.FileType('w'),
                        default=sys.stdout)
    args = parser.parse_args()
    pairs = collect_short_long_pairs(args.infile.read())
    print_as_R_list(pairs)
