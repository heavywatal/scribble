delta = 0.3

df_label = tibble::tribble(
  ~key, ~label,
  "Data", "iris, diamonds",
  "Aesthetics", "x, y, color",
  "Geometries", "point, line",
  "Facets", "grid, wrap",
  "Statistics", "smooth, bin",
  "Coordinates", "cartesian, polar",
  "Theme", "gray, classic"
) |>
  tibble::rowid_to_column("z") |>
  dplyr::mutate(x = 0, y = delta * z) |>
  print()

rad = 0.8
theta = pi / 6
df_unit = tibble::tibble(
  x = c(0, 1, 1 + rad * cos(theta), rad * cos(theta)),
  y = c(0, 0, -rad * sin(theta), -rad * sin(theta))) |>
  print()

df = df_label |>
  dplyr::select(z) |>
  dplyr::mutate(data = purrr::map(z, \(x) df_unit)) |>
  tidyr::unnest_longer(data) |>
  tidyr::unpack(data) |>  # why needed?
  dplyr::mutate(y = y + delta * z) |>
  print()

p = ggplot(df) +
  aes(x, y) +
  geom_polygon(aes(group = z, fill = z), alpha = 0.66) +
  geom_text(aes(label = key, color = z), df_label, hjust = 1, size = 6,
    nudge_x = -0.05, nudge_y = -0.06, family = "Helvetica Neue Bold") +
  geom_text(aes(label = label), df_label, hjust = 1, size = 4, color = "#555555",
    nudge_x = -0.05, nudge_y = -0.16, family = "Helvetica Neue Medium") +
  scale_x_continuous(expand = expansion(0.01)) +
  scale_y_continuous(expand = expansion(0.01)) +
  scale_color_viridis_c(option = "turbo", begin = 0.02, end = 0.99) +
  scale_fill_viridis_c(option = "turbo", begin = 0.02, end = 0.99) +
  coord_fixed(xlim = c(-0.75, 1 + rad * cos(theta))) +
  theme_void() + theme(legend.position = "none")
p

# ragg cannot use "Helvetica Neue Medium"
ggsave("ggplot-layers.png", p, width = 5, height = 5, dev = grDevices::png) |>
  wtl::oxipng()
