library(tidyverse)

plot_logo = function(scale, expand = 0, svglite_bug = FALSE) {
  scale = 1 / (1 + 2 * expand) * scale
  stroke = 1.8 * scale
  pointsize = 4.5 * scale * ifelse(svglite_bug, 0.75, 1)
  lim = c(0, 100)
  .poly = tibble(
    x = c(1, 7, 99),
    y = c(36, 21, 72)
  )
  # .poly = tibble(
  #   x = c(1, 8, 99),
  #   y = c(60, 30, 71)
  # )
  .path = tibble(
    x = c(35, 11, 55, 41, 75, 71, 95),
    y = c(95, 5, 73, 5, 51, 5, 29)
  )
  .dot = tibble(x = 77, y = 77)
  # .dot = tibble(x = 77, y = 83)
  ggplot(mapping = aes(x, y)) +
    geom_polygon(data = .poly, fill = "#e08010") +
    geom_path(data = .path, size = stroke, linejoin = "bevel", colour = "#222222") +
    geom_point(data = .dot, size = pointsize, colour = "#a4321a") +
    # wtl::annotate_polygon(.dot$x, .dot$y, n = 180L, radius = 7, fill = "#a4321a") +
    coord_fixed(xlim = lim, ylim = lim) +
    scale_x_continuous(expand = expand_scale(mult = expand)) +
    scale_y_continuous(expand = expand_scale(mult = expand)) +
    theme_void()
}

dev.off()
quartz(width = 6, height = 6)
plot_logo(6, 0)

dev.off()
quartz(width = 4, height = 4)
plot_logo(4, 0)
plot_logo(4, 0.125) %>%
  wtl::insert_layer(wtl::annotate_polygon(50, 50, 180L, radius = 50 * 1.25, fill = "#cccccc"))
plot_logo(4, 3)

dev.off()
quartz(width = 2, height = 2)
plot_logo(2, 0)
plot_logo(2, 3)

ggsave("heavywatal-white.png", plot_logo(4), width = 4, height = 4, dpi = 300)
ggsave("heavywatal-white-circle.png", plot_logo(4, 0.125), width = 4, height = 4, dpi = 300)
ggsave("heavywatal-circle.png", plot_logo(4, 0.125), width = 4, height = 4, dpi = 300, bg = "transparent")
ggsave("heavywatal.png", plot_logo(4), width = 4, height = 4, dpi = 300, bg = "transparent")
ggsave("heavywatal-circle.svg", plot_logo(4, 0.125, svglite_bug = TRUE), width = 4, height = 4, bg = "transparent")
ggsave("heavywatal.svg", plot_logo(4, 0, svglite_bug = TRUE), width = 4, height = 4, bg = "transparent")

dev.off()
scale = 4
quartz(width = scale * sqrt(3) / 2, height = scale)
xlim = c(0, 100)
ylim = (xlim * 2 / sqrt(3)) %>% {. - mean(. - xlim)}
phex = plot_logo(scale, 0.21) %>%
  wtl::insert_layer(wtl::annotate_polygon2(50, 50, 6L, 77, fill = "#eeeeee", colour = "#808080", stroke = 4)) +
  coord_fixed(xlim = xlim, ylim = ylim)
phex
ggsave("hex-heavywatal.png", phex, height = scale, width = scale * sqrt(3) / 2, dpi = 300, bg = "transparent")

phex = plot_logo(scale, 0.21, svglite_bug = TRUE) %>%
  wtl::insert_layer(wtl::annotate_polygon2(50, 50, 6L, 77, fill = "#eeeeee", colour = "#808080", stroke = 4)) +
  coord_fixed(xlim = xlim, ylim = ylim)
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
  wtl::annotate_polygon2(0, 0, 6L, radius, fill = "#ffffff", colour = "#333333", stroke = 6) +
  wtl::annotate_polygon(0, 0, 6L, radius * 2 / 5, fill = "#C41A41") +
  scale_x_continuous(expand = expand_scale(mult = 0.03)) +
  scale_y_continuous(expand = expand_scale(mult = 0.03)) +
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
    tidyr::pivot_longer(-y, names_to = "x", names_prefix = "X") %>%
    dplyr::mutate(x = as.integer(x))
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

data = "
1 1 0 1 1 0 2
1 0 0 1 0 0 0
1 1 0 1 1 0 1
1 0 0 1 0 0 1
1 1 0 1 1 0 1
0 0 0 0 0 0 1
0 0 0 0 1 1 1
"

palette = c(`0` = "#eeeeee", `1` = "#006666", `2` = "#C41A41")

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

palette = c(`0` = "#ccaa66", `1` = "#333333", `2` = "#333333", `3` = "#333333", `4` = "#c41a41")
palette = c(`0` = "#664411", `1` = "#ddbb77", `2` = "#ddbb77", `3` = "#cc8855", `4` = "#664411")
palette = c(`0` = "#cc2222", `1` = "#ccee33", `2` = "#ccee33", `3` = "#ccee33", `4` = "#ccee33")

ggsave("eej-icon.png", p, width = 1, height = 1, dpi = 160)
ggsave("eej-icon-snake.png", p, width = 1, height = 1, dpi = 160)
ggsave("eej-icon-snail.png", p, width = 1, height = 1, dpi = 160)



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

palette = function(bg = "#333333", fg1 = "#999999", fg2 = fg1, fg3 = fg1) {
  c(`0` = bg, `1` = fg1, `2` = fg2, `3` = fg3)
}

df = read_matrix_longer(data) %>% print()

p = ggplot(df, aes(x, y)) +
  geom_raster(aes(fill = value)) +
  scale_y_reverse() +
  scale_fill_manual(values = palette(), guide = NULL) +
  coord_fixed(expand = FALSE) +
  theme_void()
p

df = bind_rows(
  tibble(id = "e1", x = c(9, 1, 1, 9, 1, 1, 9), y = c(13, 13, 9, 9, 9, 5, 5)),
  tibble(id = "e2", x = c(3, 11, 11, 3, 11, 11, 3), y = c(11, 11, 7, 7, 7, 3, 3)),
  tibble(id = "j", x = c(1, 1, 13, 13, 11), y = c(3, 1, 1, 13, 13))
) %>% print()



ggplot(df) +
  aes(x, y, group = id) +
  geom_path(size = 20, linejoin = "mitre") +
  coord_fixed() +
  theme_void() +
  theme(plot.background = element_rect("#eeeeee", NA))



# #######1#########2#########3#########4#########5#########6#########7#########

df = tibble(
  theta = seq(0, 2 * pi, length.out = 361),
  x = cos(theta), y = sin(theta)) %>%
  print()

dev.off()
quartz(NULL, 1, 1, dpi = 300)
size = 2.7
p = ggplot(df, aes(x, y)) +
  geom_path(size = size, color = "#C41A41") +
  annotate("line", x = c(-1, 1), y = 0, size = size, color = "#C41A41") +
  geom_vline(xintercept = 0, size = size, color = "#eeeeee") +
  coord_fixed(xlim = c(-3, 3), y = c(-3, 3), expand = FALSE) +
  theme_void() + theme(plot.background = element_rect(fill = "#eeeeee", linetype = 0))
p
ggsave("eej-icon-j.png", p, width = 1, height = 1, dpi = 300)


set.seed(20200523)
n = 32
df = tibble(
  a = tan(runif(n, 0, 2 * pi)),
  b = runif(n, 2 * lim[1], 2 * lim[2]),
  size = runif(n),
  color = sample(LETTERS[1:7], n, replace = TRUE))

p = ggplot(df) +
  geom_abline(aes(slope = a, intercept = b, size = size, color = color), alpha = 0.5) +
  scale_color_brewer(palette = "Set1") +
  scale_size(range = c(1, 4)) +
  coord_fixed(xlim = 0.5*lim, ylim = 0.5*lim, expand = FALSE) +
  theme_void() +
  theme(legend.position = "none")
p
ggsave("eej-icon-uma.png", p, width = 1, height = 1, dpi = 300)
