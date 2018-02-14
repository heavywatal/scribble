library(tidyverse)

# convert to 1-row tibble
vec = c(answer = 42L, whoami = 24601L)
dplyr::bind_rows(vec)
tibble::as_tibble(t(vec))
