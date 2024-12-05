library(ggplot2)

# ?rlnorm

rlnorm_enorma = function(n, meanlog = 0, sdlog = 1) {
  epsilon = rnorm(n, 0, sdlog)
  exp(meanlog) * exp(epsilon)
}

rlnorm_enorm = function(n, meanlog = 0, sdlog = 1) {
  exp(rnorm(n, meanlog, sdlog))
}

cpp11::cpp_source(code = "
#include <random>

[[cpp11::register]]
std::vector<double> rlnorm_cpp(int n, double meanlog, double sdlog) {
  std::mt19937_64 rng{std::random_device{}()};
  std::lognormal_distribution dist{meanlog, sdlog};
  std::vector<double> res;
  res.reserve(n);
  for (int i = 0; i < n; ++i) {
    res.push_back(dist(rng));
  }
  return res;
}", cxx_std = "CXX17")

rlnorm(6, 0, 1)
rlnorm_enorma(6, 0, 1)
rlnorm_enorm(6, 0, 1)
rlnorm_cpp(6, 0, 1)

N = 10000
sigma = 0.6
exp_u = 1000
exp_s = exp(sigma)
meanlog = log(exp_u)
sdlog = log(exp_s)
stopifnot(all.equal(sigma, sdlog))

df_ln = tibble::tibble(x = rlnorm(N, meanlog, sdlog), label = "rlnorm")
df_ea = tibble::tibble(x = rlnorm_enorma(N, meanlog, sdlog), label = "enorma")
df_en = tibble::tibble(x = rlnorm_enorm(N, meanlog, sdlog), label = "enorm")
df_cp = tibble::tibble(x = rlnorm_cpp(N, meanlog, sdlog), label = "cpp")
df = dplyr::bind_rows(df_ln, df_ea, df_en, df_cp) |> print()

p = ggplot(df) + aes(x, fill = label) +
  geom_histogram(bins = 40L, boundary = 0) +
  geom_vline(xintercept = exp_u) +
  facet_grid(vars(label)) +
  theme(legend.position = "none")
cowplot::plot_grid(p, p + scale_x_log10())

df |> dplyr::summarize(
  mu = mean(log(.data$x)),
  exp_u = exp(.data$mu),
  sigma = sd(log(.data$x)),
  exp_s = exp(.data$sigma),
  .by = label
)

bench::mark(
  rlnorm(N, meanlog, sdlog),
  rlnorm_enorma(N, meanlog, sdlog),
  rlnorm_enorm(N, meanlog, sdlog),
  rlnorm_cpp(N, meanlog, sdlog),
  check = FALSE
)
