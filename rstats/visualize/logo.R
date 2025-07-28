library(tidyverse)

dev.off()
scale = 4
quartz(width = scale * sqrt(3) / 2, height = scale)
radius = 54
ylim = c(-radius, radius)
xlim = ylim * sqrt(3) / 2
hex_tekkamaki = ggplot() +
  # wtl::annotate_regpolygon(6L, radius, linewidth = 6, color = "#333333", fill = "#ffffff") +
  wtl::annotate_regpolygon(6L, radius, fill = "#303030", linetype = 0) +
  wtl::annotate_regpolygon(6L, radius - 6, fill = "#ffffff", linetype = 0) +
  wtl::annotate_regpolygon(6L, radius * 2 / 5, fill = "#C41A41", linetype = 0) +
  coord_fixed(xlim = xlim, ylim = ylim, expand = FALSE) +
  theme_void()
hex_tekkamaki
ggsave("hex-tekkamaki.svg", hex_tekkamaki, height = 1.5, width = 1.5 * sqrt(3) / 2, bg = "transparent") |>
  wtl::logo_svg_optimize()
ggsave("hex-tekkamaki.png", hex_tekkamaki, height = scale, width = scale * sqrt(3) / 2, dpi = 128, bg = "transparent") |>
  wtl::oxipng()

# #######1#########2#########3#########4#########5#########6#########7#########

library(tidyverse)

read_matrix_longer = function(data) {
  .cols = cols(.default = "c")
  read_delim(data, delim = " ", col_names = FALSE, col_types = .cols) %>%
    tibble::rowid_to_column("y") %>%
    tidyr::pivot_longer(!y, names_to = "x", names_prefix = "X") %>%
    dplyr::mutate(x = as.integer(x))
}

elongate = function(x, n = 9L, i = length(x)) {
  c(x, rep(x[i], max(n - length(x), 0L)))
}
elongate(1:3, 6)
elongate(1:3, 2)

gglogo = function(data, palette) {
  ucount = vctrs::vec_unique_count(data[["value"]])
  palette = elongate(palette, ucount)
  ggplot(data) +
    aes(x, y) +
    geom_raster(aes(fill = value)) +
    scale_y_reverse() +
    scale_fill_manual(values = palette, guide = NULL) +
    coord_fixed(expand = FALSE) +
    theme_void()
}

data = "
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 1 1 1 1 0 0 1 1 1 1 0 0 2 2 0
0 1 1 1 1 0 0 1 1 1 1 0 0 2 2 0
0 1 1 0 0 0 0 1 1 0 0 0 0 0 0 0
0 1 1 0 0 0 0 1 1 0 0 0 0 0 0 0
0 1 1 1 1 0 0 1 1 1 1 0 0 1 1 0
0 1 1 1 1 0 0 1 1 1 1 0 0 1 1 0
0 1 1 0 0 0 0 1 1 0 0 0 0 1 1 0
0 1 1 0 0 0 0 1 1 0 0 0 0 1 1 0
0 1 1 1 1 0 0 1 1 1 1 0 0 1 1 0
0 1 1 1 1 0 0 1 1 1 1 0 0 1 1 0
0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0
0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0
0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 0
0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0"

df = read_matrix_longer(data) %>% print()
p = gglogo(df, c("#eeeeee", "#006666", "#C41A41"))
p
ggsave("eej-icon.png", p, width = 1, height = 1, dpi = 160)

data = "
1 1 0 1 1 0 2
1 0 0 1 0 0 0
1 1 0 1 1 0 1
1 0 0 1 0 0 1
1 1 0 1 1 0 1
0 0 0 0 0 0 1
0 0 0 0 1 1 1
"

df = read_matrix_longer(data) %>% print()
p = gglogo(df, c("#eeeeee", "#006666", "#C41A41"))
p

data = "
1 1 1 1 1 1 1 1 1 1 1 0 4
1 0 0 0 0 0 0 0 0 0 0 0 0
1 0 2 2 2 2 2 2 2 2 2 2 2
1 0 0 0 0 0 0 0 0 0 0 0 2
1 1 1 1 1 1 1 1 1 1 1 0 2
1 0 0 0 0 0 0 0 0 0 0 0 2
1 0 2 2 2 2 2 2 2 2 2 2 2
1 0 0 0 0 0 0 0 0 0 0 0 2
1 1 1 1 1 1 1 1 1 1 1 0 2
0 0 0 0 0 0 0 0 0 0 0 0 2
3 0 2 2 2 2 2 2 2 2 2 2 2
3 0 0 0 0 0 0 0 0 0 0 0 0
3 3 3 3 3 3 3 3 3 3 3 3 3
"

df = read_matrix_longer(data) %>% print()
p = gglogo(df, c("#ccaa66", "#333333", "#333333", "#333333", "#c41a41"))
ggsave("eej-icon-snake.png", p, width = 1, height = 1, dpi = 160)

p = gglogo(df, c("#664411", "#ddbb77", "#ddbb77", "#cc8855", "#664411"))
ggsave("eej-icon-snail.png", p, width = 1, height = 1, dpi = 160)

p = gglogo(df, c("#cc2222", "#ccee33", "#ccee33", "#ccee33", "#ccee33"))
ggsave("eej-icon-flytrap.png", p, width = 1, height = 1, dpi = 160)

data = "
1 1 1 1 1 1 1 1 1 0 3 3 3
1 0 0 0 0 0 0 0 0 0 0 0 3
1 0 2 2 2 2 2 2 2 2 2 0 3
1 0 0 0 0 0 0 0 0 0 2 0 3
1 1 1 1 1 1 1 1 1 0 2 0 3
1 0 0 0 0 0 0 0 0 0 2 0 3
1 0 2 2 2 2 2 2 2 2 2 0 3
1 0 0 0 0 0 0 0 0 0 2 0 3
1 1 1 1 1 1 1 1 1 0 2 0 3
0 0 0 0 0 0 0 0 0 0 2 0 3
3 0 2 2 2 2 2 2 2 2 2 0 3
3 0 0 0 0 0 0 0 0 0 0 0 3
3 3 3 3 3 3 3 3 3 3 3 3 3
"

df = read_matrix_longer(data) %>% print()
p = gglogo(df, c("#000000", "#008066"))
ggsave("eej-icon-final.png", p, width = 1, height = 1, dpi = 160)

# #######1#########2#########3#########4#########5#########6#########7#########

df = bind_rows(
  tibble(id = "e1", x = c(9, 1, 1, 9, 1, 1, 9), y = c(13, 13, 9, 9, 9, 5, 5)),
  tibble(id = "e2", x = c(3, 11, 11, 3, 11, 11, 3), y = c(11, 11, 7, 7, 7, 3, 3)),
  tibble(id = "j", x = c(1, 1, 13, 13, 11), y = c(3, 1, 1, 13, 13))
) %>% print()

ggplot(df) +
  aes(x, y, group = id) +
  geom_path(size = 15, linejoin = "mitre") +
  coord_fixed() +
  theme_void() +
  theme(plot.background = element_rect("#eeeeee", NA))
