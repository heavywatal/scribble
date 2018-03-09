library(tidyverse)

StatHead = ggproto("StatHead", ggplot2::Stat,
  required_aes = c("x", "y"),
  compute_group = function(data, scales) {
    head(data, 6L)
  }
)

stat_head = function(
    mapping = NULL, data = NULL, geom = "point", position = "identity",
    inherit.aes = TRUE, check.aes = TRUE, check.param = TRUE,
    subset = NULL, show.legend = NA, ...,
    na.rm = FALSE) {
  ggplot2::layer(
    geom = geom, stat = StatHead, data = data, mapping = mapping,
    position = position, params = list(na.rm = na.rm, ...),
    inherit.aes = inherit.aes, check.aes = check.aes, check.param = check.param, subset = subset,
    show.legend = show.legend
  )
}

ggplot(iris, aes(Sepal.Length, Sepal.Width))+
  stat_head(colour="orange", size = 4)+
  geom_point()
