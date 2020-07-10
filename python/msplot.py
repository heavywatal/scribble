"""
"""
import ms

import sys
import math

import matplotlib as mpl
import matplotlib.pyplot as plt
import seaborn as sns
sns.set_style('white')


def heatmap(x, ax, **kwargs):
    return sns.heatmap(x, ax=ax,
                       xticklabels=5, yticklabels=5,
                       cbar=False, square=False, **kwargs)


def dafplot(x, ax, **kwargs):
    nsam = len(x)
    daf = x.sum(0)
    bins = [x + 0.5 for x in range(nsam)]
    ax.set_ylim([0, nsam])
    sns.despine(ax=ax)
    return sns.distplot(daf, ax=ax, bins=bins, kde=False)


def plot_ms(sample, subplot_spec=None):
    mat = sample.sorted()
    if subplot_spec:
        gs = mpl.gridspec.GridSpecFromSubplotSpec(2, 1, subplot_spec, 0.4, 0.4)
    else:
        gs = mpl.gridspec.GridSpec(2, 1)
    heatmap(mat, plt.subplot(gs[0]))
    dafplot(mat, plt.subplot(gs[1]))
    return gs


def ms_figure(ms_parser):
    nrow = ncol = math.ceil(ms_parser.howmany ** 0.5)
    fig = plt.figure(figsize=(ncol * 3, nrow * 4))
    fig.suptitle(ms_parser.cmd)
    outer_grid = mpl.gridspec.GridSpec(nrow, ncol)
    for sample, sspec in zip(ms_parser, outer_grid):
        plot_ms(sample, sspec)
    outer_grid.tight_layout(fig, pad=2, rect=(0, 0, 1, 0.96))
    return fig


#########1#########2#########3#########4#########5#########6#########7#########
if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('infile', nargs='?',
                        type=argparse.FileType('r'), default=sys.stdin)
    (args, rest) = parser.parse_known_args()

    ms_parser = ms.Parser(args.infile)
    print(ms_parser.cmd)
    fig = ms_figure(ms_parser)
    basename = ms_parser.cmd.replace(' ', '_').replace('-', '')
    outfile = basename + '.png'
    print('writing: ' + outfile)
    fig.savefig(outfile)
