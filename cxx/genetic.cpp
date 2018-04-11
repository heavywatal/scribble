#include <wtl/genetic.hpp>
#include <wtl/random.hpp>
#include <wtl/chrono.hpp>
#include <wtl/iostr.hpp>

int main() {
    const size_t n = 100'000;
    std::vector<double> fitnesses(n);
    std::vector<double> children(n);

    for (double& w: fitnesses) {w = wtl::generate_canonical(wtl::mt64());}
    wtl::benchmark([&](){
        for (size_t i=0u; i<10u; ++i) {
            auto indices = wtl::roulette_select_cxx11(fitnesses, n, wtl::mt64());
            children.clear();
            for (const auto j: indices) {
                children.push_back(fitnesses[j]);
            }
            fitnesses.swap(children);
        }
        std::cerr << wtl::mean(fitnesses) << std::endl;
    }, "roulette_select_cxx11");

    for (double& w: fitnesses) {w = wtl::generate_canonical(wtl::mt64());}
    wtl::benchmark([&](){
        for (size_t i=0u; i<10u; ++i) {
            auto indices = wtl::roulette_select(fitnesses, n, wtl::mt64());
            children.clear();
            for (const auto j: indices) {
                children.push_back(fitnesses[j]);
            }
            fitnesses.swap(children);
        }
        std::cerr << wtl::mean(fitnesses) << std::endl;
    }, "roulette_select");

    for (double& w: fitnesses) {w = wtl::generate_canonical(wtl::mt64());}
    wtl::benchmark([&](){
        for (size_t i=0u; i<10u; ++i) {
            std::discrete_distribution<size_t> dist(fitnesses.begin(), fitnesses.end());
            children.clear();
            for (size_t j=0u; j<n; ++j) {
                children.push_back(fitnesses[dist(wtl::mt64())]);
            }
            fitnesses.swap(children);
        }
        std::cerr << wtl::mean(fitnesses) << std::endl;
    }, "discrete_distribution");
}
