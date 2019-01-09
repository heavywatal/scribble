methods = c(
  "euclidean", # L-2
  "maximum",   # L-infty, Chebyshev
  "manhattan", # L-1, grid
  "canberra",  # scaled manhattan
  "binary",    # ignore 0-0
  "minkowski"  # General
)

df = tibble(
  x = c(0, 0, 1, 1, 1, 1),
  y = c(1, 0, 1, 1, 0, 1)
) %>% print()

methods %>%
  rlang::set_names() %>%
  purrr::map_dbl(~dist(t(df), method = .x))

as.dist(1 - cor(df, method = "spearman"))

# #######1#########2#########3#########4#########5#########6#########7#########

d = dist(runif(100L) %>% setNames(., seq_along(.)))
df = tidyr::crossing(x = attributes(d)$Labels, y = x) %>%
  dplyr::filter(x != y) %>%
  head(100L) %>%
  print()

calc_index = function(d, x, y) {
  idx = sort(match(c(x, y), attributes(d)$Labels))
  size = attributes(d)$Size
  pos = idx[[2L]] + (idx[[1L]] - 1L) * size - sum(seq_len(idx[[1L]]))
  d[[pos]]
}

as_matrix_everytime = function(d, x, y) {
  as.matrix(d)[x, y]
}

as_matrix_once = function(d, x, y) {
  d[x, y]
}

microbenchmark::microbenchmark(
  purrr::pmap_dbl(df, calc_index, d = d),
  purrr::pmap_dbl(df, as_matrix_everytime, d = d),
  purrr::pmap_dbl(df, as_matrix_once, d = as.matrix(d))
)
