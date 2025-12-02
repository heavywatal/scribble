#include <fmt/base.h>

#include <igraph/igraph.h>

int main() {
  igraph_t graph;
  igraph_integer_t edges[] = {
    0, 1,
    0, 2
  };
  const auto v = igraph_vector_int_view(edges, sizeof(edges) / sizeof(int));
  igraph_create(&graph, &v, 0, true);

  igraph_real_t res;
  igraph_average_path_length(&graph, nullptr, &res, nullptr, true, true);
  fmt::println("average_path_length: {}", res);
  return 0;
}
