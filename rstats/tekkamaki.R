library(tidyverse)
library(wtl)

make_nodes = function(max_time, pop_size, .mean=1.5, .sd=1.0) {
    .sizes = pmax(rnorm(max_time, .mean, .sd), 0.5) * pop_size
    purrr::map_df(seq_len(max_time), ~{
        tibble(g=.x, x=seq_len(.sizes[.x])) %>%
        dplyr::mutate(t= runif(n(), g - 0.3, g + 0.3))
    }) %>%
    dplyr::mutate(node=seq_len(nrow(.)))
}

make_edges = function(.data, generation=1L, .sort=FALSE) {
    .children = .data %>% dplyr::filter(g == generation)
    .parents = .data %>%
        dplyr::filter(generation + 3L <= g, g <= generation + 8L) %>%
        dplyr::transmute(xend=x, tend=t, parent=node)
    .idx = sample(seq_len(nrow(.parents)), nrow(.children), replace=TRUE)
    if (.sort) {.idx = sort(.idx)}
    bind_cols(.children, .parents[.idx,])
}

.traceback = function(sample_ids) {
    .output = NULL
    while (length(sample_ids) > 0) {
        .output = c(.output, list(sample_ids))
        sample_ids = .edges %>%
            dplyr::filter(node %in% sample_ids) %>%
            {.$parent}
        print(sample_ids)
    }
    .output
}

cumcat = function(.lst) {
    .output = NULL
    newx = NULL
    for (x in .lst) {
        newx = c(newx, x)
        .output = c(.output, list(newx))
    }
    .output
}
cumcat(.trace)

max_time = 24L
pop_size = 100L
sample_size = 60L
.ylim = c(0.8, max_time - 3.1)

.nodes = make_nodes(max_time, pop_size) %>% print()
.edges = purrr::map_df(seq_len(max_time - 3L), ~make_edges(.nodes, .x)) %>% print()
.xlim = range(.nodes$x)
.p_gray = ggplot_gray()
.p_gray

.samples = .nodes %>%
  dplyr::filter(t < 13) %>%
  dplyr::sample_n(sample_size, weight=exp(-0.4 * t)) %>%
  print()
.trace = .traceback(.samples$node)
.family = .trace %>% purrr::flatten_int() %>% unique()
.tree = .edges %>% dplyr::filter(node %in% .family)
.tree_nodes = .nodes %>% dplyr::filter(node %in% .family)
ggplot_sample(.trace[[1]])

if (FALSE) {
    write_tsv(.nodes, 'nodes.tsv')
    write_tsv(.edges, 'edges.tsv')
    write_tsv(.samples, 'samples.tsv')
    .nodes = read_tsv('nodes.tsv')
    .edges = read_tsv('edges.tsv')
    .samples = read_tsv('samples.tsv')
}

# #######1#########2#########3#########4#########5#########6#########7#########

.width = 7
.height = .width
.dpi = 150
.palette = c(
  `1`='dodgerblue', `2`='dodgerblue',
  `3`='forestgreen', `4`='forestgreen', `5`='forestgreen', `6`='forestgreen',
  `7`= 'gold', `8`= 'gold', `9`= 'gold', `10`= 'gold',
  `11`='tomato', `12`='tomato')

ggplot_gray = function(.time=1L, nodes=.nodes, edges=.edges) {
    nodes %>%
    dplyr::filter(g >= .time) %>%
    ggplot(aes(x, t))+
    geom_point(colour='#888888', size=2, alpha=0.5)+
    geom_segment(data=dplyr::filter(edges, t > .time),
      aes(x, t, xend=xend, yend=tend), colour='#888888', alpha=0.5)+
    coord_cartesian(xlim=.xlim, ylim=.ylim)+
    theme_void()+theme(legend.position='none')
}
ggplot_gray()

.time_points = seq(max_time - 3L, 1L, length.out=max_time - 3L)
purrr::walk(seq_along(.time_points), ~{
    outfile = sprintf('forward-%02d.png', .x)
    message(outfile)
    .p = ggplot_gray(.time_points[.x])
    ggsave(outfile, .p, width=.width, height=.height, dpi=.dpi)
})
system('convert -layers optimize -delay 42 -loop 1 forward-*.png forward.gif')

cumcat(.trace)

ggplot_sample = function(.ids=.family) {
    .p_gray+
    geom_point(data=.samples, aes(colour=as.character(g)), size=4)+
    scale_colour_manual(values=.palette)+
    geom_point(data=dplyr::filter(.tree_nodes, node %in% .ids), colour='#333333', size=2)+
    geom_segment(data=dplyr::filter(.tree, parent %in% .ids),
      aes(x, t, xend=xend, yend=tend), colour='#333333', size=1.0, alpha=0.7)
}
ggplot_sample()

.cumcat = cumcat(.trace)
purrr::walk(seq_along(.trace), ~{
    outfile = sprintf('sample-%02d.png', .x)
    message(outfile)
    .p = ggplot_sample(.cumcat[[.x]])
    ggsave(outfile, .p, width=.width, height=.height, dpi=.dpi)
})
system('convert -layers optimize -delay 84 -loop 1 sample-*.png sample.gif')

system('convert -layers optimize -delay 42 -loop 1 forward-*.png sample-*.png simulation.gif')


# #######1#########2#########3#########4#########5#########6#########7#########

.nodes = make_nodes(max_time, pop_size) %>% print()
.edges = purrr::map_df(seq_len(max_time - 3L), ~make_edges(.nodes, .x, .sort=TRUE)) %>% print()
.xlim = range(.nodes$x)
.p_gray = ggplot_gray()
.p_gray

.samples = .nodes %>%
    dplyr::filter(t < 13) %>%
    dplyr::sample_n(sample_size, weight=exp(-0.4 * t)) %>% print()
.trace = .traceback(.samples$node)
.family = .trace %>% purrr::flatten_int() %>% unique()
.tree = .edges %>% dplyr::filter(node %in% .family)
.tree_nodes = .nodes %>% dplyr::filter(node %in% .family)
ggplot_sample(.trace[[1]])

ggplot_backward = function(.ids=.family) {
    ggplot(.samples, aes(x, t))+
    geom_segment(data=dplyr::filter(.tree, parent %in% .ids),
      aes(x, t, xend=xend, yend=tend), colour='#333333', size=1.0, alpha=0.7)+
    geom_point(aes(colour=as.character(g)), size=4)+
    scale_colour_manual(values=.palette)+
    geom_point(data=dplyr::filter(.tree_nodes, node %in% .ids), colour='#333333', size=2)+
    coord_cartesian(xlim=.xlim, ylim=.ylim)+
    theme_void()+theme(legend.position='none')
}
ggplot_backward()

.cumcat = cumcat(.trace)
purrr::walk(seq_along(.trace), ~{
    outfile = sprintf('backward-%02d.png', .x)
    message(outfile)
    .p = ggplot_backward(.cumcat[[.x]])
    ggsave(outfile, .p, width=.width, height=.height, dpi=.dpi)
})
ggsave('backward-estimate.png', ggplot_sample(), width=.width, height=.height, dpi=.dpi)
system('convert -layers optimize -delay 84 -loop 1 backward-*.png backward.gif')
