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

# #######1#########2#########3#########4#########5#########6#########7#########
# clustering

loadNamespace("ClusterR")

runif_int = function(n = 1L, replace = TRUE) {
  sample.int(.Machine$integer.max, n, replace = replace)
}
runif_int(8L)

tbl = diamonds |> dplyr::select(carat, depth, price)
k = 6L
niter = 2L

bench::mark(
  stats::kmeans(tbl, k, iter.max = niter),
  ClusterR::MiniBatchKmeans(tbl, k, max_iters = niter, seed = runif_int()),
  ClusterR::KMeans_arma(tbl, k, n_iter = niter, seed = runif_int()),
  ClusterR::KMeans_rcpp(tbl, k, max_iters = niter, seed = runif_int()),
  check = FALSE
)

loadNamespace("fastkmedoids")

small = tbl |> dplyr::sample_n(2000)

bench::mark(
  stats::kmeans(tbl, k, iter.max = niter),
  cluster::pam(small, k, diss = FALSE, cluster.only = TRUE, do.swap = FALSE, variant = "faster"),
  fastkmedoids::fastpam(dist(small), nrow(small), k, seed = runif_int()),
  fastkmedoids::fastclara(dist(small), nrow(small), k, seed = runif_int()),
  fastkmedoids::fastclarans(dist(small), nrow(small), k, seed = runif_int()),
  check = FALSE
)
