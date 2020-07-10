"""Parser for coalescent simulator 'ms' by Hudson, R. R. (2002)

Generating samples under a Wright-Fisher neutral model.
Bioinformatics 18:337-8
http://home.uchicago.edu/~rhudson1/source/mksamples.html
"""
import sys
import subprocess
import collections
import shutil
import numpy as np

(width, height) = shutil.get_terminal_size()
np.set_printoptions(linewidth=width)

PROG_MS = 'ms'
PROG_SAMPLE_STATS = 'sample_stats'


class Parser(object):
    __slots__ = ['_handle', 'cmd', 'nsam', 'howmany', 'params', 'seed']

    def __init__(self, handle):
        self._handle = handle
        self.cmd = next(self._handle).rstrip()
        words = self.cmd.split(' ')
        self.nsam = int(words[1])
        self.howmany = int(words[2])
        self.params = words[3:]
        self.seed = int(next(self._handle))

    def iter(self):
        for i in range(self.howmany):
            yield Sample(self._handle, self.nsam)

    def __iter__(self):
        return self

    def __next__(self):
        return next(self.iter())

    def __repr__(self):
        s = '<{}.{} "{}">'
        return s.format(self.__module__, type(self).__name__, self.cmd)

    def __str__(self):
        lines = [self.cmd, str(self.seed)]
        lines.extend([str(x) for x in self])
        return '\n'.join(lines)


class Sample(object):
    __slots__ = ['segsites', 'positions', 'haplotypes']

    def __init__(self, handle, nsam):
        next(handle)
        next(handle)  # //
        self.segsites = int(next(handle).split(' ')[1])
        pos = next(handle).rstrip()
        self.positions = [float(x) for x in pos.split(' ')[1:]]
        self.haplotypes = []
        for j in range(nsam):
            line = next(handle).rstrip()
            self.haplotypes.append([int(x) for x in list(line)])

    def __len__(self):
        return len(self.haplotypes)

    def __repr__(self):
        s = '<{}.{}: n={}, S={}>'
        return s.format(self.__module__, type(self).__name__,
                        len(self), self.segsites)

    def __str__(self):
        lines = ['', '//']
        lines.append('segsites: {}'.format(self.segsites))
        lines.append('positions: ' + ' '.join(map(str, self.positions)))
        lines.extend([''.join(map(str, l)) for l in self.haplotypes])
        return '\n'.join(lines)

    def matrix(self):
        return np.array(self.haplotypes)

    def sorted(self):
        return commonsort(np.array(self.haplotypes))


class SampleStats(object):
    __slots__ = ['_handle']

    def __init__(self, handle):
        popen = subprocess.Popen([PROG_SAMPLE_STATS],
                                 stdin=handle, stdout=subprocess.PIPE,
                                 close_fds=True, universal_newlines=True)
        self._handle = popen.stdout

    def __iter__(self):
        return self

    def __next__(self):
        return next(self.iter())

    def iter(self):
        for line in self._handle:
            d = collections.OrderedDict()
            s = line.split()
            d[s[0].rstrip(':')] = float(s[1])
            d[s[2].rstrip(':')] = int(s[3])
            d[s[4].rstrip(':')] = float(s[5])
            d[s[6].rstrip(':')] = float(s[7])
            d[s[8].rstrip(':')] = float(s[9])
            yield d

    def __str__(self):
        lines = []
        for d in self:
            keyvals = ['{}:\t{}'.format(k, v) for k, v in d.items()]
            lines.append('\t'.join(keyvals))
        return '\n'.join(lines)


#########1#########2#########3#########4#########5#########6#########7#########


def listsort(a, reverse=False):
    return np.array(sorted(a.tolist(), reverse=reverse))


def site_weight(a):
    return [a[col.astype(bool), ].sum() for col in a.T]


def site_order(a):
    return np.lexsort((site_weight(a), a.sum(0)))[::-1]


def commonsort(a):
    return listsort(listsort(a[:, site_order(a)], True).T, True).T


def rotate180(a):
    return np.array([row[::-1] for row in a[::-1]])


def smoothen(commonsorted):
    h_flipped = [row[::-1].tolist() for row in commonsorted]
    return rotate180(sorted(h_flipped, reverse=True))


if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('-S', '--sample_stats', action='store_true')
    parser.add_argument('infile', nargs='?',
                        type=argparse.FileType('r'), default=sys.stdin)
    (args, rest) = parser.parse_known_args()

    if args.sample_stats:
        ss = SampleStats(args.infile)
        print(ss)
    else:
        ms_parser = Parser(args.infile)
        print(ms_parser)
