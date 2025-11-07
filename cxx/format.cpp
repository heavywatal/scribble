#include <iostream>
#include <iterator>
#include <sstream>

#include <fmt/format.h>

#include <wtl/resource.hpp>

inline void floating_point_number() {
  constexpr double rep_dec = 137174210.0/1111111111.0;
  for (const double x: {0.0, rep_dec * 1e-10, rep_dec, rep_dec * 1e10}) {
    fmt::println("{{}}: {}", x);
    fmt::println("{{:.e}}: {:.e}", x);
    fmt::println("{{:.f}}: {:.f}", x);
    fmt::println("{{:.g}}: {:.g}", x);
    fmt::println("{{:.9e}}: {:.9e}", x);
    fmt::println("{{:.9f}}: {:.9f}", x);
    fmt::println("{{:.9g}}: {:.9g}", x);
  }
}

inline void benchmark() {
  int n = 65535;
  std::cout << wtl::diff_rusage([&](){
    std::ostringstream oss;
    for (int i=0; i<n; ++i) {
      oss << "The answer is " << i << "\n";
    }
    std::cout << oss.str().size() << std::endl;
  }, 3u) << "\t""std::ostringstream""\t" << std::endl;
  std::cout << wtl::diff_rusage([&](){
    std::string buffer;
    for (int i=0; i<n; ++i) {
      fmt::format_to(std::back_inserter(buffer), "The answer is {}\n", i);
    }
    std::cout << buffer.size() << std::endl;
  }, 3u) << "\t""fmt::format_to(std::string)""\t" << std::endl;
  std::cout << wtl::diff_rusage([&](){
    fmt::memory_buffer buffer;
    for (int i=0; i<n; ++i) {
      fmt::format_to(std::back_inserter(buffer), "The answer is {}\n", i);
    }
    std::cout << buffer.size() << std::endl;
  }, 3u) << "\t""fmt::format_to(fmt::memory_buffer)""\t" << std::endl;
}

int main() {
  floating_point_number();
  benchmark();
  return 0;
}
