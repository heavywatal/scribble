Rcpp::cppFunction("
double nth_element_constref(const Rcpp::NumericVector& x, int n) {
    Rcpp::NumericVector copy(Rcpp::clone(x));
    auto it = copy.begin() + (n - 1);
    std::nth_element(copy.begin(), it, copy.end());
    return *it;
}
")

Rcpp::cppFunction("
double nth_element_ref(Rcpp::NumericVector& x, int n) {
    Rcpp::NumericVector copy(Rcpp::clone(x));
    auto it = copy.begin() + (n - 1);
    std::nth_element(copy.begin(), it, copy.end());
    return *it;
}
")

Rcpp::cppFunction("
double nth_element(Rcpp::NumericVector x, int n) {
    auto it = x.begin() + (n - 1);
    std::nth_element(x.begin(), it, x.end());
    return *it;
}
")

nth_base = function(x, n) {
  sort(x, partial = n)[n]
}

size = 10000L
i = 10L
x = runif(size)

bench::mark(
  constref = x < nth_element_constref(x, i),
  ref = x < nth_element_ref(x, i),
  cpp = x < nth_element(x, i),
  base = x < nth_base(x, i),
  vctrs = i > vctrs::vec_rank(x)
)
