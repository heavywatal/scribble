delta = 0.3

df_label = tribble(
  ~key, ~label,
  "Data", "iris, diamonds",
  "Aesthetics", "x, y, color",
  "Geometries", "point, line",
  "Facets", "grid, wrap",
  "Statistics", "smooth, bin",
  "Coordinates", "cartesian, polar",
  "Theme", "gray, classic"
) %>%
  tibble::rowid_to_column("z") %>%
  dplyr::mutate(x = 0, y = delta * z) %>%
  dplyr::mutate(z = as.character(z)) %>%
  print()

rad = 0.8
theta = pi / 6
df_unit = tibble(
  x = c(0, 1, 1 + rad * cos(theta), rad * cos(theta)),
  y = c(0, 0, -rad * sin(theta), -rad * sin(theta)))

df = df_label$z %>%
  purrr::map_dfr(~df_unit, .id = "z") %>%
  dplyr::mutate(z = as.integer(z)) %>%
  dplyr::mutate(y = y + delta * z) %>%
  dplyr::mutate(z = as.character(z)) %>%
  print()

dev.off()
quartz("layers", 5, 5)
p = ggplot(df) +
  aes(x, y) +
  geom_polygon(aes(group = z, fill = z), alpha = 0.66) +
  geom_text(aes(label = key, color = z), df_label, nudge_x = -0.05, nudge_y = -0.06, hjust = 1, size = 6, family = "Helvetica Neue Bold") +
  geom_text(aes(label = label), df_label, nudge_x = -0.05, nudge_y = -0.16, hjust = 1, size = 4, color = "#555555", family = "Helvetica Neue Medium") +
  scale_x_continuous(expand = expansion(0.01)) +
  scale_y_continuous(expand = expansion(0.01)) +
  coord_fixed(xlim = c(-0.75, 1 + rad * cos(theta))) +
  theme_void() + theme(legend.position = "none")
p
ggsave("ggplot-layers.png", p, width = 5, height = 5)
