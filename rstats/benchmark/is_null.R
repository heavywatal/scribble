.is_null = function(x) {
  len = length(x)
  v = logical(len)
  for (i in seq_len(len)) v[[i]] = is.null(x[[i]])
  v
}

fapply = function(.x, .f, .class) {
  .f = match.fun(.f)
  len = length(.x)
  res = .class(len)
  for (i in seq_len(len)) res[[i]] = .f(.x[[i]])
  res
}

Rcpp::cppFunction('
std::vector<bool> apply_is_null(const Rcpp::List& x) {
  size_t n = x.size();
  std::vector<bool> res(n);
  for (size_t i = 0u; i < n; ++i) {
    res[i] = (x[i] == R_NilValue);
  }
  return res;
}
')

cpp11::cpp_function("
cpp11::logicals cpp11_is_null(const cpp11::list& x) {
  size_t n = x.size();
  cpp11::writable::logicals res;
  res.reserve(n);
  for (size_t i = 0u; i < n; ++i) {
    res.push_back(x[i] == R_NilValue);
  }
  return res;
}
")

N = 10000L
df = dplyr::left_join(by = "x",
  tibble::tibble(x = seq_len(N)),
  tibble::tibble(x = sample.int(N, N %/% 2L), y = list(tibble(a = 0L)))
) |> print()
df$z = purrr::map_if(df$y, is.null, ~NA)

stopifnot(.is_null(df$y) == (lengths(df$y) == 0L))
stopifnot(.is_null(df$y) == purrr::map_lgl(df$y, is.null))
stopifnot(.is_null(df$y) == vapply(df$y, is.null, FALSE, USE.NAMES = FALSE))
stopifnot(.is_null(df$y) == fapply(df$y, is.null, logical))
stopifnot(.is_null(df$y) == apply_is_null(df$y))
stopifnot(.is_null(df$y) == cpp11_is_null(df$y))
stopifnot(.is_null(df$y) == is.na(df$z))

bench::mark(
  lengths = lengths(df$y) == 0L,
  map_lgl = purrr::map_lgl(df$y, is.null),
  vapply = vapply(df$y, is.null, FALSE, USE.NAMES = FALSE),
  fapply = fapply(df$y, is.null, logical),
  idx = .is_null(df$y),
  rpp = apply_is_null(df$y),
  cpp11 = cpp11_is_null(df$y),
  is.na = is.na(df$z)
)
