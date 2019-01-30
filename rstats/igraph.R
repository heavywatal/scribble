N = 40000L
phy = ape::rtree(N)
el = phy$edge
class(el) = "character"
graph = igraph::graph_from_edgelist(el)

graph = igraph::make_tree(N)

outdegree_zero = function(graph) {
  vs = igraph::V(graph)
  deg = igraph::degree(graph, vs, mode = "out", loops = FALSE)
  tumopp:::as_ids(vs)[deg == 0L]
}

not_in_parents = function(graph) {
  el = igraph::as_edgelist(graph, names = TRUE)
  as.integer(el[!el[, 2L] %in% el[, 1L], 2L])
}

bench::mark(
  outdegree_zero(graph),
  not_in_parents(graph)
)
