loadNamespace("Rcpp")
loadNamespace("cpp11")

Rcpp::sourceCpp(code = "
  #include <Rcpp.h>
  // [[Rcpp::export]]
  Rcpp::sugar::SeqLen seq_lenRcpp(const int x) {
    return Rcpp::seq_len(x);
  }")

cpp11::cpp_source("altrep.cpp")

n = 1e6
bench::mark(
  seq_len(n),
  seq_len11(n),
  seq_len11static(n),
  seq_len11protect(n),
  seq_len11rownames(n),
  seq_len11rownames_static(n),
  seq_len11stl(n),
  seq_lenRcpp(n)
)
