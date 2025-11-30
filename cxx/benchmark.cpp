#include <fmt/base.h>
#include <fmt/ranges.h>
#include <wtl/random.hpp>
#include <wtl/numeric.hpp>
#include <wtl/chrono.hpp>
#include <wtl/resource.hpp>
#include <wtl/iostr.hpp>
#include <wtl/signed.hpp>
#include <pcglite/pcglite.hpp>
#include <pcg/pcg_random.hpp>

#include <sfmt.hpp>

inline void random_uint32() {
    pcglite::pcg32 rng32{};
    pcglite::pcg64 rng64{};
    constexpr int n = 4 * 1000 * 1000;
    uint32_t trash = 0;
    fmt::println("random_uint32");
    fmt::println("{}\tstatic_cast32(gen64)", wtl::delta_rusage([&](){
        for (int i = 0; i < n; ++i) {
            trash += static_cast<uint32_t>(rng64());
        }
    }, 3));
    fmt::println("{}\tgen32::operator()", wtl::delta_rusage([&](){
        for (int i = 0; i < n; ++i) {
            trash += rng32();
        }
    }, 3));
    fmt::println("{}\tunif32(gen64)", wtl::delta_rusage([&](){
        std::uniform_int_distribution<uint32_t> unif;
        for (int i = 0; i < n; ++i) {
            trash += unif(rng64);
        }
    }, 3));
    fmt::println("trash: {}", trash);
}

inline void random_canonical() {
    pcglite::pcg32 rng32{};
    pcglite::pcg64 rng64{};
    constexpr int n = 16 * 1000 * 1000;
    double trash = 0;
    fmt::println("random_canonical");
    fmt::println("{}\twtl::generate_canonical(gen64)", wtl::delta_rusage([&](){
        for (int i = 0; i < n; ++i) {
            trash += wtl::generate_canonical(rng64);
        }
    }, 5));
    fmt::println("{}\twtl::generate_canonical(gen32)", wtl::delta_rusage([&](){
        for (int i = 0; i < n; ++i) {
            trash += wtl::generate_canonical(rng32);
        }
    }, 5));
    fmt::println("{}\tstd::generate_canonical<>(gen64)", wtl::delta_rusage([&](){
        for (int i = 0; i < n; ++i) {
            trash += std::generate_canonical<double, std::numeric_limits<double>::digits>(rng64);
        }
    }, 5));
    fmt::println("{}\tstd::generate_canonical<>(gen32)", wtl::delta_rusage([&](){
        for (int i = 0; i < n; ++i) {
            trash += std::generate_canonical<double, std::numeric_limits<double>::digits>(rng32);
        }
    }, 5));
    fmt::println("trash: {}", trash);
}

inline void random_sample() {
    pcglite::pcg64 rng64{};
    constexpr int n = 4 * 1000 * 1000;
    std::vector<int> x(n);
    std::iota(x.begin(), x.end(), 0);
    constexpr int k = n / 40;
    int trash = 0;
    fmt::println("random_sample");
    fmt::println("{}\twtl::sample(n, k, gen64)", wtl::delta_rusage([&](){
        trash += *wtl::sample(n, k, rng64).begin();
    }, 3));
    fmt::println("{}\twtl::sample(x, k, gen64)", wtl::delta_rusage([&](){
        trash += wtl::sample(x, k, rng64)[0];
    }, 3));
    fmt::println("{}\twtl::sample_floyd(x, k, gen64)", wtl::delta_rusage([&](){
        trash += wtl::sample_floyd(x, k, rng64)[0];
    }, 3));
    fmt::println("{}\twtl::sample_fisher(x, k, gen64)", wtl::delta_rusage([&](){
        trash += wtl::sample_fisher(x, k, rng64)[0];
    }, 3));
    fmt::println("{}\twtl::sample_knuth(x, k, gen64)", wtl::delta_rusage([&](){
        trash += wtl::sample_knuth(x, k, rng64)[0];
    }, 3));
    fmt::println("trash: {}", trash);
    x.resize(6);
    fmt::println("{}", x);
}

inline void random_engine() {
    constexpr int n = 1 * 1000 * 1000;
    std::vector<int> v(n);
    std::poisson_distribution<int> dist(2.0);
    // std::vector<double> v(n);
    // std::normal_distribution<double> dist(0.0, 1.0);
    // std::uniform_real_distribution<double> dist(0.0, 1.0);
    auto lambda_random = [&](auto&& generator) mutable {
        for (int j = 0; j < n; ++j) {
            wtl::at(v, j) = dist(generator);
        }
    };
    fmt::println("random_engine");
    fmt::println("{}\tstd::mt19937", wtl::delta_rusage<std::micro>([&]() {
        lambda_random(std::mt19937{});
    }, 3));
    fmt::println("{}\tstd::mt19937_64", wtl::delta_rusage<std::micro>([&]() {
        lambda_random(std::mt19937_64{});
    }, 3));
    fmt::println("{}\twtl::sfmt19937", wtl::delta_rusage<std::micro>([&]() {
        lambda_random(wtl::sfmt19937{});
    }, 3));
    fmt::println("{}\twtl::sfmt19937_64", wtl::delta_rusage<std::micro>([&]() {
        lambda_random(wtl::sfmt19937_64{});
    }, 3));
    fmt::println("{}\tpcglite::pcg32", wtl::delta_rusage<std::micro>([&]() {
        lambda_random(pcglite::pcg32{});
    }, 3));
    fmt::println("{}\tpcglite::pcg64", wtl::delta_rusage<std::micro>([&]() {
        lambda_random(pcglite::pcg64{});
    }, 3));
    fmt::println("{}\tpcg32", wtl::delta_rusage<std::micro>([&]() {
        lambda_random(pcg32{});
    }, 3));
    fmt::println("{}\tpcg64", wtl::delta_rusage<std::micro>([&]() {
        lambda_random(pcg64{});
    }, 3));
    fmt::println("{}", wtl::mean(v));
}

inline void random_binomial() {
    pcglite::pcg64 rng64{};
    constexpr int n = 256 * 1024;
    int trash = 0;
    std::binomial_distribution binom01(10000, 0.05);
    std::binomial_distribution binom03(10000, 0.3);
    std::binomial_distribution binom05(10000, 0.5);
    std::binomial_distribution binom07(10000, 0.7);
    std::binomial_distribution binom09(10000, 0.95);
    fmt::println("random_binomial");
    fmt::println("{}\tbinom01", wtl::delta_rusage([&](){
        for (int i = 0; i < n; ++i) { trash += binom01(rng64); }
    }, 3));
    fmt::println("{}\tbinom03", wtl::delta_rusage([&](){
        for (int i = 0; i < n; ++i) { trash += binom03(rng64); }
    }, 3));
    fmt::println("{}\tbinom05", wtl::delta_rusage([&](){
        for (int i = 0; i < n; ++i) { trash += binom05(rng64); }
    }, 3));
    fmt::println("{}\tbinom07", wtl::delta_rusage([&](){
        for (int i = 0; i < n; ++i) { trash += binom07(rng64); }
    }, 3));
    fmt::println("{}\tbinom09", wtl::delta_rusage([&](){
        for (int i = 0; i < n; ++i) { trash += binom09(rng64); }
    }, 3));
    fmt::println("{}", trash);
}

int main() {
    random_uint32();
    random_canonical();
    random_sample();
    random_engine();
    random_binomial();
}
