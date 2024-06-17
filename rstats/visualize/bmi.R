library(tidyverse)

df = tidyr::crossing(
  height = seq(1.4, 1.9, 0.01),
  weight = seq(36, 92, 0.5)
) |>
  dplyr::mutate(bmi = weight / (height ** 2)) |>
  print()

p = ggplot(df) +
  aes(height, weight) +
  geom_contour_filled(aes(z = bmi), breaks = c(0, seq(19, 25), Inf), alpha = 0.85) +
  scale_fill_viridis_d(option = "turbo", guide = guide_colorsteps(title = "BMI")) +
  stat_function(fun = function(x) 22 * (x ** 2), linewidth = 1, color = "#ffffff") +
  geom_vline(xintercept = 1.795) +
  geom_hline(yintercept = 71) +
  annotate("point", x = 1.795, y = 71) +
  theme_minimal()
p
ggsave("bmi.pdf", p, width = 4, height = 4)
