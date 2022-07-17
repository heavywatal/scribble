library(tidyverse)

plot_logo = function(scale, expand = 0, svglite_bug = FALSE) {
  scale = 1 / (1 + 2 * max(expand)) * scale
  stroke = 1.8 * scale
  pointsize = 4.5 * scale * ifelse(svglite_bug, 0.75, 1)
  if (length(expand) == 1L) {
    expand = rep(expand, 2L)
  }
  margin = 100 * expand
  mlim = matrix(c(-margin, 100 + margin), ncol = 2L)
  xlim = mlim[1L, ]
  ylim = mlim[2L, ]
  .poly = tibble(
    x = c(1, 7, 99),
    y = c(36, 21, 72)
  )
  .path = tibble(
    x = c(35, 11, 55, 41, 75, 71, 95),
    y = c(95, 5, 73, 5, 51, 5, 29)
  )
  .dot = tibble(x = 77, y = 77)
  path_color = "#222222"
  dot_color = "#a4321a"
  swoosh_color = "#e08010"
  ggplot() + aes(x, y) +
    geom_ribbon(aes(x = c(-Inf, 50), y = NULL, ymin = 50, ymax = Inf), fill = "#0057b7") +
    geom_ribbon(aes(x = c(-Inf, 50), y = NULL, ymin = -Inf, ymax = 50), fill = "#ffd700") +
    geom_polygon(data = .poly, fill = swoosh_color) +
    geom_path(data = .path, size = stroke, linejoin = "bevel", color = path_color) +
    geom_point(data = .dot, size = pointsize, color = dot_color) +
    coord_fixed(xlim = xlim, ylim = ylim, expand = FALSE)
}

ggplot2::theme_set(theme_void())

dev.off()
quartz(width = 6, height = 6)
plot_logo(6, 0)

dev.off()
quartz(width = 4, height = 4)
plot_logo(4, 0.1)
plot_logo(4, 0.125) %>%
  wtl::insert_layer(wtl::annotate_regpolygon(180L, radius = 50 * 1.25, x = 50, y = 50, alpha = 0.3))
plot_logo(4, 3)

dev.off()
quartz(width = 2, height = 2)
plot_logo(2, 0)
plot_logo(2, 3)

ggsave("ua-heavywatal-white.png", plot_logo(4), width = 4, height = 4, dpi = 300, bg = "#ffffff")
ggsave("ua-heavywatal-white-circle.png", plot_logo(4, 0.125), width = 4, height = 4, dpi = 300, bg = "#ffffff")
ggsave("ua-heavywatal-circle.png", plot_logo(4, 0.125), width = 4, height = 4, dpi = 300, bg = "transparent")
ggsave("ua-heavywatal.png", plot_logo(4), width = 4, height = 4, dpi = 300, bg = "transparent")
ggsave("ua-heavywatal-circle.svg", plot_logo(4, 0.125, svglite_bug = TRUE), width = 4, height = 4, bg = "transparent")
ggsave("ua-heavywatal.svg", plot_logo(4, 0, svglite_bug = TRUE), width = 4, height = 4, bg = "transparent")

dev.off()
scale = 4
quartz(width = scale * sqrt(3) / 2, height = scale)
hexa = wtl::annotate_regpolygon(6L, 77, x = 50, y = 50, linewidth = 4, fill = "#eeeeee", color = "#808080")
phex = plot_logo(scale, c(0.2, 0.3)) %>% wtl::insert_layer(hexa)
phex
ggsave("hex-heavywatal.png", phex, height = scale, width = scale * sqrt(3) / 2, dpi = 300, bg = "transparent")

phex = plot_logo(scale, c(0.2, 0.3), svglite_bug = TRUE) %>% wtl::insert_layer(hexa)
phex
ggsave("hex-heavywatal.svg", phex, height = scale, width = scale * sqrt(3) / 2, dpi = 300, bg = "transparent")

# #######1#########2#########3#########4#########5#########6#########7#########

dev.off()
scale = 4
quartz(width = scale * sqrt(3) / 2, height = scale)
radius = 50
ylim = c(-radius, radius)
xlim = ylim * sqrt(3) / 2
hex_tekkamaki = ggplot() +
  wtl::annotate_regpolygon(6L, radius, linewidth = 6, color = "#333333", fill = "#ffffff") +
  wtl::annotate_regpolygon(6L, radius * 2 / 5, fill = "#C41A41") +
  scale_x_continuous(expand = expansion(mult = 0.03)) +
  scale_y_continuous(expand = expansion(mult = 0.03)) +
  coord_fixed(xlim = xlim, ylim = ylim) +
  theme_void()
hex_tekkamaki
ggsave("hex-tekkamaki.svg", hex_tekkamaki, height = scale, width = scale * sqrt(3) / 2, dpi = 300, bg = "transparent")
ggsave("hex-tekkamaki.png", hex_tekkamaki, height = scale, width = scale * sqrt(3) / 2, dpi = 300, bg = "transparent")

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
