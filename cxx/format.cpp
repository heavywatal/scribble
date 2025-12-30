#include <chrono>
#include <fstream>
#include <iostream>
#include <iterator>
#include <sstream>

#include <fmt/format.h>
#include <fmt/ranges.h>
#include <fmt/chrono.h>
#include <fmt/ostream.h>

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

FMT_BEGIN_NAMESPACE

namespace detail {

template <typename Char>
auto operator<<(std::basic_ostream<Char>& os, buffer<Char>& buf)
    -> std::basic_ostream<Char>& {
  write_buffer(os, buf);
  return os;
}

template <typename Char>
auto operator<<(std::basic_ostream<Char>&& os, buffer<Char>& buf)
    -> std::basic_ostream<Char>&& {
  return std::move(os << buf);
}

} // namespace detail

FMT_END_NAMESPACE


inline std::string string_buffer(const int n) {
  std::string buffer;
  auto out = std::back_inserter(buffer);
  for (int i = 0; i < n; ++i) {
    fmt::format_to(out, "The answer is {}\n", i);
  }
  return buffer;
}

inline std::string mem_buffer_to_string(const int n) {
  fmt::memory_buffer buffer;
  auto out = std::back_inserter(buffer);
  for (int i = 0; i < n; ++i) {
    fmt::format_to(out, "The answer is {}\n", i);
  }
  return fmt::to_string(buffer);
}


std::string_view view(const fmt::memory_buffer& buf) {
  return {buf.data(), buf.size()};
}

inline void benchmark() {
  fmt::println("benchmark");
  constexpr int n = 65535 * 4;
  fmt::println("{}\tstd::ostringstream", wtl::delta_rusage([&](){
    std::ostringstream oss;
    for (int i = 0; i < n; ++i) {
      oss << "The answer is " << i << "\n";
    }
  }, 3));
  fmt::println("{}\tfmt::format_to(std::string)", wtl::delta_rusage([&](){
    std::string buffer;
    auto out = std::back_inserter(buffer);
    for (int i = 0; i < n; ++i) {
      fmt::format_to(out, "The answer is {}\n", i);
    }
  }, 3));
  fmt::println("{}\tfmt::format_to(fmt::memory_buffer)", wtl::delta_rusage([&](){
    fmt::memory_buffer buffer;
    auto out = std::back_inserter(buffer);
    for (int i = 0; i < n; ++i) {
      fmt::format_to(out, "The answer is {}\n", i);
    }
  }, 3));

  size_t trash = 0;
  fmt::println("{}\tstring_buffer", wtl::delta_rusage([&](){
    trash += string_buffer(n).size();
  }, 3));
  fmt::println("{}\tmem_buffer_to_string", wtl::delta_rusage([&](){
    trash += mem_buffer_to_string(n).size();
  }, 3));
  fmt::println("trash: {}", trash);

  fmt::println("{}\tfmt::format_to(\t\t\t\t)", wtl::delta_rusage([&](){
    fmt::memory_buffer buffer;
    auto out = std::back_inserter(buffer);
    for (int i = 0; i < n; ++i) {
      double d = i * 1.0;
      const int* pi = &i;
      const double* pd = &d;
      fmt::format_to(out, "{}\t{}\t{}\t{}\n", i, d, fmt::ptr(pi), fmt::ptr(pd));
    }
  }, 3));
  fmt::println("{}\tfmt::format_to(fmt::join(t, \t))", wtl::delta_rusage([&](){
    fmt::memory_buffer buffer;
    auto out = std::back_inserter(buffer);
    for (int i = 0; i < n; ++i) {
      double d = i * 1.0;
      const int* pi = &i;
      const double* pd = &d;
      fmt::format_to(out, "{}\n", fmt::join(std::make_tuple(i, d, fmt::ptr(pi), fmt::ptr(pd)), "\t"));
    }
  }, 3));
}

inline void benchmark_ofstream() {
  fmt::println("benchmark_ofstream");
  constexpr int n = 65535 * 4;
  fmt::println("{}\tprint(ofs)", wtl::delta_rusage([&](){
    std::ofstream ofs("/tmp/ofstream.txt");
    for (int i = 0; i < n; ++i) {
      fmt::print(ofs, "The answer is {}\n", i);
    }
  }, 3));
  fmt::println("{}\tofstream << buffer", wtl::delta_rusage([&](){
    fmt::memory_buffer buffer;
    auto out = std::back_inserter(buffer);
    for (int i = 0; i < n; ++i) {
      fmt::format_to(out, "The answer is {}\n", i);
    }
    std::ofstream("/tmp/ofstream.txt") << buffer;
  }, 3));
  fmt::println("{}\tofstream << fmt::to_string(buffer)", wtl::delta_rusage([&](){
    fmt::memory_buffer buffer;
    auto out = std::back_inserter(buffer);
    for (int i = 0; i < n; ++i) {
      fmt::format_to(out, "The answer is {}\n", i);
    }
    std::ofstream("/tmp/ofstream.txt") << fmt::to_string(buffer);
  }, 3));
  fmt::println("{}\tofstream << view(buffer)", wtl::delta_rusage([&](){
    fmt::memory_buffer buffer;
    auto out = std::back_inserter(buffer);
    for (int i = 0; i < n; ++i) {
      fmt::format_to(out, "The answer is {}\n", i);
    }
    std::ofstream("/tmp/ofstream.txt") << std::string_view(buffer.data(), buffer.size());
  }, 3));
  fmt::println("{}\tfmt::detail::write_buffer(ofs, buffer)", wtl::delta_rusage([&](){
    fmt::memory_buffer buffer;
    auto out = std::back_inserter(buffer);
    for (int i = 0; i < n; ++i) {
      fmt::format_to(out, "The answer is {}\n", i);
    }
    std::ofstream ofs("/tmp/ofstream.txt");
    fmt::detail::write_buffer(ofs, buffer);
  }, 3));
}

int main() {
  floating_point_number();
  back_inserter();
  memory_buffer();
  date_time();
  benchmark();
  benchmark_ofstream();
  return 0;
}
