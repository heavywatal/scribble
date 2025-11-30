#include <chrono>
#include <iostream>
#include <iterator>
#include <sstream>

#include <fmt/format.h>
#include <fmt/ranges.h>
#include <fmt/chrono.h>

#include <wtl/iostr.hpp>
#include <wtl/resource.hpp>

inline void floating_point_number() {
  constexpr double rep_dec = 137174210.0/1111111111.0;
  for (const double x: {0.0, rep_dec * 1e-10, rep_dec, rep_dec * 1e10}) {
    fmt::println("{{}}: {}", x);
    fmt::println("{{:e}}: {:e}", x);
    fmt::println("{{:f}}: {:f}", x);
    fmt::println("{{:g}}: {:g}", x);
    fmt::println("{{:.9e}}: {:.9e}", x);
    fmt::println("{{:.9f}}: {:.9f}", x);
    fmt::println("{{:.9g}}: {:.9g}", x);
  }
}

inline void back_inserter() {
  std::string buffer;
  auto buffer_back = std::back_inserter(buffer);
  for (int i=0; i<9; ++i) {
    [[maybe_unused]]
    auto back_unused = fmt::format_to(buffer_back, "{}-", i);
  }
  fmt::println("{}", buffer);
}

inline void memory_buffer() {
  fmt::memory_buffer buffer;
  fmt::format_to(std::back_inserter(buffer), "memory_buffer");
  // fmt::println("{}", buffer); // not supported
  fmt::println("{}", fmt::to_string(buffer)); // string constructor copies data
  fmt::println("{}", std::string_view(buffer.data(), buffer.size()));
}

inline void date_time() {
  auto now_sec = std::chrono::floor<std::chrono::seconds>(std::chrono::system_clock::now());
#if __cplusplus >= 202002L
  // auto now = {std::chrono::current_zone(), now_sec};
#else
  auto now = now_sec;
#endif
  fmt::println("{:%Y%m%d_%H%M%S}", now);
  std::string str_format("{:%FT%T%z}");
  fmt::println(fmt::runtime(str_format), now);
}

inline void benchmark() {
  fmt::println("benchmark");
  constexpr int n = 65535;
  fmt::println("{}\tstd::ostringstream", wtl::delta_rusage([&](){
    std::ostringstream oss;
    for (int i = 0; i < n; ++i) {
      oss << "The answer is " << i << "\n";
    }
  }, 3));
  fmt::println("{}\tfmt::format_to(std::string)", wtl::delta_rusage([&](){
    std::string buffer;
    for (int i = 0; i < n; ++i) {
      fmt::format_to(std::back_inserter(buffer), "The answer is {}\n", i);
    }
  }, 3));
  fmt::println("{}\tfmt::format_to(fmt::memory_buffer)", wtl::delta_rusage([&](){
    fmt::memory_buffer buffer;
    for (int i = 0; i < n; ++i) {
      fmt::format_to(std::back_inserter(buffer), "The answer is {}\n", i);
    }
  }, 3));
}

int main() {
  floating_point_number();
  back_inserter();
  memory_buffer();
  date_time();
  benchmark();
  return 0;
}
