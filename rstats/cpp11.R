loadNamespace("cpp11")

# nolint start: quotes_linter.

cpp11::cpp_function('cpp11::integers
mod_copy(cpp11::writable::integers x, int i) {
  x[i] = 999;
  return x;
}
')
x = seq_len(6L)
mod_copy(x, 1L)
x

cpp11::cpp_function('cpp11::list
append_named(cpp11::writable::list x) {
  x.push_back(cpp11::named_arg("z") = 42);
  return x;
}')
append_named(list(y = 1))

cpp11::cpp_function('cpp11::list
modify_named(cpp11::writable::list x) {
  x["y"] = cpp11::as_sexp(999);
  // x["y"] = cpp11::writable::integers{999}; // OK
  // x["y"] = 999;                            // NG
  return x;
}')
modify_named(list(x = 1, y = 2))  # can modify existing
modify_named(list(x = 1))         # cannot add new element

# #######1#########2#########3#########4#########5#########6#########7#########
# data_frame is not supposed to be modified

cpp11::cpp_function('cpp11::data_frame
cannot_compile(cpp11::writable::data_frame df) {
  using namespace cpp11::literals;
  df.reserve(8);
  df.push_back({"z"_nm = cpp11::as_sexp(999)});
  return df;
}')
# error: no member named 'reserve' in 'cpp11::writable::data_frame'
# error: no member named 'push_back' in 'cpp11::writable::data_frame'

# receive and modify as list, and return as data_frame
cpp11::cpp_function('cpp11::data_frame
add_col(cpp11::writable::list df_as_list) {
  using namespace cpp11::literals;
  df_as_list.reserve(4);
  df_as_list.push_back({"z"_nm = cpp11::as_sexp(999)});
  return cpp11::writable::data_frame(df_as_list);
}')
add_col(data.frame(x = 1))

# #######1#########2#########3#########4#########5#########6#########7#########
# Create 0-length vector

cpp11::cpp_function('cpp11::strings
null_not_character0() {
  return cpp11::strings();
}')
null_not_character0()

cpp11::cpp_function('cpp11::strings
character0_R() {
  return cpp11::writable::strings(R_len_t(0));
}')
character0_R()

cpp11::cpp_function('cpp11::strings
character0_paren() {
  return cpp11::writable::strings();
}')
character0_paren()

cpp11::cpp_function('cpp11::strings
character0_brace() {
  return cpp11::writable::strings{};
}')
character0_brace()

# nolint end
