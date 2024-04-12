# install.packages("tidyverse")
# install.packages("ggrepel")

library(tidyverse)
library(ggrepel)
library(broom)

# #######1#########2#########3#########4#########5#########6#########7#########

data = iris |>
  dplyr::group_by(Species) |>
  dplyr::mutate(rowname = paste0(Species, "-", row_number())) |>
  dplyr::ungroup() |>
  dplyr::select(!Species) |>
  tibble::column_to_rownames()

head(data)
pc = prcomp(data, scale = TRUE)
var_explained = pc$sdev ** 2 / sum(pc$sdev ** 2)
pc_labels = sprintf("PC%d (%.1f%%)", seq_along(var_explained), 100 * var_explained)

pc_x = pc[["x"]] |>
  as.data.frame() |>
  tibble::rownames_to_column("label") |>
  tibble::as_tibble() |>
  dplyr::bind_cols(iris) |>
  print()

pc_rotation = pc[["rotation"]] |>
  as.data.frame() |>
  tibble::rownames_to_column("label") |>
  tibble::as_tibble() |>
  print()

pc_mean = pc_x |>
  dplyr::summarize(across(where(is.numeric), mean), .by = Species) |>
  print()

p = ggplot(pc_x) +
  aes(PC1, PC2) +
  geom_point(aes(color = Species)) +
  geom_point(aes(color = Species), data = pc_mean, size = 4, shape = 4) +
  ggrepel::geom_text_repel(aes(label = Species), data = pc_mean, alpha = 0.6) +
  geom_segment(data = pc_rotation, xend = 0, yend = 0, alpha = 0.6) +
  ggrepel::geom_text_repel(aes(label = label), data = pc_rotation, alpha = 0.6) +
  coord_fixed() +
  labs(x = pc_labels[1], y = pc_labels[2]) +
  theme(legend.position = "top")
p
ggsave("pc-iris.png", p, width = 4, height = 4)

# #######1#########2#########3#########4#########5#########6#########7#########

pc = prcomp(mtcars, scale = TRUE)
var_explained = pc$sdev ** 2 / sum(pc$sdev ** 2)
pc_labels = sprintf("PC%d (%.1f%%)", seq_along(var_explained), 100 * var_explained)

pc_x = pc[["x"]] |>
  as.data.frame() |>
  tibble::rownames_to_column("label") |>
  tibble::as_tibble() |>
  dplyr::bind_cols(mtcars) |>
  print()

pc_rotation = pc[["rotation"]] |>
  as.data.frame() |>
  tibble::rownames_to_column("label") |>
  tibble::as_tibble() |>
  print()

p = ggplot(pc_x) +
  aes(PC1, PC2) +
  geom_point(aes(color = cyl)) +
  ggrepel::geom_text_repel(aes(label = label), segment.color = NA) +
  geom_segment(data = pc_rotation, xend = 0, yend = 0, alpha = 0.6) +
  ggrepel::geom_text_repel(aes(label = label), data = pc_rotation, segment.color = NA, alpha = 0.6) +
  coord_fixed() +
  labs(x = pc_labels[1], y = pc_labels[2])
p
ggsave("pc-mtcars.png", p, width = 6, height = 6)

# #######1#########2#########3#########4#########5#########6#########7#########

broom::tidy(pc, matrix = "u")
broom::tidy(pc, matrix = "samples")
broom::tidy(pc, matrix = "x")

broom::tidy(pc, matrix = "v")
broom::tidy(pc, matrix = "variables")
broom::tidy(pc, matrix = "rotation")

broom::tidy(pc, matrix = "pcs")
broom::tidy(pc, matrix = "d")

# #######1#########2#########3#########4#########5#########6#########7#########

var_explained = function(pc) {
  pc$sdev ** 2 / sum(pc$sdev ** 2)
}

rownamed_to_tibble = function(.data, var = "label") {
  as.data.frame(.data) |>
    tibble::rownames_to_column(var = var) |>
    tibble::as_tibble()
}

ggplottable_prcomp = function(pc) {
  scale = pc$sdev
  x = sweep(pc[["x"]], 2, scale, FUN = "/") |> rownamed_to_tibble()
  rotation = sweep(pc[["rotation"]], 2, scale, FUN = "*") |> rownamed_to_tibble()
  ve = var_explained(pc)
  list(
    x = x,
    rotation = rotation,
    sdev = pc[["sdev"]],
    var = ve,
    label = sprintf("PC%d (%.1f%%)", seq_along(ve), 100 * ve)
  )
}
res = ggplottable_prcomp(pc)

gbiplot = function(res, axes = c(1, 2), color = NULL, labels = TRUE, vectors = TRUE) {
  p = ggplot(res$x) +
    aes_string(paste0("PC", axes[1]), paste0("PC", axes[2])) +
    geom_point(aes_string(color = color)) +
    coord_fixed() +
    labs(x = res$label[axes[1]], y = res$label[axes[2]])
  if (isTRUE(labels)) {
    p = p + ggrepel::geom_text_repel(aes(label = label), segment.color = NA)
  }
  if (isTRUE(vectors)) {
    .ar = arrow(length = unit(0.03, "npc"), ends = "first")
    p = p + geom_segment(data = res$rotation, arrow = .ar, xend = 0, yend = 0, alpha = 0.5, size = 1)
    p = p + ggrepel::geom_text_repel(aes(label = label), data = res$rotation, segment.color = NA)
  } else {
    p = p + annotate("point", x = 0, y = 0, shape = 3, size = 4)
  }
  p
}
gbiplot(res, c(1, 2), color = "PC3", labels = TRUE, vectors = TRUE)

ggbiplot(pc, c(1, 2))
biplot(pc, var.axes = TRUE, pc.biplot = TRUE)

ggsave("pc-mtcars.png", p, width = 6, height = 6)
