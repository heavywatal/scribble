wtl::refresh('rtumopp')

.alt = list(
  d = c('0.0', '0.1', '0.2'),
  m = c('0.0', '1.0', '2.0')
)
.const = c('-D2', '-Chex', '-N40000', '-k100', '-Llinear', '-Prandom')

argslist = make_args(alt = .alt, const = .const, nreps = 3L)
print(names(argslist))
(label = paste(c('tumopp', .const, '-alt_', names(.alt)), collapse=''))

raw_results = argslist %>% purrr::map_dfr(tumopp, .id='args')

# results = raw_results %>%
results = fixed_results %>%
  dplyr::select_if(~ n_distinct(.x) > 1L) %>%
  dplyr::select(-outdir, -seed, -drivers) %>%
  dplyr::group_by(delta0, rho0) %>%
  dplyr::mutate(replicate = dplyr::row_number()) %>%
  dplyr::ungroup() %>%
  dplyr::mutate(
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

df_extant = df_sampled %>%
  dplyr::transmute(
    delta0, rho0, replicate,
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
  facet_grid(delta0 ~ rho0 + replicate) +
  wtl::erase(axis.title, axis.text, axis.ticks) +
  theme(panel.spacing = unit(0, 'mm'))
.p_sampled
ggsave('samples.png', .p_sampled, width = 12, height = 4)

df_sampled$population[[.i]]

df_sampled$extant[[.i]]
df_sampled$regions[[.i]]$id %>% purrr::map(unique)

.i = 3L
within_between_samples(df_sampled$subgraph[[.i]], df_sampled$regions[[.i]])

df_distance = df_sampled %>%
  dplyr::mutate(distance = purrr::map2(subgraph, regions, within_between_samples)) %>%
  print()

.p_fst = df_distance %>%
  dplyr::select(delta0, rho0, replicate, distance) %>%
  tidyr::unnest() %>%
  ggplot(aes(euclidean, fst)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = lm, formula = y ~ 0 + x, se = FALSE, colour = "#000000", alpha = 0.5) +
  facet_grid(delta0 ~ rho0 + replicate) +
  coord_cartesian(ylim = c(0, 1))
.p_fst
ggsave('fst.png', .p_fst, width = 8, height = 6)


df_vaf = df_sampled %>%
  dplyr::mutate(tidy_vaf = purrr::map2(subgraph, regions, ~make_vaf(.x, .y$id, mu = -1))) %>%
  print()

.p_vaf = df_vaf %>%
  dplyr::select(delta0, rho0, replicate, tidy_vaf) %>%
  tidyr::unnest() %>%
  ggplot(aes(sample, site)) +
  geom_tile(aes(fill = frequency)) +
  scale_fill_distiller(palette = "Spectral", limit = c(0, 1), guide = FALSE) +
  coord_cartesian(expand = FALSE) +
  facet_grid(delta0 ~ rho0 + replicate, scales = "free_y")
.p_vaf
ggsave('vaf.png', .p_vaf, width = 10, height = 10)


# #######1#########2#########3#########4#########5#########6#########7#########

df_eval = results %>%
  dplyr::mutate(capture = purrr::map(population, .cross_evaluate_mrs)) %>%
  print()

# saveRDS(df_eval, "~/Desktop/df_eval-tsunagi.rds")

.p_eval = df_eval %>%
  dplyr::select(delta0, rho0, replicate, capture) %>%
  tidyr::unnest() %>%
  tidyr::nest(-threshold, -ncell) %>%
  dplyr::mutate(plt = purrr::map(data, ~{
    plot_capture_rate(.x) +
    facet_grid(delta0 ~ rho0 + replicate)
  })) %>%
  print()

.p_eval$plt[[1L]]

.p_eval %>% purrr::pmap(function(threshold, ncell, plt, ...) {
  .outfile = sprintf("capture-rate-%d-%.2f.png", ncell, threshold)
  ggsave(.outfile, plt, width=8, height=6)
  .outfile
})
