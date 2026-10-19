library(tidyverse)

make_table = function(year, name, front, rear) {
  .front = data.frame(front) |> tibble::rownames_to_column("x")
  .rear = data.frame(rear) |> tibble::rownames_to_column("y")
  tidyr::crossing(
    name,
    front = .front$front,
    rear = .rear$rear
  ) |>
    dplyr::left_join(.front, by = "front") |>
    dplyr::left_join(.rear, by = "rear") |>
    dplyr::mutate(year = year)
}

speed = function(ratio = 1.0, rpm = 90, diameter = 0.69) {
  ratio * rpm * pi * diameter * 60 / 1000
}
speed(2.4)

gear_df = dplyr::bind_rows(
  make_table(2017, "80-MD", c(48, 38, 28), c(11, 13, 15, 18, 21, 24, 28, 32)),
  make_table(2017, "200-D", c(50, 34), c(11, 13, 15, 17, 19, 21, 24, 28, 32)),
  make_table(2017, "FX 3", c(48, 36, 26), c(11, 13, 15, 17, 20, 23, 26, 30, 34)),
  make_table(2017, "FX S4", c(48, 34), c(11, 13, 15, 17, 19, 21, 23, 26, 30, 34)),
  make_table(2017, "Zektor 2", c(50, 34), c(11, 13, 15, 18, 21, 24, 28, 32)),
  make_table(2017, "Zektor 3", c(48, 32), c(11, 13, 15, 17, 20, 23, 26, 30, 34)),
  make_table(2026, "FX 2 G4", 40, c(11, 13, 15, 17, 20, 23, 26, 30, 36)),
  make_table(2026, "FX 3 G4", 40, c(11, 13, 15, 17, 20, 23, 28, 34, 41, 48)),
  make_table(2026, "FX SL4", 42, c(11, 13, 15, 17, 20, 23, 28, 34, 41, 48))
) |>
  dplyr::mutate(ratio = front / rear) |>
  print()

.pg = gear_df |>
  ggplot(aes(ordered(x, levels = 3:1), ordered(y, levels = 11:1))) +
  geom_raster(aes(fill = ratio)) +
  geom_text(aes(label = sprintf("%.2f", ratio))) +
  facet_grid(cols = vars(year, name), scale = "free_x", space = "free_x") +
  scale_fill_distiller(palette = "Spectral") +
  coord_cartesian(expand = FALSE) +
  theme_bw(base_size = 13) +
  theme(
    panel.grid = element_blank(),
    axis.title = element_blank(),
    axis.text.x = element_blank(),
    axis.ticks = element_blank(),
    legend.position = "none"
  )
.pg
ggsave("bicycle-gear.png", .pg, width = 10, height = 4) |> wtl::oxipng()

speed_df = tibble::tibble(
  rpm = c(60, 70, 76.8, 80, 90),
  gear = list(gear_df |> dplyr::filter(name == "FX 3 G4"))
) |>
  tidyr::unnest(gear) |>
  dplyr::mutate(speed = speed(ratio, rpm)) |>
  print()

.ps = speed_df |>
  ggplot(aes(ordered(x, levels = 2:1), ordered(y, levels = 10:1))) +
  geom_raster(aes(fill = speed)) +
  geom_text(aes(label = sprintf("%.1f", speed))) +
  facet_grid(cols = vars(rpm), labeller = label_both) +
  scale_fill_distiller(palette = "Spectral") +
  coord_cartesian(expand = FALSE) +
  theme_bw(base_size = 14) +
  theme(
    panel.grid = element_blank(),
    axis.title = element_blank(),
    axis.text.x = element_blank(),
    axis.ticks = element_blank(),
    legend.position = "none"
  )
.ps
ggsave("bicycle-speed.png", .ps, width = 5, height = 4) |> wtl::oxipng()
