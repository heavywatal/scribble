library(conflicted)
library(tidyverse)
grDevices::palette("Okabe-Ito")
options(
  ggplot2.continuous.colour = "viridis",
  ggplot2.continuous.fill = "viridis",
  ggplot2.discrete.colour = grDevices::palette()[-1],
  ggplot2.discrete.fill = grDevices::palette()[-1]
)

delta = 0.3

df_label = tibble::tribble(
  ~key, ~label,
  "Data", "iris, diamonds",
  "Aesthetics", "x, y, color",
  "Geometries", "point, line",
  "Statistics", "smooth, bin",
  "Facets", "grid, wrap",
  "Coordinates", "cartesian, polar",
  "Theme", "gray, classic"
) |>
  tibble::rowid_to_column("z") |>
  dplyr::mutate(x = 0, y = delta * z) |>
  dplyr::mutate(key = factor(key, levels = key)) |>
  print()

rad = 0.8
theta = pi / 6
df_unit = tibble::tibble(
  x = c(0, 1, 1 + rad * cos(theta), rad * cos(theta)),
  y = c(0, 0, -rad * sin(theta), -rad * sin(theta))
) |> print()

df = df_label |>
  dplyr::select(key, z) |>
  dplyr::mutate(data = purrr::map(z, \(x) df_unit)) |>
  tidyr::unnest_longer(data) |>
  tidyr::unpack(data) |>  # why needed?
  dplyr::mutate(y = y + delta * z) |>
  print()

p = ggplot(df_label) +
  aes(x, y) +
  geom_polygon(aes(group = key, fill = key), df, alpha = 0.75) +
  geom_text(aes(label = key, color = key), hjust = 1, size = 6,
    nudge_x = -0.05, nudge_y = -0.06, family = "SF Pro Bold") +
  geom_text(aes(label = label), hjust = 1, size = 4, color = "#555555",
    nudge_x = -0.05, nudge_y = -0.16, family = "SF Pro Medium") +
  scale_x_continuous(expand = expansion(0.01)) +
  scale_y_continuous(expand = expansion(0.01)) +
  coord_fixed(xlim = c(-0.75, 1 + rad * cos(theta))) +
  theme_void() + theme(legend.position = "none")
# p

# ragg cannot handle font family
ggsave("ggplot-layers.png", p, width = 5, height = 5, dev = grDevices::png) |>
  wtl::oxipng()
