#!/usr/bin/env python3
"""https://scikit-allel.readthedocs.io/
"""
import numpy as np
import allel

msout = '''
000000110000
001000110010
000000110000
001000110000
110111001101
000000010000'''

pyarray = [list(x) for x in msout.strip().split('\n')]
haplotypes = np.array(pyarray).astype(np.int8)

h = allel.HaplotypeArray(haplotypes.transpose())
h.n_haplotypes
h.n_variants

ac1 = h.count_alleles(subpop=np.arange(0, 3))
ac2 = h.count_alleles(subpop=np.arange(3, h.n_haplotypes))

within1 = allel.mean_pairwise_difference(ac1)
within2 = allel.mean_pairwise_difference(ac2)
within = (within1 + within2) / 2
between = allel.mean_pairwise_difference_between(ac1, ac2)

num, den = allel.hudson_fst(ac1, ac2)
np.allclose(num, between - within)
np.allclose(den, between)
fst = np.sum(num) / np.sum(den)
fst

an1 = np.sum(ac1, axis=1)
an2 = np.sum(ac2, axis=1)
np.allclose(2 * ac1[:, 1] * ac1[:, 0] / (an1 * (an1 - 1)), within1)
np.allclose(2 * ac2[:, 1] * ac2[:, 0] / (an2 * (an2 - 1)), within2)
np.allclose((ac1[:, 0] * ac2[:, 1] + ac1[:, 1] * ac2[:, 0]) / (an1 * an2),
            between)

p1 = ac1[:, 1] / an1
p2 = ac2[:, 1] / an2
np.allclose(2 * p1 * (1 - p1) * an1 / (an1 - 1), within1)
np.allclose(2 * p2 * (1 - p2) * an2 / (an2 - 1), within2)
np.allclose(p1 * (1 - p2) + (1 - p1) * p2, between)
