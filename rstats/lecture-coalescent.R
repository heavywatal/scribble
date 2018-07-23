library(tidyverse)

make_table = function(.ncol = 10L, .nrow = 30L) {
  tibble(
    x = rep(seq_len(.ncol), .nrow),
    generation = rep(seq_len(.nrow), each = .ncol),
    parent = c(seq_len(.ncol), sample(seq_len(.ncol), .ncol * (.nrow - 1L), replace = TRUE)),
    forward = TRUE,
    backward = FALSE
  )
}
.tbl = make_table() %>% print()
.tbl %>% .plot()

trace_backward = function(.tbl, .start = max(.tbl$generation)) {
  .l = list()
  .l[[.start]] = .tbl %>%
    dplyr::filter(generation == .start) %>%
    dplyr::mutate(backward = TRUE) # %>% print()
  for (.x in seq(.start, 2L)) {
    .pop = .l[[.x]]
    .parent = dplyr::filter(.pop, backward)$parent
    .l[[.x - 1L]] = .tbl %>%
      dplyr::filter(generation == .x - 1L) %>%
      dplyr::mutate(backward = x %in% .parent)
  }
  dplyr::bind_rows(.l)
}
.tbl %>% trace_backward()

trace_forward = function(.tbl) { # after trace_backward()
  .parents = .tbl %>% dplyr::filter(generation == 1L, backward) %>% {
    .$x
  }
  .l = list()
  .l[[1L]] = .tbl %>%
    dplyr::filter(generation == 1L) %>%
    dplyr::mutate(forward = backward)
  for (.x in seq(2L, max(.tbl$generation))) {
    .pop = .tbl %>%
      dplyr::filter(generation == .x) %>%
      dplyr::mutate(forward = (parent %in% .parents))
    .parents = .pop %>% dplyr::filter(forward) %>% {
      .$x
    }
    .l[[.x]] = .pop
  }
  dplyr::bind_rows(.l)
}
.tbl %>% trace_backward() %>% trace_forward()

coalesced_all = function(.tbl) {
  dplyr::filter(.tbl, generation == 1L) %>% {
    sum(.$backward) == 1L
  }
}

make_good_table = function() {
  repeat {
    .tbl = make_table() %>% trace_backward()
    if (coalesced_all(.tbl)) {
      return(.tbl %>% trace_forward())
    }
  }
}
.good = make_good_table()

.plot = function(.tbl, .tail = max(.tbl$generation)) {
  .tbl %>%
    dplyr::mutate(backward = ifelse(generation > max(generation) - .tail, backward, FALSE)) %>%
    ggplot(aes(x, generation)) +
    geom_point(aes(colour = forward, fill = backward), pch = 21, size = 7) +
    geom_text(aes(label = parent, colour = forward), size = 4.5) +
    labs(x = NULL, y = NULL) +
    scale_colour_manual(values = c(`FALSE` = "#999999", `TRUE` = "#000000")) +
    scale_fill_manual(values = c(`FALSE` = "#ffffff", `TRUE` = "#aaaaaa")) +
    scale_y_reverse(breaks = c(10, 20, 30)) +
    coord_fixed() +
    theme_bw() +
    theme(
      legend.position = "none",
      panel.border = element_blank(), panel.grid = element_blank(),
      axis.text.x = element_blank(), axis.ticks = element_blank()
    )
}
.good %>% .plot()
.good %>% .plot(3L)
make_good_table() %>% .plot()

.npages = 100L
.tbls = purrr::map(seq_len(.npages), ~{
  make_good_table()
})

.plts = purrr::map(.tbls, ~{
  .plot(.x, 3L)
})
ggsave("random-numbers-assist.pdf", .plts, width = 5, height = 10)

.answers = purrr::map(.tbls, .plot)
ggsave("random-numbers-answer.pdf", .answers, width = 5, height = 10)
