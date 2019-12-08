
seconds = function(h=0, m=0, s=0) {
  s + 60 * m + 3600 * h
}
seconds(1, 33, 24)

sprintf_hms = function(seconds) {
  m = seconds %/% 60L
  s = seconds %% 60L
  h = m %/% 60L
  m = m %% 60L
  sprintf("%d:%02d:%02d", h, m, round(s))
}
seconds(1, 33, 24) %>% sprintf_hms()

tidyr::crossing(m = seq.int(3L, 4L), s = seq.int(0L, 55L, 5L)) %>%
  dplyr::mutate(seconds = seconds(0L, m, s)) %>%
  dplyr::mutate(km10 = sprintf_hms(seconds * 10)) %>%
  dplyr::mutate(half = sprintf_hms(seconds * 21.1)) %>%
  dplyr::mutate(full = sprintf_hms(seconds * 42.195))
