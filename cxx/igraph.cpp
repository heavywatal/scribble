#include <igraph/igraph.h>
#include <iostream>

int main() {
  igraph_t graph;
  igraph_vector_t v;
  igraph_real_t edges[] = {
    0, 1,
    0, 2
  };
  igraph_vector_view(&v, edges, sizeof(edges) / sizeof(double));
  igraph_create(&graph, &v, 0, true);

  igraph_real_t res;
  igraph_average_path_length(&graph, &res, nullptr, true, true);
  std::cout << res << std::endl;
  return 0;
}
