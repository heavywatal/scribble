library(conflicted)
library(tidyverse)

# convert to 1-row tibble
vec = c(answer = 42L, whoami = 24601L)
dplyr::bind_rows(vec)
tibble::as_tibble(t(vec))

# #######1#########2#########3#########4#########5#########6#########7#########

bench::mark(
  pillar = wtl::redirect(pillar:::print.tbl(ggplot2::diamonds)),
  data.table = wtl::redirect(data.table:::print.data.table(ggplot2::diamonds)),
  wtl = wtl::redirect(wtl:::printdf(ggplot2::diamonds))
)

# #######1#########2#########3#########4#########5#########6#########7#########

df = ggplot2::diamonds |> dplyr::select(where(is.numeric))

forloop = function(.x, .f) {
  y = numeric(nrow(.x))
  for (col in .x) {
    y = .f(y, col)
  }
  y
}

bench::mark(
  Reduce = Reduce(`+`, df),
  reduce = purrr::reduce(df, `+`),
  rowSums = rowSums(df),
  apply = apply(df, 1, sum),
  "for" = forloop(df, `+`)
)

# too slow
df |>
  head(2000L) |>
  dplyr::rowwise() |>
  dplyr::mutate(x = sum(dplyr::c_across(everything())))
