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
