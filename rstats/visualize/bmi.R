library(tidyverse)

df = tidyr::crossing(
  height = seq(1.4, 1.9, 0.01),
  weight = seq(36, 92, 0.5)
) |>
  dplyr::mutate(bmi = weight / (height ** 2)) |>
  dplyr::mutate(bmi_nt = 1.3 * weight / (height ** 2.5)) |>
  print()

geom_current = function(height, weight) {
  list(
    geom_vline(xintercept = 1.795),
    geom_hline(yintercept = 71),
    annotate("point", x = 1.795, y = 71)
  )
}

p_base = ggplot(df) +
  aes(height, weight) +
  scale_fill_viridis_d(option = "turbo", guide = guide_colorsteps(title = "BMI")) +
  coord_cartesian(expand = FALSE) +
  theme_minimal(12) +
  theme(legend.position = "none")

p_bmi = p_base +
  geom_contour_filled(aes(z = bmi), breaks = c(0, seq(19, 25), Inf), alpha = 0.85) +
  stat_function(fun = \(x) 22 * (x ** 2), linewidth = 1, color = "#ffffff") +
  geom_current(1.795, 71) +
  labs(title = "common BMI")
p_bmi

p_bmi_nt = p_base +
  geom_contour_filled(aes(z = bmi_nt), breaks = c(0, seq(19, 25), Inf), alpha = 0.85) +
  stat_function(fun = \(x) 22 * (x ** 2.5) / 1.3, linewidth = 1, color = "#ffffff") +
  geom_current(1.795, 71) +
  labs(title = "Trefethen BMI")
p_bmi_nt

legend = cowplot::get_legend(p_bmi + theme(legend.position = "right"))
p = cowplot::plot_grid(p_bmi, p_bmi_nt, legend, nrow = 1L, rel_widths = c(1, 1, 0.2))
p
ggsave("bmi.pdf", p, width = 8, height = 4)
