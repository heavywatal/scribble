#!/usr/bin/env Rscript
library(tidyverse)
library(tumopp)
library(wtl)

.mean_fst = function(population, graph, ncell) {
  extant = tumopp::filter_extant(population)
  nsam = sample(c(5L, 6L, 6L), 1L)
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
  ncell_fst = tibble::tibble(ncell = .ncell) %>%
    dplyr::mutate(fst = purrr::map_dbl(
      .data$ncell, .mean_fst,
      population = result$population[[1L]],
      graph = result$graph[[1L]]
    ))
  result %>%
    dplyr::select(-population, -graph) %>%
    dplyr::mutate(fst = list(ncell_fst)) %>%
    tidyr::unnest()
}

.ncell = c(50L, 100L, 200L, 400L)
.const = c('-D3', '-Chex')
.prior = list(
  N = function(n = 1L) {round(2 ** runif(n, 15, 22))},
  k = function(n = 1L) {round(10 ** runif(n, 0, 6))},
  L = function(n = 1L) {sample(c('const', 'linear'), n, replace = TRUE)},
  P = function(n = 1L) {sample(c('random', 'mindrag'), n, replace = TRUE)},
  d = function(n = 1L) {runif(n, 0.0, 0.2)},
  m = function(n = 1L) {runif(n, 0.0, 2.0)}
)

.fmt = format(Sys.time(), "%Y%m%d_%H%M%S_%%d")

df_fst = wtl::mcmap_dfr(seq_len(1e5), .tumopp_fst, o = .fmt) %>%
  dplyr::select(-seed, -outdir) %>%
  dplyr::select_if(~ n_distinct(.x) > 1L) %>%
  print()

readr::write_tsv(df_fst, "tumopp-fst-size.tsv.gz")
