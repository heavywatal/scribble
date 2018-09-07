#include <clipp.h>
#include <nlohmann/json.hpp>

#include <type_traits>
#include <vector>
#include <string>
#include <iostream>

#include <limits>

namespace detail {

struct nonempty {
  bool operator()(const std::string& s) {return !s.empty();}
};

template <bool Condition>
using enable_if_t = typename std::enable_if<Condition, std::nullptr_t>::type;

template <class T, enable_if_t<std::is_integral<T>{}> = nullptr>
inline auto filter_type(T) {
  return clipp::match::integers{};
}

template <class T, enable_if_t<std::is_floating_point<T>{}> = nullptr>
inline auto filter_type(T) {
  return clipp::match::numbers{};
}

template <class T, enable_if_t<!std::is_trivial<T>{}> = nullptr>
inline auto filter_type(T) {
  return nonempty{};
}

template <class T, enable_if_t<std::is_pointer<T>{}> = nullptr>
inline auto filter_type(T) {
  return nonempty{};
}

template <class T> inline
std::string doc_default(const T& x, const std::string& doc) {
  std::ostringstream oss;
  oss << doc << " (=" << x << ")";
  return oss.str();
}

template <typename T> inline
auto set(nlohmann::json& obj, const char* key) {
    return [&j = obj[key]](const char* s){j = s;};
}

template <> inline
auto set<bool>(nlohmann::json& obj, const char* key) {
    return [&j = obj[key]](){j = true;};
}

template <> inline
auto set<int>(nlohmann::json& obj, const char* key) {
    return [&j = obj[key]](const char* s){j = std::stoi(s);};
}

template <> inline
auto set<long>(nlohmann::json& obj, const char* key) {
    return [&j = obj[key]](const char* s){j = std::stol(s);};
}

template <> inline
auto set<unsigned>(nlohmann::json& obj, const char* key) {
    return [&j = obj[key]](const char* s){j = static_cast<unsigned>(std::stoul(s));};
}

template <> inline
auto set<unsigned long>(nlohmann::json& obj, const char* key) {
    return [&j = obj[key]](const char* s){j = std::stoul(s);};
}

template <> inline
auto set<unsigned long long>(nlohmann::json& obj, const char* key) {
    return [&j = obj[key]](const char* s){j = std::stoull(s);};
}

template <> inline
auto set<double>(nlohmann::json& obj, const char* key) {
    return [&j = obj[key]](const char* s){j = std::stod(s);};
}

} // namespace detail

template <class T> inline clipp::group
option(std::vector<std::string>&& flags, T* target, const std::string& doc="", const std::string& label="arg") {
    return (
      clipp::option(std::move(flags)) &
      clipp::value(detail::filter_type(*target), label, *target)
    ) % detail::doc_default(*target, doc);
}

inline clipp::parameter
option_bool(std::vector<std::string>&& flags, bool* target, const std::string& doc="") {
    return clipp::option(std::move(flags)).set(*target).doc(doc);
}

template <class T> inline clipp::group
option(nlohmann::json& obj, std::vector<std::string>&& flags, const T init, const std::string& doc="", const std::string& label="arg") {
    const char* key = flags.back().c_str();
    obj[key] = init;
    return (
      clipp::option(std::move(flags)) &
      clipp::value(detail::filter_type(init), label).call(detail::set<T>(obj, key))
    ) % detail::doc_default(obj[key], doc);
}

template <class T> inline clipp::group
option(nlohmann::json& obj, std::vector<std::string>&& flags, T* target, const std::string& doc="", const std::string& label="arg") {
    auto group = option(obj, std::move(flags), *target, doc, label);
    auto& value = group.back().as_param();
    value.call(clipp::set(*target));
    return group;
}

inline clipp::parameter
option_bool(nlohmann::json& obj, std::vector<std::string>&& flags, const std::string& doc="") {
    const char* key = flags.back().c_str();
    obj[key] = false;
    return clipp::option(std::move(flags)).call(detail::set<bool>(obj, key)).doc(doc);
}

inline clipp::doc_formatting doc_format() {
    return clipp::doc_formatting{}
      .first_column(0)
      .doc_column(24)
      .last_column(80)
      .indent_size(2)
      .flag_separator(",")
    ;
}

inline std::ostream&
usage(std::ostream& ost,
      const clipp::group& cli,
      const std::string& program="PROGRAM",
      clipp::doc_formatting fmt=doc_format()) {
    return ost << clipp::usage_lines(cli, program, fmt) << "\n\n"
               << clipp::documentation(cli, fmt) << "\n";
}

/////////1/////////2/////////3/////////4/////////5/////////6/////////7/////////

struct Parameters {
    bool BOOL = false;
    int INT = std::numeric_limits<int>::max();
    long LONG = std::numeric_limits<long>::max();
    unsigned UNSIGNED = std::numeric_limits<unsigned>::max();
    size_t SIZE_T = std::numeric_limits<size_t>::max();
    double DOUBLE = 0.0;
    std::string STRING = "Hello, world!";
};

inline clipp::group test_types(nlohmann::json& vm, Parameters& p) {
    return clipp::with_prefixes_short_long("-", "--",
        option_bool(vm, {"b", "bool"}),
        option(vm, {"i", "int"}, &p.INT),
        option(vm, {"l", "long"}, &p.LONG),
        option(vm, {"u", "unsigned"}, &p.UNSIGNED),
        option(vm, {"s", "size_t"}, &p.SIZE_T),
        option(vm, {"d", "double"}, &p.DOUBLE),
        option(vm, {"c", "string"}, &p.STRING)
    ).doc("Supported types:");
}

int main(int argc, char* argv[]) {
    const auto program = argv[0];
    std::vector<std::string> arguments(argv + 1, argv + argc);

    bool help = false;
    bool version = false;
    int answer = 42;
    clipp::group general_options = clipp::with_prefixes_short_long("-", "--",
      option_bool({"h", "help"}, &help, "Print help"),
      option_bool({"version"}, &version, "Print version"),
      option({"a", "answer"}, &answer, "Answer")
    ).doc("Not stored in json:");

    nlohmann::json vm;
    Parameters p;
    auto cli = (
      general_options,
      test_types(vm, p)
    );
    auto parsed = clipp::parse(arguments, cli);
    if (!parsed) {
        usage(std::cout, cli, program)
          << "Error: unknown argument\n";
        return 1;
    }
    clipp::debug::print(std::cerr, parsed);
    if (help) {
        usage(std::cout, cli, program);
        return 0;
    }
    if (version) {
        std::cout << "clipp 1.2.0\n";
        return 0;
    }
    std::cerr << "Answer: " << answer << "\n";
    std::cout << vm.dump(2) << "\n";
}
