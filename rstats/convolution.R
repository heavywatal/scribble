dbinom_selection = function(x, size, prob, s = 0) {
  choose(size, x) * (1 - prob) ** (size - x) * ((1 + s) * prob) ** x / (1 + s * prob) ** size
}
dbinom(60, 100, 0.5)
dbinom_selection(60, 100, 0.5, 0)
dbinom_selection(60, 100, 0.5, 0.05)

main = function(N, i, s, T) {
  prob = numeric(N + 1)
  prob[i+1] = 1
  x = seq(0, N)
  evolve = function() {
    vapply(x, function(.k) {
      sum(dbinom_selection(.k, N, x / N, s) * prob)
    }, numeric(1))
  }
  env = environment()
  purrr::map_dfr(seq_len(T), function(time) {
    assign('prob', evolve(), env = env)
    tibble::tibble(time, freq = seq_along(prob) - 1, probability = prob)
  })
}

df = main(600, 50, 0.03, 100) %>% print()
df %>%
  ggplot(aes(time, freq))+
  geom_tile(aes(fill = probability))+
  theme(panel.grid = element_blank())
