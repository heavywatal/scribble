#include <iostream>
#include <utility>
#include <boost/graph/graph_traits.hpp>
#include <boost/graph/graph_utility.hpp>
#include <boost/graph/adjacency_list.hpp>
#include <boost/graph/breadth_first_search.hpp>

class Graph {
  public:
    using AdjacencyList = boost::adjacency_list<
      boost::vecS,        // OutEdgeListS
      boost::vecS,        // VertexListS
      boost::directedS,   // DirectedS
      boost::no_property, // VertexProperty
      boost::no_property, // EdgeProperty
      boost::no_property, // GraphProperty
      boost::vecS>;       // EdgeListS
    using Vertex = boost::graph_traits<AdjacencyList>::vertex_descriptor;
    using Edge = std::pair<int, int>;

    template <class EdgeIterator>
    Graph(EdgeIterator begin, EdgeIterator end, int vcount = 0)
    : adjlist_(begin, end, vcount) {}

    const AdjacencyList& data() {return adjlist_;}
  private:
    AdjacencyList adjlist_;
};

int main() {
  std::vector<Graph::Edge> edges{
    Graph::Edge(0, 1),
    Graph::Edge(0, 2),
    Graph::Edge(1, 3),
    Graph::Edge(1, 4),
    Graph::Edge(2, 5),
    Graph::Edge(2, 6)
  };
  Graph g(edges.begin(), edges.end());
  boost::print_graph(g.data(), std::cout);

  Graph::Vertex from(0);
  Graph::Vertex to(6);
  const auto vcount = boost::num_vertices(g.data());
  std::vector<int> distances(vcount);
  std::vector<Graph::Vertex> predecessors(vcount);

  boost::breadth_first_search(g.data(), from,
    boost::visitor(boost::make_bfs_visitor(std::make_pair(
      boost::record_distances(distances.data(), boost::on_tree_edge()),
      boost::record_predecessors(predecessors.data(), boost::on_tree_edge())
    )))
  );
  std::cout << "distances:\n";
  for (const auto x: distances) {
    std::cout << x << "\n";
  }
  std::cout << "predecessors:\n";
  for (const auto x: predecessors) {
    std::cout << x << "\n";
  }

  std::deque<Graph::Vertex> route;
  for (auto v = to; v != from; v = predecessors[v]) {
    route.push_front(v);
  }
  route.push_front(from);

  std::cout << "shortest path:\n";
  for (const auto v: route) {
      std::cout << v << " ";
  }
  std::cout << "\n";

  return 0;
}
