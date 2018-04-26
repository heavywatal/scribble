library(tidyverse)
library(tumopp)
refresh('tumopp/r')

.alt = list(
  k = c('1', '1e6'),
  N = c('256', '512')
)
.const = c('-D2', '-Chex', '-Lconst', '-Pmindrag')
.const = c('-D2', '-Chex', '-Lstep', '-Pmindrag')

argslist = make_args(.alt, .const, 3L)
print(names(argslist))
(label = paste(c('tumopp', .const, '-alt_', names(.alt)), collapse=''))

results = argslist %>% wtl::map_par_dfr(tumopp, .id='args')

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

.xmax = results$population %>% purrr::map_int(~{max(.x$age)})
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
    .outfile = sprintf("genealogy_N%d_k%d_%02d.png", max, shape, repl)
    message(.outfile)
    ggsave(.outfile, plt, width=1, height=1, scale=4, dpi=300)
  })

# #######1#########2#########3#########4#########5#########6#########7#########
if (FALSE) {

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
  .outfile = sprintf("tumopp2d_N%d_k%d_%02d.png", max, shape, repl)
  message(.outfile)
  ggsave(.outfile, plt, width=1, height=1, scale=7, dpi=200)
})

}
# #######1#########2#########3#########4#########5#########6#########7#########

genes = c('TP53', 'CTNNB1', 'ARID1A', 'AXIN1', 'ARID2', 'KMT2D', 'BAP1', 'FAT4', 'RB1', 'PIK3CA', 'KMT2C')

.trbl = tibble::tribble(
  ~'サンプル 1', ~'サンプル 2', ~'サンプル 3',
  1, 1, 1,
  1, 1, 1,
  1, 1, 1,
  1, 1, 0,
  1, 1, 0,
  1, 0, 0,
  0, 0, 1,
  0, 0, 1
) %>%
  dplyr::mutate(gene = head(genes, nrow(.))) %>%
  print()

.tidy = .trbl %>%
  tidyr::gather(sample, frequency, -gene) %>%
  dplyr::mutate(frequency = ifelse(frequency > 0,
    runif(length(frequency), 0.5, 0.9),
    runif(length(frequency), 0, 0.3))
  ) %>%
  dplyr::mutate(frequency = ifelse(gene %in% head(genes, 3L), 1, frequency)) %>%
  print()

.p = .tidy %>%
  ggplot(aes(gene, sample)) +
  geom_tile(aes(fill = frequency), width = 0.94, height = 0.94) +
  coord_fixed(expand = FALSE) +
  scale_x_discrete(limits = .trbl$gene) +
  scale_y_discrete(limits = rev(unique(.tidy$sample)))+
  scale_fill_gradient(guide = FALSE,
    low='#eeeeee', high = '#000000', limits = c(0, 1)) +
  labs(title = "変異型頻度") +
  theme_bw(base_size = 14, base_family = "HiraKakuProN-W3") +
  theme(
    axis.ticks = element_blank(), axis.title = element_blank(),
    axis.text.x = element_text(angle = -90, hjust=0, colour='black'),
    axis.text.y = element_text(colour='black'),
    panel.border = element_blank(), panel.grid = element_blank()
  )
.p

ggsave("sample-allele-freq.png", .p, width = 4, height = 2.5)
