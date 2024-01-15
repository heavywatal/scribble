"""Parser for coalescent simulator 'ms' by Hudson, R. R. (2002).

Generating samples under a Wright-Fisher neutral model.
Bioinformatics 18:337-8
http://home.uchicago.edu/~rhudson1/source/mksamples.html
"""
import argparse
import shutil
import subprocess
import sys
from collections import OrderedDict
from collections.abc import Iterator
from typing import TextIO

import numpy as np
import numpy.typing as npt

(width, height) = shutil.get_terminal_size()
np.set_printoptions(linewidth=width)

PROG_MS = "ms"
PROG_SAMPLE_STATS = "sample_stats"


class Parser:
    __slots__ = ["_handle", "cmd", "nsam", "howmany", "params", "seed"]

    def __init__(self, handle: TextIO) -> None:
        self._handle = handle
        self.cmd = next(self._handle).rstrip()
        words = self.cmd.split(" ")
        self.nsam = int(words[1])
        self.howmany = int(words[2])
        self.params = words[3:]
        self.seed = int(next(self._handle))

    def iter(self) -> Iterator["Sample"]:
        for _i in range(self.howmany):
            yield Sample(self._handle, self.nsam)

    def __iter__(self) -> "Parser":
        return self

    def __next__(self) -> "Sample":
        return next(self.iter())

    def __repr__(self) -> str:
        s = '<{}.{} "{}">'
        return s.format(self.__module__, type(self).__name__, self.cmd)

    def __str__(self) -> str:
        lines = [self.cmd, str(self.seed)]
        lines.extend([str(x) for x in self])
        return "\n".join(lines)


class Sample:
    __slots__ = ["segsites", "positions", "haplotypes"]

    def __init__(self, handle: TextIO, nsam: int) -> None:
        next(handle)
        next(handle)  # //
        self.segsites = int(next(handle).split(" ")[1])
        pos = next(handle).rstrip()
        self.positions = [float(x) for x in pos.split(" ")[1:]]
        self.haplotypes: list[list[int]] = []
        for _j in range(nsam):
            line = next(handle).rstrip()
            self.haplotypes.append([int(x) for x in list(line)])

    def __len__(self) -> int:
        return len(self.haplotypes)

    def __repr__(self) -> str:
        s = "<{}.{}: n={}, S={}>"
        return s.format(self.__module__, type(self).__name__, len(self), self.segsites)

    def __str__(self) -> str:
        lines = ["", "//"]
        lines.append(f"segsites: {self.segsites}")
        lines.append("positions: " + " ".join(map(str, self.positions)))
        lines.extend(["".join(map(str, h)) for h in self.haplotypes])
        return "\n".join(lines)

    def matrix(self) -> npt.NDArray[np.int64]:
        return np.array(self.haplotypes)

    def sorted(self) -> npt.NDArray[np.int64]:
        return commonsort(np.array(self.haplotypes))


class SampleStats:
    __slots__ = ["_handle"]

    def __init__(self, handle: TextIO) -> None:
        popen = subprocess.Popen(
            [PROG_SAMPLE_STATS],
            stdin=handle,
            stdout=subprocess.PIPE,
            close_fds=True,
            universal_newlines=True,
        )
        assert popen.stdout
        self._handle = popen.stdout

    def __iter__(self) -> "SampleStats":
        return self

    def __next__(self) -> OrderedDict[str, int | float]:
        return next(self.iter())

    def iter(self) -> Iterator[OrderedDict[str, int | float]]:
        for line in self._handle:
            d: OrderedDict[str, int | float] = OrderedDict()
            s = line.split()
            d[s[0].rstrip(":")] = float(s[1])
            d[s[2].rstrip(":")] = int(s[3])
            d[s[4].rstrip(":")] = float(s[5])
            d[s[6].rstrip(":")] = float(s[7])
            d[s[8].rstrip(":")] = float(s[9])
            yield d

    def __str__(self) -> str:
        lines: list[str] = []
        for d in self:
            keyvals = [f"{k}:\t{v}" for k, v in d.items()]
            lines.append("\t".join(keyvals))
        return "\n".join(lines)


# #######1#########2#########3#########4#########5#########6#########7#########


def listsort(a: npt.NDArray[np.int64], reverse: bool = False) -> npt.NDArray[np.int64]:
    return np.array(sorted(a.tolist(), reverse=reverse))


def site_weight(a: npt.NDArray[np.int64]) -> list[int]:
    return [a[col.astype(bool),].sum() for col in a.T]


def site_order(a: npt.NDArray[np.int64]) -> npt.NDArray[np.int64]:
    return np.lexsort((site_weight(a), a.sum(0)))[::-1]


def commonsort(a: npt.NDArray[np.int64]) -> npt.NDArray[np.int64]:
    return listsort(listsort(a[:, site_order(a)], True).T, True).T


def rotate180(a: npt.NDArray[np.int64]) -> npt.NDArray[np.int64]:
    return np.array([row[::-1] for row in a[::-1]])


def smoothen(commonsorted: npt.NDArray[np.int64]) -> npt.NDArray[np.int64]:
    h_flipped = [row[::-1].tolist() for row in commonsorted]
    return rotate180(sorted(h_flipped, reverse=True))


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-S", "--sample_stats", action="store_true")
    parser.add_argument(
        "infile", nargs="?", type=argparse.FileType("r"), default=sys.stdin
    )
    (args, rest) = parser.parse_known_args()

    if args.sample_stats:
        ss = SampleStats(args.infile)
        print(ss)
    else:
        ms_parser = Parser(args.infile)
        print(ms_parser)
