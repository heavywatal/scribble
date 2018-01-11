#include <wtl/random.hpp>
#include <wtl/numeric.hpp>
#include <wtl/chrono.hpp>
#include <wtl/iostr.hpp>

#include <sfmt.hpp>

#include <functional>

int main() {
    constexpr size_t n = 2 * 1000 * 1000;
    std::vector<size_t> x(n);

    double mu = 8.0;
    std::poisson_distribution<size_t> dist(mu);

    auto lambda_random = [&](auto& generator) mutable {
        for (size_t j=0; j<n; ++j) {
            x[j] = dist(generator);
        }
    };
    wtl::benchmark(std::bind(lambda_random, wtl::mt()), "mt", 2);
    std::cerr << wtl::mean(x) << std::endl;
    wtl::benchmark(std::bind(lambda_random, wtl::mt64()), "mt64", 2);
    std::cerr << wtl::mean(x) << std::endl;
    wtl::benchmark(std::bind(lambda_random, wtl::sfmt()), "sfmt", 2);
    std::cerr << wtl::mean(x) << std::endl;
    wtl::benchmark(std::bind(lambda_random, wtl::sfmt64()), "sfmt64", 2);
    std::cerr << wtl::mean(x) << std::endl;

    size_t k = n / 50;
    size_t trash = 0;
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
