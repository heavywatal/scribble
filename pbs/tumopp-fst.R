#!/usr/bin/env Rscript
#PBS -N tumopp-fst
#PBS -j oe
#PBS -l select=1:ncpus=24:mem=24gb
options(mc.cores = 24L)
sessionInfo()

PBS_O_WORKDIR = Sys.getenv("PBS_O_WORKDIR")
setwd(PBS_O_WORKDIR)
print(getwd())

print(.libPaths())
message(".Library: ", .Library)
message(".Library.site: ", .Library.site)

# #######1#########2#########3#########4#########5#########6#########7#########

library(tumopp)
library(wtl)
library(magrittr)

.mean_fst = function(population, graph, ...) {
  nsam = sample(c(5L, 6L, 6L), 1L)
  ncell = 100L
  extant = tumopp::filter_extant(population)
  if (nrow(extant) < 50000L) return(NA_real_)
  regions = extant %>%
    tumopp::sample_uniform_regions(nsam = nsam, ncell = ncell)
  sampled = purrr::flatten_int(regions$id)
  subgraph = tumopp::subtree(graph, sampled)
  .tbl = within_between_samples(subgraph, regions)
  mean(.tbl$fst)
}

.tumopp_fst = function(i = 1L, o = "_%d") {
  .cmd = tumopp:::generate_args(.prior, .const, 1L) %>%
    purrr::map2(sprintf(paste0("-o", o), i), c)
  result = tumopp(.cmd)
  if (NROW(result) < 1L) return(NA_real_)
  .fst = .mean_fst(result$population[[1L]], result$graph[[1L]])
  if (!is.na(.fst) && lbound < .fst && .fst < ubound) {
    write_results(result)
  }
  .fst
}

.obs_mean = 0.2383436
.tolerance = 0.3
lbound = .obs_mean * (1 - .tolerance)
ubound = .obs_mean * (1 + .tolerance)

.const = c('-N50000', '-D3', '-Chex', '-k100')
.prior = list(
  L = function(n = 1L) {sample(c('const', 'step', 'linear'), n, replace = TRUE)},
  P = function(n = 1L) {sample(c('random', 'roulette', 'mindrag'), n, replace = TRUE)},
  d = function(n = 1L) {runif(n, 0.0, 0.3)},
  m = function(n = 1L) {runif(n, 0.0, 10.0)},
  p = function(n = 1L) {runif(n, 0.2, 1.0)},
  r = function(n = 1L) {wtl::runif.int(n, 2L, 20L)}
)

.fmt = format(Sys.time(), "%Y%m%d_%H%M%S_%%d")
.devnull = parallel::mclapply(seq_len(1e6), .tumopp_fst, o = .fmt)
