library(tidyverse)
library(tumopp)
refresh('tumopp/r')

.alt = list(
  k = c('1', '1e6'),
  N = c('256', '512')
)
.const = c('-D2', '-Chex', '-Lconst', '-Pmindrag')

argslist = make_args(.alt, .const, 3L)
print(names(argslist))
(label = paste(c('tumopp', .const, '-alt_', names(.alt)), collapse=''))

results = argslist %>% wtl::map_par_dfr(tumopp, .id='args')
# saveRDS(results, paste0(label, '.rds'))
results$shape
.plt = results %>%
  dplyr::mutate(
    repl = seq_along(population),
    plt = purrr::map(population, ~{
      filter_extant(.x) %>%
      wtl::center_range(x, y) %>%
      plot_lattice2d(alpha=1, size=1.2)+
      scale_colour_grey(start = 0.1, end = 0.7, guide = FALSE)+
      ggplot2::theme_void()
    })
  )
.plt$plt[[1]]

.plt %>% purrr::pmap(function(max, shape, repl, plt, ...) {
  .outfile = sprintf("~/Desktop/tumopp2d_N%d_k%d_%02d.png", max, shape, repl)
  message(.outfile)
  ggsave(.outfile, plt, width=1, height=1, scale=7, dpi=200)
})

.xmax = results$population %>% purrr::map_int(~{max(.x$age)})

.plot_genealogy = function(.tbl, xmax=max(.tbl$ageend)) {
  ggplot2::ggplot(.tbl) +
    ggplot2::geom_segment(
      ggplot2::aes_(~age, ~pos, xend = ~ageend, yend = ~posend, colour = ~clade),
      alpha = 0.7, size = 0.5) +
    ggplot2::geom_point(
      data = dplyr::filter(.tbl, .data$extant),
      ggplot2::aes_(x = ~ageend, y = ~posend, colour = ~clade),
      size = 0.9, alpha = 0.7
    ) +
    ggplot2::coord_cartesian(xlim = c(0, xmax), expand = FALSE)
}

.pltgen = results %>%
  dplyr::mutate(plt = purrr::map(population, ~{
    layout_genealogy(.x) %>%
    .plot_genealogy(xmax=.xmax) +
    scale_colour_grey(start = 0.1, end = 0.7, guide = FALSE, na.value="#333333")+
    theme_void()
  }))
.pltgen$plt[[1L]]
.pltgen %>%
  dplyr::mutate(repl = seq_along(population)) %>%
  purrr::pwalk(function(max, shape, repl, plt, ...) {
    .outfile = sprintf("~/Desktop/genealogy_N%d_k%d_%02d.png", max, shape, repl)
    message(.outfile)
    ggsave(.outfile, plt, width=1, height=1, scale=4, dpi=300)
  })


# #######1#########2#########3#########4#########5#########6#########7#########

.tidy = tidyr::crossing(
    sample = paste0("Sample ", seq_len(3L)),
    lineage = seq_len(4L)
  ) %>%
  dplyr::mutate(value = runif(nrow(.))) %>%
  print()

.p_belt = ggplot(.tidy, aes(sample, value)) +
  geom_col(aes(fill = lineage), position = "fill") +
  scale_fill_gradient(guide = FALSE, low = '#333333', high = '#bbbbbb') +
  coord_flip(expand = FALSE) +
  theme_bw() +
  theme(
    panel.grid = element_blank(),
    panel.border = element_blank(),
    axis.title = element_blank(), axis.ticks = element_blank(),
    axis.text.x = element_blank()
  )
.p_belt
ggsave('~/Desktop/belt.pdf', .p_belt, width = 4, height =2)

# #######1#########2#########3#########4#########5#########6#########7#########

.tidy = tidyr::crossing(
    sample = paste0("Sample ", seq_len(3L)),
    gene = head(LETTERS, 8L)
  ) %>%
  dplyr::mutate(frequency = runif(nrow(.))) %>%
  print()

.p = .tidy %>%
  ggplot(aes(gene, sample)) +
  geom_raster(aes(fill = frequency)) +
  coord_fixed(expand = FALSE) +
  scale_y_discrete(limits = rev(unique(.tidy$sample)))+
  scale_fill_gradient(
    low='#eeeeee', high = '#000000', limits = c(0, 1),
    name = "Frequency of malignant allele",
    guide = guide_colourbar(label = FALSE)
  ) +
  labs(x = "Site") +
  theme_bw(base_size = 14) +
  theme(
    axis.ticks = element_blank(),
    axis.title.y = element_blank(),
    legend.position = "top"
  )
.p
ggsave("sample-allele-freq.png", .p, width = 5, height = 3)



# #######1#########2#########3#########4#########5#########6#########7#########

genes = c('TP53', 'APC', 'TERT', 'RB1')
n = 4L
.table = tibble(
  gene = paste0('sample-', seq_len(n)),
  lineage_1 = runif(n),
  lineage_2 = runif(n),
  lineage_3 = runif(n)
) %>% print()

.tidy = .table %>%
  tidyr::gather(sample, value, -gene) %>%
  dplyr::mutate(sample = str_replace(sample, '_', '-')) %>%
  print()

ggplot(.tidy, aes(sample, gene))+
  geom_tile(aes(fill = value))+
  geom_text(aes(label = sprintf('%.2f', value)))+
  scale_fill_gradient(low="#ffffff", high='#888888', limits=c(0, 1), guide=FALSE)+
  scale_x_discrete(position = 'top')+
  scale_y_discrete(limits = rev(.table$gene))+
  coord_cartesian(expand = FALSE)+
  theme_bw()+
  theme(
    axis.title=element_blank(),
    axis.ticks=element_blank(),
    panel.grid = element_blank()
  )
