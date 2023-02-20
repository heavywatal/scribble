library(tidyverse)

scale_gray = function(x, start = 0.20, end = 0.80) {
  (x - min(x)) * (end - start) / (max(x) - min(x)) + start
}

radius = 53

df = tibble::tibble(
  azimuth = seq.int(0L, 360L, 1L),
  theta = azimuth * pi / 180,
  y = -cos(theta),
  altitude = radius * y
) |>
  dplyr::mutate(level = scale_gray(y)) |>
  dplyr::mutate(color = gray(level)) |>
  print()

outdir = fs::path("wallpaper")
fs::dir_create(outdir)

df_use = df |>
  dplyr::filter(azimuth %in% seq.int(0L, 360L, length.out = 13L)) |>
  dplyr::mutate(across(where(is.double), round, 3)) |>
  readr::write_tsv(outdir / "equinox.tsv") |>
  print()

p = ggplot(df) +
  aes(azimuth, altitude, color = color) +
  geom_point(shape = 16, stroke = 0) +
  geom_point(data = df_use, size = 4, shape = 16, stroke = 0) +
  scale_x_continuous(breaks = seq.int(0, 360, 90)) +
  scale_color_identity()
p
ggsave(outdir / "equinox.png", p, width = 6, height = 4) |>
  wtl::oxipng()

p_void = ggplot() + theme_void()
df_use |>
  dplyr::mutate(outfile = outdir / sprintf("gray-%03d.png", azimuth)) |>
  purrr::pwalk(\(outfile, color, ...) {
    ggsave(outfile, p_void, bg = color, width = 16, height = 9, dpi = 100) |>
      wtl::oxipng() |>
      print()
  })
