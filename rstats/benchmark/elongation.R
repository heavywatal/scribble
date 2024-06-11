library(tidyverse)

by_append = function(n) {
  v = integer(0L)
  for (i in seq_len(n)) {v = append(v, i)}
  v
}
by_c = function(n) {
  v = integer(0L)
  for (i in seq_len(n)) {v = c(v, i)}
  v
}
by_index = function(n) {
  v = integer(0L)
  for (i in seq_len(n)) {v[i] = i}
  v
}
by_index2 = function(n) {
  v = integer(0L)
  for (i in seq_len(n)) {v[[i]] = i}
  v
}
by_index_len = function(n) {
  v = integer(0L)
  for (i in seq_len(n)) {v[length(v) + 1L] = i}
  v
}
by_vapply = function(n) {
  vapply(seq_len(n), function(x) x, integer(1L))
}
by_map_int = function(n) {
  purrr::map_int(seq_len(n), ~.x)
}

n = 100L
stopifnot(seq_len(n) == by_append(n))
stopifnot(seq_len(n) == by_c(n))
stopifnot(seq_len(n) == by_index(n))
stopifnot(seq_len(n) == by_index2(n))
stopifnot(seq_len(n) == by_index_len(n))
stopifnot(seq_len(n) == by_vapply(n))
stopifnot(seq_len(n) == by_map_int(n))

benchmark = function(n, times = 40L) {
  bench::mark(
    by_append(n),
    by_c(n),
    by_map_int(n),
    by_vapply(n),
    by_index_len(n),
    by_index(n),
    by_index2(n),
    seq_len(n),
    max_iterations = times
  )
}
benchmark(n)

raw_data = tibble::tibble(n = as.integer(10 ** seq(0.5, 4, 0.5))) |>
  dplyr::mutate(data = lapply(n, benchmark)) |>
  tidyr::unnest() |>
  print()

p = raw_data |>
  dplyr::select(n, expression, median) |>
  dplyr::mutate(expression = as.character(expression)) |>
  dplyr::mutate(median = as.numeric(median)) |>
  ggplot() +
  aes(n, median, color = expression) +
  geom_point(alpha = 0.4) +
  geom_line(linewidth = 1, alpha = 0.6) +
  scale_x_log10() +
  scale_y_log10()
p

ggsave("elongation.png", p, width = 6, height = 6)
