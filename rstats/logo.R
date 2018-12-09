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
ggsave("heavywatal-circle.png", plot_logo(4, 0.8), width = 4, height = 4, dpi = 300, bg = "transparent")
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
