#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
"""
import matplotlib.pyplot as plt
import seaborn as sns
from pydataset import data


diamonds = data('diamonds')

grid = sns.FacetGrid(diamonds, hue='clarity', row='cut', col='color',
                     palette='viridis')
grid.map(plt.scatter, 'carat', 'price')
