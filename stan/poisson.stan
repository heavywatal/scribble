data {
  int<lower=0> N;
  array[N] int<lower=0> x;
}

parameters {
  real<lower=0> lambda;
}

model {
  x ~ poisson(lambda);
}

generated quantities {
  array[N] int<lower=0> x_tilde;
  for (i in 1:N) {
    x_tilde[i] = poisson_rng(lambda);
  }
}
