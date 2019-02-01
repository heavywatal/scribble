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
