library(conflicted) # nolint: unused_import_linter.
library(tidyverse)

# convert to 1-row tibble
vec = c(answer = 42L, whoami = 24601L)
dplyr::bind_rows(vec)
tibble::as_tibble(t(vec))

# #######1#########2#########3#########4#########5#########6#########7#########

any_equal_names = function(x, name) any(name == names(x))
x = diamonds
name = "price"

bench::mark(
  rlang::has_name(x, name),
  utils::hasName(x, name),
  name %in% names(x),
  match(name, names(x), nomatch = 0L) > 0L,
  !is.na(match(name, names(x))),
  any(name == names(x)),
  any_equal_names(x, name),
  !is.null(x[[name]])
)

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
  apply = apply(df, 1, sum), # nolint: matrix_apply_linter.
  "for" = forloop(df, `+`)
)

# too slow
df |>
  head(2000L) |>
  dplyr::rowwise() |>
  dplyr::mutate(x = sum(dplyr::c_across(everything())))

# #######1#########2#########3#########4#########5#########6#########7#########

mtcars_csv = readr::readr_example("mtcars.csv") |> rep(20)
bench::mark(
  readr::read_tsv(mtcars_csv)[],
  purrr::map(mtcars_csv, read_tsv) |> purrr::list_rbind()
)
