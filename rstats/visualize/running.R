library(dplyr)

df_seconds = tibble::tibble(pace = seq.int(180, 300, 5)) %>%
  dplyr::mutate(km10 = pace * 10) %>%
  dplyr::mutate(half = round(pace * 21.1)) %>%
  dplyr::mutate(full = round(pace * 42.2)) %>%
  print()

# #######1#########2#########3#########4#########5#########6#########7#########

library(hms)

df_seconds %>% dplyr::mutate(across(everything(), hms::hms))

# #######1#########2#########3#########4#########5#########6#########7#########

library(lubridate)

format_hms = function(x) {
  h = lubridate::hour(x)
  m = lubridate::minute(x)
  s = lubridate::second(x)
  sprintf("%02d:%02d:%02d", h, m, s)
}

df_seconds %>%
  dplyr::mutate(across(everything(), lubridate::seconds_to_period)) %>%
  dplyr::mutate(across(everything(), format_hms))
