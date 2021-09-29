
make_beta = function(n, p = 0.5) {
  a = round(n * p)
  data = tibble(p = seq(0, 1, length.out = 1000L), pdf = dbeta(p, a, n - a))
}

df = tibble(n = c(10, 100, 1000, 10000)) %>%
  group_by(n) %>%
  summarize(make_beta(n, p = 0.5)) %>%
  ungroup() %>%
  print()

ggplot(df) +
  aes(p, pdf) +
  geom_line() +
  facet_wrap(vars(n), ncol = 1L, scales = "free_y", strip.position = "right")

ggplot(df) +
  aes(p, pdf) +
  geom_line(aes(group = n, color = n)) +
  scale_color_gradient(trans = "log10")
