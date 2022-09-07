library(tidyverse)

generate_p = function(length) {
  0.1 ** seq(1, 6, length.out = length)
}

n_tests = 10 ** seq.int(1, 4)

df = tidyr::crossing(n_tests, method = p.adjust.methods) |>
  dplyr::mutate(data = purrr::map2(n_tests, method, ~{
    p = generate_p(.x)
    tibble::tibble(p = p, adjusted = p.adjust(p, method = .y))
  })) |>
  tidyr::unnest_longer(data) |>
  tidyr::unpack(cols = data) |>
  print()

p = ggplot(df) +
  aes(p, adjusted) +
  geom_point(aes(color = method)) +
  geom_abline(intercept = 0, slope = 1) +
  scale_x_log10() +
  scale_y_log10() +
  facet_grid(vars(method), vars(n_tests)) +
  theme_minimal()

ggsave("p-adjust.png", p, width = 6, height = 6, bg = "#ffffff")
