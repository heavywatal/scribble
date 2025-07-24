#include <igraph/igraph.h>
#include <iostream>

int main() {
  igraph_t graph;
  igraph_vector_int_t v{};
  igraph_integer_t edges[] = {
    0, 1,
    0, 2
  };
  igraph_vector_int_view(&v, edges, sizeof(edges) / sizeof(int));
  igraph_create(&graph, &v, 0, true);

  igraph_real_t res;
  igraph_average_path_length(&graph, &res, nullptr, true, true);
  std::cout << res << std::endl;
  return 0;
}
