import matplotlib.pyplot as plt
import seaborn as sns

iris = sns.load_dataset('iris')
iris.head()
tr_iris = iris.filter(regex='^(?!species)').transpose()
tr_iris.head()
ax = tr_iris.plot(legend=False)
ax
ax.figure

# %%

stacked = (
  iris.set_index(['species'], append=True)
      .swaplevel(0, 1)
      .stack()
      .rename_axis(['species', 'index', 'variable'])
      .rename('value'))

stacked.head()

tidy = stacked.reset_index()
tidy.head()

molten = (
  iris.reset_index()
      .melt(['species', 'index'])
      .sort_values(['index', 'variable']))

molten.head()

# %%

species = iris['species'].unique()
colmap = dict(zip(species, ['r', 'g', 'b']))
fig = plt.figure()
fig.clear()
ax = fig.subplots()
ax.set_xticks(range(4))
ax.set_xticklabels(list(iris.columns[:4]))

for sp, gdf in molten.groupby('species'):
    c = colmap[sp]
    for idx, df in gdf.groupby('index'):
        ax.plot('variable', 'value', data=df, c=c, label=sp)
ax.legend()

# %%

grid = sns.FacetGrid(molten, hue='index')
grid = grid.map(ax.plot, 'variable', 'value')
grid.fig

plt.close()
fig = plt.figure()
ax = fig.subplots()
iris.groupby('species').plot.line('sepal_width', 'sepal_length', ax=ax)
ax.figure.show()

iris.head()

ax.clear()
ax.scatter('sepal_width', 'sepal_length', data=iris)
ax.figure

iris.plot()

ax.clear()
_ = tidy.head(40).groupby('index').plot('variable', 'value', ax=ax)
ax.figure


def parallel_plot(x, y, data, **kwargs):
    # data = kwargs.pop('data')
    data.plot(ax=kwargs.get('ax'))


grid = sns.FacetGrid(tidy.sort_values(['index', 'variable']), hue='species')
grid.map(plt.plot, 'variable', 'value')
