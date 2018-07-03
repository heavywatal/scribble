wtl::refresh('rtumopp')

setwd("~/working/tumopp/spatial")
result_dirs = fs::dir_ls(type = "directory")
raw_results = tumopp::read_results(result_dirs)

# saveRDS(raw_results, "raw_results.rds")

.tr_P = c(random='Push-1', roulette='Push-2', mindrag='Push-3', minstraight='Push-4')
.tr_L = c(const='Constant-rate', step='Step-function', linear='Linear-function')

results = raw_results %>%
  dplyr::select_if(~ n_distinct(.x) > 1L) %>%
  dplyr::select(-outdir, -seed, -drivers) %>%
  dplyr::group_by(local, path, shape) %>%
  dplyr::mutate(replicate = dplyr::row_number()) %>%
  dplyr::ungroup() %>%
  dplyr::mutate(
    local = factor(.tr_L[local], levels=.tr_L),
    path = factor(.tr_P[path], levels=.tr_P),
    extant = purrr::map(population, filter_extant),
    graph = purrr::map(population, make_igraph),
  ) %>%
  print()

.population = results$population[[1]]

df_sampled = results %>%
  dplyr::mutate(
    regions = purrr::map(extant, sample_uniform_regions, nsam=6L, ncell=100L),
    subgraph = purrr::map2(graph, regions, ~tumopp::subtree(.x, purrr::flatten_chr(.y$id)))
  ) %>% print()

# saveRDS(df_sampled, "df_sampled.rds")

df_extant = df_sampled %>%
  dplyr::transmute(
    local, path, shape,
    extant = purrr::map2(extant, regions, ~{
      .x %>%
        dplyr::left_join(tumopp:::tidy_regions(.y), by = "id") %>%
        dplyr::mutate(clade = as.factor(as.integer(clade)))
    })
  ) %>%
  tidyr::unnest() %>%
  print()

.p_sampled = df_extant %>%
  sample_n(40000) %>%
  plot_lattice2d(size = 0.3) +
  geom_point(data = function(x) {dplyr::filter(x, !is.na(region))}, aes(x, y), size = 0.3, alpha = 0.4) +
  scale_colour_brewer(palette = "Spectral", guide = FALSE) +
  facet_grid(local + path ~ shape + replicate) +
  wtl::erase(axis.title, axis.text, axis.ticks) +
  theme(panel.spacing = unit(0, 'mm'))
.p_sampled
ggsave('samples-6.png', .p_sampled, width = 12, height = 12)


df_distance = df_sampled %>%
  dplyr::mutate(distance = purrr::map2(subgraph, regions, within_between_samples)) %>%
  print()

.p_fst = df_distance %>%
  dplyr::select(local, path, shape, replicate, distance) %>%
  tidyr::unnest() %>%
  ggplot(aes(euclidean, fst)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = lm, formula = y ~ 0 + x, se = FALSE, colour = "#000000", alpha = 0.5) +
  facet_grid(local + path ~ shape + replicate) +
  coord_cartesian(ylim = c(0, 1))
.p_fst
ggsave('fst-6.png', .p_fst, width = 12, height = 12)


df_vaf = df_sampled %>%
  dplyr::mutate(tidy_vaf = purrr::map2(subgraph, regions, ~make_vaf(.x, .y$id, mu = -1))) %>%
  print()

.p_vaf = df_vaf %>%
  dplyr::select(local, path, shape, replicate, tidy_vaf) %>%
  tidyr::unnest() %>%
  ggplot(aes(sample, site)) +
  geom_tile(aes(fill = frequency)) +
  scale_fill_distiller(palette = "Spectral", limit = c(0, 1), guide = FALSE) +
  coord_cartesian(expand = FALSE) +
  facet_grid(local + path ~ shape + replicate, scales = "free_y")
.p_vaf
ggsave('vaf-6.png', .p_vaf, width = 12, height = 12)


# #######1#########2#########3#########4#########5#########6#########7#########

.population = results$population[[1L]]
.extant = filter_extant(.population)
.regions = sample_uniform_regions(.extant, nsam = 6L, ncell = 200L, jitter = 10)
.extant %>% sample_n(8000L) %>%
  plot_lattice2d() + geom_point(data = .regions, size = 8) +
  scale_colour_brewer(palette = "Spectral", guide = FALSE) +
  wtl::erase(axis.title, axis.ticks)

.cross_evaluate_mrs = function(population) {
  tidyr::crossing(
    repl_capture = seq_len(5L),
    nsam = seq_len(6L),
    ncell = c(100L, 200L),
    threshold = c(0.05, 0.1)
  ) %>% dplyr::mutate(capture_rate = purrr::pmap_dbl(., function(nsam, ncell, threshold, ...) {
    evaluate_mrs(population, nsam = nsam, ncell = ncell, threshold = threshold, jitter = 10)
  }))
}
.result = .cross_evaluate_mrs(.population)
.result %>% plot_capture_rate() + facet_grid(threshold ~ ncell)

df_eval = results %>%
  dplyr::mutate(capture = wtl::mcmap(population, .cross_evaluate_mrs)) %>%
  print()

# saveRDS(df_eval, "~/Desktop/df_eval.rds")

.p_eval = df_eval %>%
  dplyr::select(local, path, shape, replicate, capture) %>%
  tidyr::unnest() %>%
  tidyr::nest(-threshold, -ncell) %>%
  dplyr::mutate(plt = purrr::map(data, ~{
    plot_capture_rate(.x) +
    facet_grid(local + path ~ shape + replicate)
  })) %>%
  print()

.p_eval$plt[[1L]]

.p_eval %>% purrr::pmap(function(threshold, ncell, plt, ...) {
  .outfile = sprintf("capture-rate-%d-%.2f.png", ncell, threshold)
  ggsave(.outfile, plt, width=11, height=12)
  .outfile
})

# #######1#########2#########3#########4#########5#########6#########7#########

wtl::refresh("rtumopp")

.threshold = 0.05
.detectable = .regions$id %>% purrr::map(~internal_nodes(.graph, as.character(.x), .threshold) %>% as.integer())
.combn_biopsy = .detectable %>% combn_ids() %>% print()
.tbl = summarize_capture_rate(.combn_biopsy, .population, .threshold) %>% print()
.tbl %>% plot_capture_rate()

.combn_capture_rate = function(population, regions, graph, thr_range = c(0.01, 0.03, 0.05), ...) {
  purrr::map_dfr(thr_range, function(thr) {
    regions$id %>%
      purrr::map(~internal_nodes(graph, as.character(.x), thr) %>% as.integer()) %>%
      combn_ids() %>%
      summarize_capture_rate(population, thr)
  })
}
.tbl_capture = .combn_capture_rate(.population, .regions, .graph) %>% print()
.tbl_capture %>% plot_capture_rate() + facet_wrap(~threshold)

.plot_allelefreq_biopsy = function(population, sample_ancestors, threshold) {
  .df = population %>%
    dplyr::filter(.data$allelefreq >= threshold) %>%
    dplyr::transmute(
      .data$id,
      .data$allelefreq,
      captured = .data$id %in% sample_ancestors
    )
  ggplot(.df, aes(allelefreq, group=captured))+
    geom_histogram(aes(fill=captured), binwidth=0.02)+
    theme_bw()
}
.plot_allelefreq_biopsy(.population, .combn_biopsy$id[[3]], .threshold)


df_capture = df_sampled %>%
  dplyr::mutate(
    capture_tbl = purrr::pmap(., .combn_capture_rate, thr_range = c(0.10))
  ) %>% print()

# saveRDS(df_capture, "df_capture.rds")

df_capture_tidy = df_capture %>%
  dplyr::select(local, path, shape, replicate, capture_tbl) %>%
  tidyr::unnest() %>%
  print()

.p_capture = df_capture_tidy %>%
  plot_capture_rate() +
  facet_grid(local + path ~ shape + replicate) +
  scale_y_continuous(breaks = c(0, 0.5, 1,0)) +
  theme(panel.grid = element_blank())
.p_capture
ggsave("capture_rate-6.png", .p_capture, width=11, height=12)
