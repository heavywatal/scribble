# 5120x2880: 5K (iMac 27)
# 4480x2520: 4.5K (iMac 24)
# 3840x2160: 4K UHD
# 2560x1440: WQHD
# 1920x1080: FHD
# 1280x 720: HD
#   16x   9

tidyr::crossing(
  inch = c(21.5, 23.8, 27),
  pixel = c(1920, 2560, 3840, 4480, 5120),
  scale = c(1 / 2, 2 / 3, 4 / 5, 7 / 8, 1)
) |>
  dplyr::mutate(
    width = inch * 16 / sqrt(16 ** 2 + 9 ** 2),
    dpi = pixel / width,
    reldpi = dpi / 108.79,
    .before = scale
  ) |>
  dplyr::select(!width) |>
  dplyr::mutate(
    ppixel = scale * pixel,
    pdpi = scale * dpi
  ) |>
  purrr::modify(\(x) round(x, 2L)) |>
  dplyr::filter(100 < dpi & dpi < 220) |>
  dplyr::filter(pdpi > 90, pdpi < 130) |>
  dplyr::arrange(inch, pixel)

# https://kakaku.com/pc/lcd-monitor/itemlist.aspx?pdf_Spec054=1&pdf_Spec060=1&pdf_Spec101=20&pdf_Spec301=20-28
