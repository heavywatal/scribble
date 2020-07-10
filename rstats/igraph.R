N = 40000L
phy = ape::rtree(N)
el = phy$edge
class(el) = "character"
graph = igraph::graph_from_edgelist(el)

graph = igraph::make_tree(N)

outdegree_zero_v = function(graph) {
  vs = igraph::V(graph)
  deg = igraph::degree(graph, vs, mode = "out", loops = FALSE)
  tumopp:::as_ids(vs)[deg == 0L]
}

outdegree_zero_s = function(graph) {
  vs = seq_len(igraph::gorder(graph))
  deg = igraph::degree(graph, vs, mode = "out", loops = FALSE)
  vs[deg == 0L]
}

not_in_parents = function(graph) {
  el = igraph::as_edgelist(graph, names = TRUE)
  as.integer(el[!el[, 2L] %in% el[, 1L], 2L])
}

bench::mark(
  outdegree_zero_v(graph),
  outdegree_zero_s(graph),
  not_in_parents(graph),
  check = FALSE
)

# #######1#########2#########3#########4#########5#########6#########7#########

igraph::vertex_attr

gattr = function(graph) {
  mybracket2 = utils::getFromNamespace("C_R_igraph_mybracket2", "igraph")
  .Call(mybracket2, graph, 9L, 3L)
}
gattr(graph)$name

degree(g, NA)

load_all()

g = igraph_tree(9)

bench::mark(
  g$neighbors(3, 3L),
  trneighbors(g, 3),
  rneighbors(g, 3),
  neighbors(g, 3, 3L),
  call = .Call(`_igraphlite_neighbors`, g, 3, 3L),
  check = FALSE
)

bench::mark(
  cdegree(g),
  degree(g),
  check = FALSE
)

bench::mark(
  tibble = redirect(tibble:::print.tbl(diamonds)),
  data.table = redirect(data.table:::print.data.table(diamonds)),
  wtl = redirect(wtl::printdf(diamonds)),
  check = FALSE
)[1:10]


d <- tibble(id = 1:2, x = tibble(a = c("a", "b"), b = 1:2, c = Sys.Date() + b))

d
tibble:::print.tbl(d)

tidyr:::append_df(d, d$x, after = "x", remove = TRUE)

d[,map_lgl(d, is.data.frame)]


d2 <- tibble(id = 1:2,
            dx = tibble(a = c("a", "b"), b = 1:2, c = Sys.Date() + b),
            dy = tibble(a = c("c", "d"), b = 3:4, c = Sys.Date() + b))

tidyr:::append_df

bench::mark(
  g$to(),
  g$sfto(),
  .Call(`_igraphlite_fto`, g),
  fto(g)
)

bench::mark(
  g$to(),
  g$sfto(),
  .Call(`_igraphlite_fto`, g),
  fto(g)
)

tibble:::print.tbl

d <- tibble(
  id = 1:2,
  x = tibble(a = c("a", "b"), b = 1:2, c = Sys.Date() + b),
  y = tibble(a = c("c", "d"), b = 3:4, c = Sys.Date() + b)
)
gather(d, k, v, x:y)
gather(iris, k, v)

print.data.table

library(igraph)

igraph::shortest_paths(graph, "1", nodes, mode = "out", weight = NA, output = "vpath")$vpath

igraph::all_simple_paths(graph, "1", nodes, mode = "out")

igraph::ego(graph, order = 1073741824L, nodes = nodes, mode = "in")


# single path to the root
igraph::subcomponent(graph, v, mode = "in")

# v must contain internal nodes too
igraph::subgraph(graph, v)

igraph::make_ego(graph, order, nodes, mode = "in")

# character node id を character で渡すと igraph:::as.igraph.vs() の中で重い処理が走る

# #######1#########2#########3#########4#########5#########6#########7#########
# TEK

.igraph %>% igraph::write_graph("phylo23.gml", format="gml")
.phylo
.igraph = ape::unroot(.phylo) %>% wtl::phylo2igraph()
# .igraph = wtl::phylo2igraph(.phylo) %>% print()
.w = (igraph::edge_attr(.igraph, "length") + 1e-3) ** 0.5
.w = 1 / .w
set.seed(24601L)
wtl::igraph_layout(.igraph, igraph::with_fr(weights=.w)) %>%
  dplyr::left_join(.node_df, by = c(to = 'label')) %>%
  ggplot()+geom_segment(aes(x, y, xend=xend, yend=yend))+geom_point(aes(xend, yend, size=copy_number), alpha=0.3)

?network::as.network.matrix
.el = cbind(.phylo$edge, .phylo$edge.length)
.netw = network::as.network.matrix(.el, matrix.type="edgelist", ignore.eval=FALSE, names.eval="length")
.netw
plot(.netw)

library(GGally)
.phylo = .all_inds_df$phylo[[11]]
str(.phylo)
phylo2igraph = function(.phylo) {
  igraph::graph_from_edgelist(.phylo$edge) %>%
    igraph::set_edge_attr("weight", value=.phylo$edge.length)
}
.igraph = phylo2igraph(.phylo)
.igraph = .phylo %>% ape::as.igraph.phylo()

.phylo$edge %>% make
ape::as.network.phylo(.phylo)
network::as.network
.phylo$edge %>% as.data.frame() %>% setNames(c('from', 'to')) %>%
  dplyr::mutate(weight=.phylo$edge.length) %>% network::network(matrix.type="edgelist")
.edgelist = cbind(.phylo$edge, weight=.phylo$edge.length)
dim(.edgelist)
.edgelist[,-(1:2),drop=FALSE]
 %>% network::network.edgelist()
.netw = network::network(.phylo$edge, matrix.type="edgelist")
str(.netw)
plot(.netw)


