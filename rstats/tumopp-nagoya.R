library(tidyverse)
library(tumopp)

.dirs = fs::dir_ls(glob='L*', type='directory')
.confs = tumopp::read_confs(.dirs)
.base = .confs %>%
  dplyr::select(-seed, -outdir) %>%
  dplyr::select_if(~ n_distinct(.x) > 1L) %>%
  print()

.mean_fst = function(population, graph, ...) {
  extant = tumopp::filter_extant(population)
  if (nrow(extant) < 50000L) return(NA_real_)
  nsam = sample(c(5L, 6L, 6L), 1L)
  ncell = 100L
  regions = extant %>%
    tumopp::sample_uniform_regions(nsam = nsam, ncell = ncell)
  sampled = purrr::flatten_int(regions$id)
  subgraph = tumopp::subtree(graph, sampled)
  .tbl = within_between_samples(subgraph, regions)
  mean(.tbl$fst)
}

df_fst = .base %>%
  # head(4L) %>%
  dplyr::mutate(fst = parallel::mclapply(directory, function(indir) {
    message(indir)
    population = file.path(indir, "population.tsv.gz") %>% tumopp:::read_tumopp()
    .mean_fst(population, tumopp::make_igraph(population))
  }) %>% purrr::flatten_dbl()) %>%
  print()
# df_fst
readr::write_tsv(df_fst, "summary-fst.tsv.gz")

# #######1#########2#########3#########4#########5#########6#########7#########
if (FALSE) {

df_fst = readr::read_tsv("summary-fst.tsv.gz")
.mean = 0.2383436
.tolerence = 0.3
.lbound = .mean * (1 - .tolerence)
.ubound = .mean * (1 + .tolerence)
.p_rejection = df_fst %>%
  dplyr::mutate(fst = ifelse(fst < .lbound, "low", ifelse(.ubound < fst, "high", "accepted"))) %>%
  tidyr::gather(parameter, value, -directory, -fst, -local, -path) %>%
  ggplot(aes(value))+
  geom_histogram(aes(fill = fst), bins=24) +
  facet_grid(local + path ~ parameter, scale = "free") +
  scale_fill_brewer(palette = "Spectral", na.value = "#999999")
.p_rejection
ggsave("abc.png", .p_rejection, width=8, height = 8)

# #######1#########2#########3#########4

wtl::refresh('rtumopp')

.files = fs::dir_ls(recursive=TRUE, glob='*population.tsv.gz', type='file')
.file_info = fs::file_info(.files)
.info = .file_info %>% dplyr::transmute(directory = dirname(path), size)

.size_df = .confs %>%
  dplyr::select_if(~ n_distinct(.x) > 1L) %>%
  dplyr::select(-seed, -outdir) %>%
  dplyr::inner_join(.info, by = "directory") %>%
  print()

.p_filesize = .size_df %>%
  ggplot(aes(delta0, size, colour = symmetric)) +
  geom_point(alpha = 0.5) +
  facet_grid(local ~ path) +
  coord_cartesian(ylim = c(0, 1e8)) +
  scale_colour_viridis_c()
.p_filesize
ggsave("filesize.png", .p_filesize, width = 6, height = 6)

.df = .size_df %>% dplyr::mutate(extinction = size < 4096)

.fit = glm(data = .df, extinction ~ delta0 + rho0 + symmetric * prolif + local + path)
summary(.fit)

# #######1#########2#########3#########4

.results = tumopp::read_results(.dirs[1:10])
population = .results$population[[1L]]
graph = .results$graph[[1L]]
.nodes = regions$id %>% purrr::flatten_int()

easierprof(
purrr::map2_dbl(.results$population, .results$graph, .mean_fst))
)

} # if (FALSE)
