#!/usr/bin/env python
"""
ANSI escape sequence
https://pypi.python.org/pypi/colorama/
"""


def print_bold(text, **kwargs):
    print('\033[1m' + text + '\033[0m', **kwargs)


def main():
    print_bold('Hello, world!')


if __name__ == '__main__':
    main()
