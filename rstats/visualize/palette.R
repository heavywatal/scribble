col2luminance = function(col) {
  colSums(col2rgb(col) * c(0.2126, 0.7152, 0.0722) / 255)
}

add_textcolor = function(df) {
  dplyr::mutate(df,
    luminance = col2luminance(color),
    textcolor = ifelse(luminance < 0.5, "#ffffff", "#000000")
  )
}

plot_palette = function(data) {
  add_textcolor(data) |>
    ggplot(aes(n, y)) +
    geom_tile(aes(fill = color)) +
    geom_text(aes(label = color, colour = textcolor), family = "mono") +
    scale_fill_identity() +
    scale_colour_identity() +
    theme_void()
}

# #######1#########2#########3#########4#########5#########6#########7#########

viridis_options = c("magma", "inferno", "plasma", "viridis",
                    "cividis", "mako", "rocket", "turbo")

df_viridis = purrr::map(viridis_options, \(option) {
  purrr::map(seq.int(2L, 8L), \(n) {
    tibble::tibble(
      option = option, n = n,
      color = scales::viridis_pal(option = option)(n) |> substr(1L, 7L),
      y = seq_along(color)
    )
  }) |> purrr::list_rbind()
}) |> purrr::list_rbind() |>
  print()

p = df_viridis |>
  plot_palette()  +
  facet_wrap(vars(option), ncol = 1L)
p
ggsave("viridis.pdf", p, width = 6, height = 10)
ggsave("viridis.cairo.pdf", p, width = 6, height = 10, device = cairo_pdf)

# #######1#########2#########3#########4#########5#########6#########7#########

brewer_pal = RColorBrewer::brewer.pal.info |>
  tibble::rownames_to_column(var = "palette") |>
  tibble::as_tibble() |>
  dplyr::select(!maxcolors) |>
  dplyr::filter(category != "seq") |>
  print()

df_brewer = brewer_pal |>
  dplyr::mutate(data = purrr::map(palette, \(palette) {
    purrr::map(seq.int(2L, 8L), \(n) {
      tibble::tibble(
        n = n,
        color = scales::brewer_pal(palette = palette)(n),
        y = seq_along(color)
      )
    }) |> purrr::list_rbind()
  })) |> tidyr::unnest() |>
  print()

p = df_brewer |>
  plot_palette() +
  facet_wrap(vars(palette), ncol = 2L, dir = "v")
p
ggsave("brewer.pdf", p, width = 11, height = 14)
ggsave("brewer.cairo.pdf", p, width = 11, height = 14, device = cairo_pdf)

# #######1#########2#########3#########4#########5#########6#########7#########

df_std = palette.pals() |>
  purrr::map(\(pal) {
    purrr::map(seq.int(2L, 8L), \(n) {
      tibble::tibble(
        palette = pal,
        color = unname(palette.colors(n, pal)),
        n,
        y = seq_along(color)
      )
    }) |> purrr::list_rbind()
  }) |> purrr::list_rbind() |>
  print()

p = df_std |>
  plot_palette() +
  facet_wrap(vars(palette), ncol = 2L, dir = "v")
p
ggsave("palette.pdf", p, width = 11, height = 14)
ggsave("palette.cairo.pdf", p, width = 11, height = 14, device = cairo_pdf)
