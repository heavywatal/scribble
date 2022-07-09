install.packages("cmdstanr", repos = "https://mc-stan.org/r-packages/")
install.packages("bayesplot")

# #######1#########2#########3#########4#########5#########6#########7#########
library(cmdstanr)

cmdstanr::check_cmdstan_toolchain()
cmdstanr::install_cmdstan()
cmdstanr::cmdstan_path()
cmdstanr::cmdstan_version()

sample_size = 100L
mydata = list(N = sample_size, x = rpois(sample_size, 10))

model = cmdstan_model("../stan/poisson.stan")
fit = model$sample(mydata)

print(fit)
fit$summary()
fit$cmdstan_summary()
fit$cmdstan_diagnose()
fit$sampler_diagnostics()
fit$diagnostic_summary()
fit$metadata()

draws = fit$draws()
draws_df = fit$draws(format = "df")

# #######1#########2#########3#########4#########5#########6#########7#########
library(bayesplot)

params = names(model$variables()$parameters)
bayesplot::mcmc_acf_bar(draws, pars = params)
bayesplot::mcmc_trace(draws, pars = params)
bayesplot::mcmc_hist(draws, pars = params)
bayesplot::mcmc_combo(draws, pars = params)

rhat = bayesplot::rhat(fit)
neff = bayesplot::neff_ratio(fit)
bayesplot::mcmc_rhat(rhat)
bayesplot::mcmc_neff(neff)
