col2luminance = function(col) {
  colSums(col2rgb(col) * c(0.2126, 0.7152, 0.0722) / 255)
}

viridis_options = c("magma", "inferno", "plasma", "viridis", "cividis")

df_raw = purrr::map_dfr(viridis_options, function(option) {
  purrr::map_dfr(seq.int(2L, 8L), function(n) {
    tibble::tibble(
      option = option, n = n,
      color = scales::viridis_pal(option = option)(n),
      y = seq_along(color)
    )
  })
}) %>% print()

df = df_raw %>% dplyr::mutate(
  color = stringr::str_replace(color, "FF$", ""),
  luminance = col2luminance(color),
  textcolor = ifelse(luminance < 0.5, "#ffffff", "#000000")
) %>% print()

p = df %>% ggplot(aes(n, y)) +
    geom_tile(aes(fill = color)) +
    geom_text(aes(label = color, colour = textcolor)) +
    scale_fill_identity() +
    scale_colour_identity() +
    facet_wrap(~option, ncol = 1L) +
    theme_void()
p

ggsave("viridis.pdf", p, width = 6, height = 9)
