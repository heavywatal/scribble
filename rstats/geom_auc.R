library(ggplot2)
library(dplyr)


# StatDensity(いわゆるgeom_density)の一部を切り取るためのStatを作る
StatCIL = ggproto(
  "StatCIL",
  StatDensity,
  compute_group = function(data, ci = 0.95, ...) {
    StatDensity$compute_group(data = data, ...) %>%
      filter(x <= quantile(data$x, (1 - ci) / 2))
  }
)

# ほとんどstat_densityからのコピペ
# 引数にciが追加
# bodyで呼び出されるlayerの引数のstatがStatCILに
# 同引数のparamsにci追加
stat_CIL = function(mapping = NULL, data = NULL,
                    geom = "area", position = "stack",
                    ...,
                    ci = 0.95,
                    bw = "nrd0",
                    adjust = 1,
                    kernel = "gaussian",
                    n = 512,
                    trim = FALSE,
                    na.rm = FALSE,
                    show.legend = NA,
                    inherit.aes = TRUE) {
  layer(
    data = data,
    mapping = mapping,
    stat = StatCIL,
    geom = geom,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      ci = ci,
      bw = bw,
      adjust = adjust,
      kernel = kernel,
      n = n,
      trim = trim,
      na.rm = na.rm,
      ...
    )
  )
}

# テスト
set.seed(71)
ggplot(data.frame(x = rnorm(100)), aes(x = x)) +
  stat_density() +
  stat_CIL(fill = "orange", ci = 0.6) +
  stat_CIL(fill = "red")


# #######1#########2#########3#########4#########5#########6#########7#########


library(ggplot2)
library(dplyr)


# StatDensity(いわゆるgeom_density)の一部を切り取るためのStatを作る
StatCI = ggproto(
  "StatCI",
  StatDensity,
  compute_group = function(data, ci = 0.95, ...) {
    l = 0.5 - ci / 2
    h = 1 - l
    Q = quantile(data$x, c(l, h))
    StatDensity$compute_group(data = data, ...) %>%
      filter(Q[1] <= x, x <= Q[2])
  }
)

# ほとんどstat_densityからのコピペ
# 引数にciが追加
# bodyで呼び出されるlayerの引数のstatがStatCIに
# 同引数のparamsにci追加
stat_CI = function(mapping = NULL, data = NULL,
                   geom = "area", position = "stack",
                   ...,
                   ci = 0.95,
                   bw = "nrd0",
                   adjust = 1,
                   kernel = "gaussian",
                   n = 512,
                   trim = FALSE,
                   na.rm = FALSE,
                   show.legend = NA,
                   inherit.aes = TRUE) {
  layer(
    data = data,
    mapping = mapping,
    stat = StatCI,
    geom = geom,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      ci = ci,
      bw = bw,
      adjust = adjust,
      kernel = kernel,
      n = n,
      trim = trim,
      na.rm = na.rm,
      ...
    )
  )
}

# テスト
set.seed(71)
ggplot(data.frame(x = rnorm(100)), aes(x = x)) +
  stat_density() +
  stat_CI(fill = "orange", ci = 0.95)
