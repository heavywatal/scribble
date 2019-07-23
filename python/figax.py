#!/usr/bin/env python
"""
"""
import matplotlib.pyplot as plt
from pydataset import data

iris = data("iris")

# Create an empty Figure
fig = plt.figure()

# Add an Axes to this fig
ax = fig.subplots()

# Plot on this ax
ax.scatter('Sepal.Width', 'Sepal.Length', data=iris)

# Show figure (in Jupyter, Hydrogen, or other inline IPython environments)
# display(fig)

# Show figure in a new window (with non-inline backends)
fig.show()
plt.close(fig)

# Write to a file
fig.savefig('iris-sepal.png')
