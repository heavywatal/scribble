library(ggplot2)

csv = "dim,name
5120x2880,5K
4480x2520,4.5K
3840x2160,4K UHD
2560x1440,WQHD
1920x1080,FHD
1280x720,HD
16x9,ratio
"
resolution = readr::read_csv(I(csv)) |>
  tidyr::separate_wider_delim(dim, "x", names = c("w_px", "h_px")) |>
  purrr::modify_at(vars(ends_with("px")), as.integer) |>
  print()

size = tibble::tibble(
  d_inch = c(21.5, 23.8, 27.0),
  pseudo_px = 2560 * d_inch / 27.0
) |> print()

w = 16
h = 9
d = sqrt(w**2 + h**2)
dpi_nonretina = (2560 / (27.0 * w / d))

tibble::tibble(resolution = list(resolution), size = list(size)) |>
  tidyr::unnest("size") |>
  tidyr::unnest("resolution") |>
  dplyr::arrange(d_inch, w_px) |>
  dplyr::mutate(
    dpi = w_px / (d_inch * w / d),
    reldpi = dpi / dpi_nonretina,
  ) |>
  dplyr::filter(100 < dpi & dpi < 220) |>
  purrr::modify_if(is.double, \(x) round(x, 2L))

size |>
  dplyr::arrange(desc(d_inch)) |>
  dplyr::mutate(w_inch = d_inch * w / d) |>
  dplyr::mutate(h_inch = d_inch * h / d) |>
  dplyr::mutate(label = sprintf("%.1f: %.0fx%.0f", d_inch, pseudo_px, pseudo_px * h / w)) |>
  ggplot() +
  aes(fill = d_inch) +
  geom_rect(aes(xmin = 0, ymin = 0, xmax = w_inch, ymax = h_inch)) +
  geom_text(aes(x = w_inch - 0.2, y = h_inch - 0.2, label = label), hjust = 1, vjust = 1) +
  scale_fill_continuous(limits = c(10, 30)) +
  coord_fixed() +
  theme_minimal() +
  theme(legend.position = "none", axis.title = element_blank())
