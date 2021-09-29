library(tidyverse)

mu = 20
n = 10000L
k_range = c(0.4, 1, 10, 100)
.df = k_range %>% purrr::map_dfr(~{
    k = .x
    prob = k / (k + mu)
    .tex = tibble(x = rexp(n, 1 / mu), dist = "exp") %>% dplyr::filter(k == 1)
    .tge = tibble(x = rgeom(n, 1 / mu), dist = "geom") %>% dplyr::filter(k == 1)
    .tga = tibble(x = rgamma(n, k, scale = (1 - prob) / prob), dist = "gamma")
    .tnb = tibble(x = rnbinom(n, k, prob), dist = "nbinom")
    .tpo = tibble(x = rpois(n, mu), dist = "pois") %>% dplyr::filter(k == max(k_range))
    .tno = tibble(x = rnorm(n, mu, sqrt(mu)), dist = "norm") %>% dplyr::filter(k == max(k_range))
    dplyr::bind_rows(.tex, .tge, .tga, .tnb, .tpo, .tno) %>%
    dplyr::mutate(k = k)
  }) %>% print()

ggplot(.df, aes(x)) +
  geom_histogram(bins = 81, center = 0) +
  xlim(-0.5, 80.5) +
  facet_grid(vars(k), vars(dist), labeller = label_both) +
  theme_bw()
