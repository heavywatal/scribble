#include <algorithm>
#include <numeric>
#include <vector>
#include <list>

#include <fmt/format.h>
#include <fmt/ranges.h>

inline void copy() {
  fmt::println("## copy");
  std::vector<int> src(6u);
  std::vector<int> dst(8u); // must not be smaller than src
  std::iota(src.begin(), src.end(), 1);
  std::copy(src.begin(), src.end(), dst.begin());
  fmt::println("src: {}", src);
  fmt::println("dst: {}", dst);

  std::vector<int> to_right_vec(src);
  std::vector<int> to_left_vec(src);
  std::list<int> to_right_ls = {1, 2, 3, 4, 5, 6};
  std::list<int> to_left_ls = {1, 2, 3, 4, 5, 6};
  std::copy(to_right_vec.begin(), std::next(to_right_vec.begin() + 4), std::next(to_right_vec.begin(), 2));
  std::copy(to_right_ls.begin(), std::next(to_right_ls.begin(), 4), std::next(to_right_ls.begin(), 2));
  std::copy(std::next(to_left_vec.begin(), 2), to_left_vec.end(), to_left_vec.begin());
  std::copy(std::next(to_left_ls.begin(), 2), to_left_ls.end(), to_left_ls.begin());
  fmt::println("to_right_vec: {} UNDEFINED!", to_right_vec);
  fmt::println("to_right_list: {} UNDEFINED!", to_right_ls);
  fmt::println("to_left_vec: {}", to_left_vec);
  fmt::println("to_left_list: {}", to_left_ls);
}

inline void copy_backword() {
  fmt::println("## copy_backward");
  std::vector<int> src(6u);
  std::vector<int> dst(8u); // must not be smaller than src
  std::iota(src.begin(), src.end(), 1);
  std::copy_backward(src.begin(), src.end(), dst.end());
  fmt::println("src: {}", src);
  fmt::println("dst: {}", dst);

  std::vector<int> to_right_vec(src);
  std::vector<int> to_left_vec(src);
  std::list<int> to_right_ls = {1, 2, 3, 4, 5, 6};
  std::list<int> to_left_ls = {1, 2, 3, 4, 5, 6};
  std::copy_backward(to_right_vec.begin(), std::next(to_right_vec.begin(), 4), to_right_vec.end());
  std::copy_backward(to_right_ls.begin(), std::next(to_right_ls.begin(), 4), to_right_ls.end());
  std::copy_backward(std::next(to_left_vec.begin(), 2), to_left_vec.end(), std::next(to_left_vec.begin(), 4));
  std::copy_backward(std::next(to_left_ls.begin(), 2), to_left_ls.end(), std::next(to_left_ls.begin(), 4));
  fmt::println("to_right_vec: {}", to_right_vec);
  fmt::println("to_right_list: {}", to_right_ls);
  fmt::println("to_left_vec: {} UNDEFINED!", to_left_vec);
  fmt::println("to_left_list: {} UNDEFINED!", to_left_ls);
}

int main() {
  copy();
  copy_backword();
  return 0;
}
