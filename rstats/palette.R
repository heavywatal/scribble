col2luminance = function(col) {
  colSums(col2rgb(col) * c(0.2126, 0.7152, 0.0722) / 255)
}

viridis_options = c("magma", "inferno", "plasma", "viridis", "cividis")

df_viridis_raw = purrr::map_dfr(viridis_options, function(option) {
  purrr::map_dfr(seq.int(2L, 8L), function(n) {
    tibble::tibble(
      option = option, n = n,
      color = scales::viridis_pal(option = option)(n),
      y = seq_along(color)
    )
  })
}) %>% print()

df_viridis = df_viridis_raw %>% dplyr::mutate(
  color = stringr::str_replace(color, "FF$", ""),
  luminance = col2luminance(color),
  textcolor = ifelse(luminance < 0.5, "#ffffff", "#000000")
) %>% print()

p = df_viridis %>% ggplot(aes(n, y)) +
    geom_tile(aes(fill = color)) +
    geom_text(aes(label = color, colour = textcolor), family = "Ubuntu Mono") +
    scale_fill_identity() +
    scale_colour_identity() +
    facet_wrap(~option, ncol = 1L) +
    theme_void()
p
ggsave("viridis.pdf", p, width = 6, height = 9, device = cairo_pdf)

# #######1#########2#########3#########4#########5#########6#########7#########

brewer_pal = RColorBrewer::brewer.pal.info %>%
  tibble::rownames_to_column(var = "palette") %>%
  tibble::as_tibble() %>%
  dplyr::select(-maxcolors) %>%
  dplyr::filter(category != "seq") %>%
  print()

df_brewer_raw = brewer_pal %>%
  dplyr::mutate(data = purrr::map(palette, function(palette) {
    purrr::map_dfr(seq.int(2L, 8L), function(n) {
      tibble::tibble(
        n = n,
        color = scales::brewer_pal(palette = palette)(n),
        y = seq_along(color)
      )
    })
  })) %>%
  tidyr::unnest() %>%
  print()

df_brewer = df_brewer_raw %>% dplyr::mutate(
  palette = factor(palette, levels = brewer_pal$palette),
  luminance = col2luminance(color),
  textcolor = ifelse(luminance < 0.5, "#ffffff", "#000000")
) %>% print()

p = df_brewer %>% ggplot(aes(n, y)) +
    geom_tile(aes(fill = color)) +
    geom_text(aes(label = color, colour = textcolor), family = "Ubuntu Mono") +
    scale_fill_identity() +
    scale_colour_identity() +
    facet_wrap(~palette, ncol = 2L, dir = "v") +
    theme_void()
p
ggsave("brewer.pdf", p, width = 11, height = 14, device = cairo_pdf)
