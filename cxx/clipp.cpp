#include <clipp.h>
#include <nlohmann/json.hpp>

#include <type_traits>
#include <vector>
#include <string>
#include <iostream>

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
auto set<double>(nlohmann::json& obj, const char* key) {
    return [&j = obj[key]](const char* s){j = std::stod(s);};
}

template <> inline
auto set<int>(nlohmann::json& obj, const char* key) {
    return [&j = obj[key]](const char* s){j = std::stoi(s);};
}

template <> inline
auto set<unsigned long>(nlohmann::json& obj, const char* key) {
    return [&j = obj[key]](const char* s){j = std::stoul(s);};
}

template <> inline
auto set<bool>(nlohmann::json& obj, const char* key) {
    return [&j = obj[key]](){j = true;};
}

template <class T> inline clipp::group
option(std::vector<std::string>&& flags, T* target, const std::string& doc="", const std::string& label="arg") {
    return (
      clipp::option(std::move(flags)) &
      clipp::value(filter_type(*target), label, *target)
    ) % doc_default(*target, doc);
}

template <class T> inline clipp::group
option(nlohmann::json& obj, std::vector<std::string>&& flags, const T init, const std::string& doc="", const std::string& label="arg") {
    const char* key = flags.back().c_str();
    obj[key] = init;
    return (
      clipp::option(std::move(flags)) &
      clipp::value(filter_type(init), label).call(set<T>(obj, key))
    ) % doc_default(obj[key], doc);
}

template <class T> inline clipp::group
option(nlohmann::json& obj, std::vector<std::string>&& flags, T* target, const std::string& doc="", const std::string& label="arg") {
    auto group = option(obj, std::move(flags), *target, doc, label);
    group.back().as_param().call(clipp::set(*target));
    return group;
}

inline clipp::parameter
option_bool(nlohmann::json& obj, std::vector<std::string>&& flags, const std::string& doc="") {
    const char* key = flags.back().c_str();
    obj[key] = false;
    return (clipp::option(flags).call(set<bool>(obj, key))).doc(doc);
}

/////////1/////////2/////////3/////////4/////////5/////////6/////////7/////////

class Individual {
  public:
    static clipp::group parameter_group(nlohmann::json& vm) {
        return clipp::with_prefixes_short_long("-", "--",
          option(vm, {"d", "death"}, &DEATH_RATE_, "Death rate"),
          option(vm, {"l", "genome"}, &GENOME_SIZE_, "Genome size"),
          option(vm, {"m", "mode"}, &MODE_)
        ).doc("Individual");
    }
    static double DEATH_RATE_;
    static unsigned GENOME_SIZE_;
    static std::string MODE_;
};

double Individual::DEATH_RATE_ = 0.1;
unsigned Individual::GENOME_SIZE_ = 42;
std::string Individual::MODE_ = "normal";

int main(int argc, char* argv[]) {
    const auto program = argv[0];
    std::vector<std::string> arguments(argv + 1, argv + argc);

    nlohmann::json vm;
    clipp::group general_options = clipp::with_prefixes_short_long("-", "--",
      option_bool(vm, {"h", "help"}, "Print help"),
      option_bool(vm, {"version"}, "Print version"),
      option(vm, {"pi"}, 3.1415, "Mathematical constant")
    );
    auto cli = (
      general_options,
      Individual::parameter_group(vm)
    );
    auto parsed = clipp::parse(arguments, cli);

    auto fmt = clipp::doc_formatting{}
        .first_column(2)
        .doc_column(24)
        .last_column(80)
        .indent_size(4)
        .flag_separator(",")
    ;

    if (!parsed) {
        std::cout << clipp::make_man_page(cli, program, fmt);
        std::cout << "Error: unknown argument\n";
        return 1;
    }
    if (vm["help"]) {
        std::cout << clipp::make_man_page(cli, program, fmt);
        return 0;
    }
    if (vm["version"]) {
        std::cout << "clipp 1.2.0\n";
        return 0;
    }
    for (const auto& m: parsed) {
        std::cout << m.index() << ": " << m.arg() << " -> " << m.param();
        std::cout << " repeat #" << m.repeat();
        if (m.blocked()) std::cout << " blocked";
        if (m.conflict()) std::cout << " conflict";
        std::cout << '\n';
    }
    std::cout << vm.dump(2) << "\n";
    std::cout << Individual::DEATH_RATE_ << "\n";
    std::cout << Individual::GENOME_SIZE_ << "\n";
    std::cout << Individual::MODE_ << "\n";
}
