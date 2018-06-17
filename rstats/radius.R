library(tidyverse)
library(wtl)

#' Return volume function of specified coord and dims
#' @param coord hex or not
#' @param dimensions integer
#' @rdname radius
#' @export
volume_function = function(coord="hex", dimensions=3L) {
  switch(dimensions, NULL,
    switch(coord, hex = volume_hex2d, volume_rect2d),
    switch(coord, hex = volume_hex3d, volume_rect3d)
  )
}

#' Return radius function of specified coord and dims
#' @rdname radius
#' @export
radius_function = function(coord="hex", dimensions=3L) {
  switch(dimensions, NULL,
    switch(coord, hex = radius_hex2d, radius_rect2d),
    switch(coord, hex = radius_hex3d, radius_rect3d)
  )
}

volume_rect2d = function(radius) {
  pi * (radius ^ 2)
}
volume_rect3d = function(radius) {
  4.0 * pi * (radius ^ 3) / 3.0
}
radius_rect2d = function(volume) {
  sqrt(volume / pi)
}
radius_rect3d = function(volume) {
  ((volume / pi) * 0.75) ^ (1.0 / 3.0)
}
volume_hex2d = function(radius) volume_rect2d(radius) * 2.0 / sqrt(3.0)
volume_hex3d = function(radius) volume_rect3d(radius) * sqrt(2.0)
radius_hex2d = function(volume) radius_rect2d(volume * sqrt(0.75))
radius_hex3d = function(volume) radius_rect3d(volume * sqrt(0.5))

.o = tibble(x = 0, y = 0, z = 0)
.n = 20
.x = seq(-.n, .n)
.extant = tidyr::crossing(x = .x, y = .x, z = .x, coord = "rect") %>%
  dplyr::bind_rows(trans_coord_hex(.) %>% dplyr::mutate(coord = "hex")) %>%
  print()

.tbl = .extant %>%
  dplyr::mutate(dist = dist_euclidean(.extant, .o)) %>%
  dplyr::filter(dist <= .n * sqrt(0.5)) %>%
  dplyr::group_by(coord) %>%
  dplyr::arrange(dist) %>%
  dplyr::mutate(n = seq_along(dist)) %>%
  print()

ggplot(.tbl, aes(dist, n)) +
  stat_function(fun = volume_function("rect", 3), colour = "dodgerblue", size = 3, alpha = 0.6) +
  stat_function(fun = volume_function("hex", 3), colour = "tomato", size = 3, alpha = 0.6) +
  geom_path(aes(linetype = coord)) +
  wtl::theme_wtl() +
  theme(legend.position = "top")

ggplot(.tbl, aes(n, dist)) +
  stat_function(fun = radius_function("rect", 3), colour = "dodgerblue", size = 3, alpha = 0.6) +
  stat_function(fun = radius_function("hex", 3), colour = "tomato", size = 3, alpha = 0.6) +
  geom_path(aes(linetype = coord)) +
  wtl::theme_wtl() +
  theme(legend.position = "top")
