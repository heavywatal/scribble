#include <clipp.h>

#include <iostream>

class Individual {
  public:
    static clipp::group parameter_group() {
        return clipp::with_prefixes_short_long("-", "--",
          (clipp::option("d", "death") & clipp::number("num", DEATH_RATE_))
            % "Death rate",
          (clipp::option("u", "mutation") & clipp::number("num", MUTATION_RATE_))
            % "Mutation rate"
        );
    }
    static double DEATH_RATE() {return DEATH_RATE_;}
    static double MUTATION_RATE() {return MUTATION_RATE_;}

  private:
    static double DEATH_RATE_;
    static double MUTATION_RATE_;
};

double Individual::MUTATION_RATE_ = 0.1;
double Individual::DEATH_RATE_ = 0.1;


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
        .start_column(2)
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
        std::cout << "clipp 1.1.0\n";
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
    std::cout << "Individual::DEATH_RATE_: " << Individual::DEATH_RATE() << "\n";
    std::cout << "Individual::MUTATION_RATE_: " << Individual::MUTATION_RATE() << "\n";
}
