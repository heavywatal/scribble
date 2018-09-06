#include <clipp.h>

#include <type_traits>
#include <vector>
#include <string>
#include <iostream>

struct nonempty {
  bool operator()(const std::string& s) {return !s.empty();}
};

template <class T, typename std::enable_if<std::is_integral<T>{}, std::nullptr_t>::type=nullptr>
inline auto filter_type(T) {
  return clipp::match::integers{};
}

template <class T, typename std::enable_if<std::is_floating_point<T>{}, std::nullptr_t>::type=nullptr>
inline auto filter_type(T) {
  return clipp::match::numbers{};
}

template <class T, typename std::enable_if<!std::is_trivial<T>{}, std::nullptr_t>::type=nullptr>
inline auto filter_type(T) {
  return nonempty{};
}

template <class T> inline
std::string doc_default(const T& x, const std::string& doc) {
  std::ostringstream oss;
  oss << doc << " (=" << x << ")";
  return oss.str();
}

template <class T> inline clipp::group
clipp_group(clipp::parameter&& option, T& x, const std::string& doc="", const std::string& label="arg") {
    return (option & clipp::value(filter_type(x), label, x)).doc(doc_default(x, doc));
}

class Individual {
  public:
    static clipp::group parameter_group() {
        return clipp::with_prefixes_short_long("-", "--",
          clipp_group(clipp::option("d", "death"), DEATH_RATE_, "Death rate"),
          clipp_group(clipp::option("l", "genome"), GENOME_SIZE_, "Genome size"),
          clipp_group(clipp::option("m", "mode"), MODE_)
        );
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

    enum class mode_t {run, help, version};
    mode_t mode = mode_t::run;

    clipp::group general_options = clipp::with_prefixes_short_long("-", "--",
      clipp::option("h", "help").set(mode, mode_t::help).doc("Print help"),
      clipp::option("version").set(mode, mode_t::version).doc("Print version"),
      clipp::option("v", "verbose")
    );
    auto cli = (
      general_options,
      Individual::parameter_group()
    );
    auto parsed = clipp::parse(arguments, cli);

    auto fmt = clipp::doc_formatting{}
        .first_column(2)
        .doc_column(24);

    if (!parsed) {
        std::cout << clipp::make_man_page(cli, program, fmt);
        std::cout << "Error: unknown argument\n";
        return 1;
    }
    switch (mode) {
      case mode_t::help:
        std::cout << clipp::make_man_page(cli, program, fmt);
        return 0;
      case mode_t::version:
        std::cout << "clipp 1.2.0\n";
        return 0;
      default:
        break;
    }
    for (const auto& m: parsed) {
        std::cout << m.index() << ": " << m.arg() << " -> " << m.param();
        std::cout << " repeat #" << m.repeat();
        if (m.blocked()) std::cout << " blocked";
        if (m.conflict()) std::cout << " conflict";
        std::cout << '\n';
    }
    std::cout << "Individual::DEATH_RATE_: " << Individual::DEATH_RATE_ << "\n";
    std::cout << "Individual::GENOME_SIZE_: " << Individual::GENOME_SIZE_ << "\n";
    std::cout << "Individual::MODE_: " << Individual::MODE_ << "\n";
}
