# slow normal approx. for big mu >= 10.0
# <https://github.com/wch/r-source/blob/trunk/src/nmath/rpois.c>

n = 2L**20L
bench::mark(
  stats::rpois(n, 0.1),
  stats::rpois(n, 1),
  stats::rpois(n, 10 - 1e-9),
  stats::rpois(n, 10),
  stats::rpois(n, 1000),
  check = FALSE
)
