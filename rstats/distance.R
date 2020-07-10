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


jukes_cantor_1969 = function(p) {
  - 3 / 4 * log(1 - 4 * p / 3)
}
tibble(
  p = seq(0, 0.6, 0.01),
  d = jukes_cantor_1969((p))
) %>%
  ggplot(aes(p, d)) +
  geom_line() +
  geom_abline(slope = 1, intercept = 0, alpha = 0.5)

# #######1#########2#########3#########4#########5#########6#########7#########
# dist with non-zero diag

dist_genealogy = function(graph, cell_ids) {
  vids = lapply(cell_ids, igraphlite::as_vids, graph = graph)
  sample_sizes = lengths(vids)
  n_regions = length(vids)
  lapply(seq_len(n_regions), function(i) {
    purrr::map_dbl(seq(i, n_regions), function(j) {
      mean_branch_length(graph, vids[[i]], vids[[j]])
    })
  }) %>% unlist(use.names = FALSE)
}

as.matrix.pairwise = function(x, ...) {
  size = attr(x, "Size")
  m = matrix(0, size, size)
  m[lower.tri(m, diag = TRUE)] = x
  dimnames(m) = list(seq_len(size), seq_len(size))
  m
}

which_diagonal = function(x) {
  cumsum(c(1L, seq.int(attr(x, "Size"), 2L)))
}

diag.pairwise = function(x) {
  x[which_diagonal(x)]
}

offdiag.pairwise = function(x) {
  x[-which_diagonal(x)]
}

print.pairwise = function(x, ...) {
  m = as.matrix(x)
  m = format(m)
  m[upper.tri(m)] = ""
  print(m, quote = FALSE, right = TRUE)
}

diag.pairwise(v)
v = bl$length
class(v) = "pairwise"
attr(v, "Size") = 4L
as.matrix.pairwise(v)
print.pairwise(v)
