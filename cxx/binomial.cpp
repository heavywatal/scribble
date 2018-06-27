// Results are different between libc++ and libstdc++

#include <iostream>
#include <sstream>
#include <fstream>
#include <random>

#if defined _LIBCPP_VERSION
  const char* lib = "libc++";
#elif defined __GLIBCXX__
  const char* lib = "libstdc++";
#else
  const char* lib = "else";
#endif

int main() {
  std::cout << lib << std::endl;
  std::random_device seeder;
  std::mt19937 engine(seeder());
  const int nrep = 1000;
  const int size = 10000;
  std::binomial_distribution<int> dist(1000, 0.01);
  std::ostringstream oss;
  oss << "sum\n";
  for(int j = 0; j < nrep; ++j){
    int sum = 0;
    for (int i = 0; i < size; ++i) {
      sum += dist(engine);
    }
    oss << sum << "\n";
  }
  std::ostringstream outfile;
  outfile << "binomial-" << lib << ".tsv";
  std::ofstream(outfile.str()) << oss.str();
}

// clang++ -std=c++11 -O2 -Wall binomial.cpp -o binomial-libc++ && ./binomial-libc++
// g++-8 -std=c++11 -O2 -Wall binomial.cpp -o binomial-libstdc++ && ./binomial-libstdc++

/* R
library(tidyverse)
df = tibble::tibble(lib = c("libc++", "libstdc++")) %>%
  dplyr::mutate(data = purrr::map(lib, ~{readr::read_tsv(paste0("binomial-", .x, ".tsv"))})) %>%
  tidyr::unnest() %>%
  print()

ggplot(df) +
  geom_histogram(aes(sum), bins = 40L) +
  facet_wrap(~lib, ncol = 1L)

df %>%
  dplyr::group_by(lib) %>%
  dplyr::summarise_all(mean)
*/
