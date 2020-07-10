library(tidyverse)

# convert to 1-row tibble
vec = c(answer = 42L, whoami = 24601L)
dplyr::bind_rows(vec)
tibble::as_tibble(t(vec))

simple = function(interest = 0.05, principal = 100) {
  asset = numeric(21L)
  asset[[1L]] = principal
  for (i in seq.int(2L, length(asset))) {
    asset[[i]] = asset[[i - 1L]] + principal * interest
  }
  asset
}
simple(0.01)

composite = function(interest = 0.05, principal = 100) {
  asset = numeric(21L)
  asset[[1L]] = principal
  for (i in seq.int(2L, length(asset))) {
    asset[[i]] = asset[[i - 1L]] * (1 + interest)
  }
  asset
}

composite(0.01)

faccumulate = function(interest = 0.05, fund = 40, init = 0) {
  asset = numeric(21L)
  # principal = numeric(21L)
  principal = (seq_len(21L) - 1L) * fund + init
  asset[[1L]] = init
  for (i in seq.int(2L, length(asset))) {
    asset[[i]] = (asset[[i - 1L]] + fund * 0.5) * (1 + interest) + fund * 0.5
  }
  tibble(year = seq_along(asset) - 1L, principal, asset, benefit = round(asset - principal))
}
faccumulate(0.03, 40, 0)
