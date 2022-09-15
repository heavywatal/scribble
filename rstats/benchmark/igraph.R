N = 40000L

outdegree_zero_v = function(graph) {
  vs = igraph::V(graph)
  deg = igraph::degree(graph, vs, mode = "out", loops = FALSE)
  vs[deg == 0L]
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

graph = igraph::make_tree(N)
glite = igraphlite::graph_tree(N)

bench::mark(
  outdegree_zero_v(graph),
  outdegree_zero_s(graph),
  not_in_parents(graph),
  glite$sink,
  check = FALSE
)
