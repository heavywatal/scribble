Rcpp::cppFunction("
double nth_element_rcpp(const Rcpp::NumericVector& x, int n) {
    Rcpp::NumericVector copy(Rcpp::clone(x));
    auto it = copy.begin() + n;
    std::nth_element(copy.begin(), it, copy.end());
    return *it;
}
")

Rcpp::cppFunction("
double nth_element_rcpp_std(std::vector<double> copy, int n) {
    auto it = copy.begin() + n;
    std::nth_element(copy.begin(), it, copy.end());
    return *it;
}
")

cpp11::cpp_function("
double nth_element11(std::vector<double> copy, int n) {
    auto it = copy.begin() + n;
    std::nth_element(copy.begin(), it, copy.end());
    return *it;
}
")

nth_base = function(x, n) {
  sort(x, partial = n)[n]
}

size = 100000L
i = 10000L
x = runif(size)

bench::mark(
  rcpp = x < nth_element_rcpp(x, i),
  rcppstd = x < nth_element_rcpp_std(x, i),
  cpp11 = x < nth_element11(x, i),
  tumopp = x < tumopp:::nth_element(x, i),
  base = x < nth_base(x, i + 1L),
  vctrs = (i + 1L) > vctrs::vec_rank(x)
)
