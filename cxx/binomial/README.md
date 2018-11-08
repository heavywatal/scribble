# Bug in libstdc++ `std::binomial_distribution`?

Compile and run:

```sh
clang++ -std=c++11 -O2 -Wall binomial.cpp -o binomial-libc++
g++-8 -std=c++11 -O2 -Wall binomial.cpp -o binomial-libstdc++
./binomial-libc++
./binomial-libstdc++
```

Visualize the output with R:

```r
library(tidyverse)

df = tibble::tibble(lib = c("libc++", "libstdc++")) %>%
  dplyr::mutate(
    filename = paste0("binomial-", lib, ".tsv"),
    data = purrr::map(filename, readr::read_tsv),
    filename = NULL
  ) %>%
  tidyr::unnest()

lib_mean = {. %>% dplyr::group_by(lib) %>% dplyr::summarise_all(mean)}

p = ggplot(df) +
  geom_histogram(aes(sum), bins = 40L) +
  geom_vline(data = lib_mean, aes(xintercept = sum), colour = "tomato") +
  geom_text(data = lib_mean, aes(x = sum, y = 10, label = sum), colour = "tomato") +
  labs(title = "1000 replicates of sum^10000{binom(t=1000, p=0.01)}") +
  facet_grid(lib ~ .)
print(p)
ggsave("dist-sum-binomial.png", p, width = 6, height = 6)
```
