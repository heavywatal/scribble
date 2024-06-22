#include <numeric>

#include <cpp11.hpp>

[[cpp11::register]]
cpp11::integers seq_len11(const int n) {
  auto base_seq_len = cpp11::package("base")["seq_len"];
  return {base_seq_len(n)};
}

[[cpp11::register]]
cpp11::integers seq_len11static(const int n) {
  static auto base_seq_len = cpp11::package("base")["seq_len"];
  return {base_seq_len(n)};
}

[[cpp11::register]]
cpp11::integers seq_len11protect(const int n) {
  static auto base_seq_len = cpp11::package("base")["seq_len"];
  SEXP p = PROTECT(base_seq_len(n));
  cpp11::integers v{p};
  UNPROTECT(1);
  return v;
}

[[cpp11::register]]
SEXP seq_len11rownames(const int n) {
  cpp11::writable::list x(static_cast<R_xlen_t>(0));
  x.attr(R_RowNamesSymbol) = {NA_INTEGER, -n};
  return x.attr(R_RowNamesSymbol);
}

[[cpp11::register]]
SEXP seq_len11rownames_static(const int n) {
  static cpp11::writable::list x(static_cast<R_xlen_t>(0));
  x.attr(R_RowNamesSymbol) = {NA_INTEGER, -n};
  return x.attr(R_RowNamesSymbol);
}

[[cpp11::register]]
cpp11::integers seq_len11stl(const int n) {
  cpp11::writable::integers v(n);
  std::iota(v.begin(), v.end(), 1);
  return v;
}
