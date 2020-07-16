methods = c(
  "euclidean", # L-2
  "maximum",   # L-infty, Chebyshev
  "manhattan", # L-1, grid
  "canberra",  # scaled manhattan
  "binary",    # ignore 0-0
  "minkowski"  # General
)

df = tibble(
  x = c(0, 0, 1, 1, 1, 1),
  y = c(1, 0, 1, 1, 0, 1)
) %>% print()

methods %>%
  rlang::set_names() %>%
  purrr::map_dbl(~dist(t(df), method = .x))

as.dist(1 - cor(df, method = "spearman"))

# #######1#########2#########3#########4#########5#########6#########7#########
# unbiased estimator of FST
# Bhatia et al. 2013 Genome Res.

hexp = function(p1, p2 = p1) p1 * (1 - p2)

na = 1000
nb = 2000
pa = 0.2
pb = 0.3
(pa - pb) ** 2

a = rbinom(100000, na, pa)
b = rbinom(100000, nb, pb)
pa_sam = a / na
pb_sam = b / nb

within_sam = mean(hexp(pa_sam) + hexp(pb_sam))
between_sam = mean(hexp(pa_sam, pb_sam) + hexp(pb_sam, pa_sam))

all.equal(between_sam - within_sam, mean((pa_sam - pb_sam) ** 2))

bias = mean(hexp(pa_sam) / (na - 1) + hexp(pb_sam) / (nb - 1))
bias
mean((pa_sam - pb_sam) ** 2)

# #######1#########2#########3#########4#########5#########6#########7#########

jukes_cantor_1969 = function(p) {
  - 3 / 4 * log(1 - 4 * p / 3)
}

df = tibble(
  p = seq(0, 0.6, 0.01),
  d = jukes_cantor_1969(p)
) %>% print()

p = ggplot(df) + aes(p, d) +
  geom_line(size = 2) +
  geom_abline(slope = 1, intercept = 0, alpha = 0.5) +
  coord_fixed(xlim = c(0, 1), ylim = c(0, 1), expand = FALSE)
p

ggsave("jukes-cantor-1969.png", p, width = 4, height = 4)
