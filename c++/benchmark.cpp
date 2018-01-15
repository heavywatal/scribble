#include <wtl/random.hpp>
#include <wtl/numeric.hpp>
#include <wtl/chrono.hpp>
#include <wtl/iostr.hpp>

#include <sfmt.hpp>

#include <functional>

inline void random_uint32() {
    constexpr size_t n = 4 * 1000 * 1000;
    uint32_t trash = 0;
    wtl::benchmark([&](){
        for (size_t i=0; i<n; ++i) {
            trash += wtl::sfmt()();
        }
    }, "gen32::operator()");
    std::cerr << trash << std::endl;
    wtl::benchmark([&](){
        std::uniform_int_distribution<uint32_t> unif;
        for (size_t i=0; i<n; ++i) {
            trash += unif(wtl::sfmt64());
        }
    }, "unif32(gen64)");
    std::cerr << trash << std::endl;
}

inline void random_sample() {
    constexpr size_t n = 4 * 1000 * 1000;
    std::vector<size_t> x(n);
    std::iota(x.begin(), x.end(), 0u);
    size_t k = n / 40u;
    size_t trash = 0;
    wtl::benchmark([&](){
        trash += *wtl::sample(n, k, wtl::sfmt64()).begin();
    }, "sample int");
    std::cerr << trash << std::endl;
    wtl::benchmark([&](){
        trash += wtl::sample(x, k, wtl::sfmt64())[0];
    }, "sample");
    std::cerr << trash << std::endl;
    wtl::benchmark([&](){
        trash += wtl::sample_floyd(x, k, wtl::sfmt64())[0];
    }, "sample_floyd");
    std::cerr << trash << std::endl;
    wtl::benchmark([&](){
        trash += wtl::sample_fisher(x, k, wtl::sfmt64())[0];
    }, "sample_fisher");
    std::cerr << trash << std::endl;
    wtl::benchmark([&](){
        trash += wtl::sample_knuth(x, k, wtl::sfmt64())[0];
    }, "sample_knuth");
    std::cerr << trash << std::endl;
    x.resize(6);
    std::cerr << x << std::endl;
}

inline void random_engine() {
    constexpr size_t n = 1 * 1000 * 1000;
    std::vector<size_t> v(n);
    std::poisson_distribution<size_t> dist(2.0);
    // std::vector<double> v(n);
    // std::normal_distribution<double> dist(0.0, 1.0);
    // std::uniform_real_distribution<double> dist(0.0, 1.0);
    auto lambda_random = [&](auto& generator) mutable {
        for (size_t j=0; j<n; ++j) {
            v[j] = dist(generator);
        }
    };
    wtl::benchmark(std::bind(lambda_random, wtl::mt()), "mt", 2);
    std::cerr << wtl::mean(v) << std::endl;
    wtl::benchmark(std::bind(lambda_random, wtl::mt64()), "mt64", 2);
    std::cerr << wtl::mean(v) << std::endl;
    wtl::benchmark(std::bind(lambda_random, wtl::sfmt()), "sfmt", 2);
    std::cerr << wtl::mean(v) << std::endl;
    wtl::benchmark(std::bind(lambda_random, wtl::sfmt64()), "sfmt64", 2);
    std::cerr << wtl::mean(v) << std::endl;
}

int main() {
    random_uint32();
    random_sample();
    random_engine();
}
