#include <iostream>
#include <sstream>
#include <fstream>
#include <random>

int main() {
#if defined _LIBCPP_VERSION
    constexpr const char* lib = "libc++";
#elif defined __GLIBCXX__
    constexpr const char* lib = "libstdc++";
#else
    constexpr const char* lib = "else";
#endif
    // const unsigned seed = std::random_device{}();
    const unsigned seed = 24601u;
    std::mt19937_64 engine(seed);
    const unsigned nrep = 1000u;
    const unsigned size = 10000u;
    std::binomial_distribution<unsigned> dist(1000u, 0.01);
    std::ostringstream oss;
    oss << "sum\n";
    for(unsigned j = 0u; j < nrep; ++j){
        unsigned sum = 0u;
        for (unsigned i = 0u; i < size; ++i) {
            sum += dist(engine);
        }
        oss << sum << "\n";
    }
    std::ostringstream outfile;
    outfile << "binomial-" << lib << ".tsv";
    std::ofstream(outfile.str()) << oss.str();
    std::cout << outfile.str() << std::endl;
    return 0;
}
