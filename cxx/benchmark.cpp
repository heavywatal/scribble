#include <wtl/random.hpp>
#include <wtl/numeric.hpp>
#include <wtl/chrono.hpp>
#include <wtl/resource.hpp>
#include <wtl/iostr.hpp>
#include <pcglite/pcglite.hpp>
#include <pcg/pcg_random.hpp>

#include <sfmt.hpp>

inline void random_uint32() {
    pcglite::pcg32 rng32{};
    pcglite::pcg64 rng64{};
    constexpr size_t n = 4 * 1000 * 1000;
    uint32_t trash = 0;
    std::cout << wtl::diff_rusage([&](){
        for (size_t i=0; i<n; ++i) {
            trash += static_cast<uint32_t>(rng64());
        }
    }, 3u) << "\t""static_cast32(gen64)""\t" << trash << std::endl;
    std::cout << wtl::diff_rusage([&](){
        for (size_t i=0; i<n; ++i) {
            trash += rng32();
        }
    }, 3u) << "\t""gen32::operator()""\t" << trash << std::endl;
    std::cout << wtl::diff_rusage([&](){
        std::uniform_int_distribution<uint32_t> unif;
        for (size_t i=0; i<n; ++i) {
            trash += unif(rng64);
        }
    }, 3u) << "\t""unif32(gen64)""\t" << trash << std::endl;
}

inline void random_canonical() {
    pcglite::pcg32 rng32{};
    pcglite::pcg64 rng64{};
    constexpr size_t n = 16 * 1000 * 1000;
    double trash = 0;
    std::cout << wtl::diff_rusage([&](){
        for (size_t i=0; i<n; ++i) {
            trash += wtl::generate_canonical(rng64);
        }
    }, 5u) << "\t""wtl::generate_canonical(gen64)""\t" << trash << std::endl;
    std::cout << wtl::diff_rusage([&](){
        for (size_t i=0; i<n; ++i) {
            trash += wtl::generate_canonical(rng32);
        }
    }, 5u) << "\t""wtl::generate_canonical(gen32)""\t" << trash << std::endl;
    std::cout << wtl::diff_rusage([&](){
        for (size_t i=0; i<n; ++i) {
            trash += std::generate_canonical<double, std::numeric_limits<double>::digits>(rng64);
        }
    }, 5u) << "\t""std::generate_canonical<>(gen64)""\t" << trash << std::endl;
    std::cout << wtl::diff_rusage([&](){
        for (size_t i=0; i<n; ++i) {
            trash += std::generate_canonical<double, std::numeric_limits<double>::digits>(rng32);
        }
    }, 5u) << "\t""std::generate_canonical<>(gen32)""\t" << trash << std::endl;
}

inline void random_sample() {
    pcglite::pcg64 rng64{};
    constexpr size_t n = 4 * 1000 * 1000;
    std::vector<size_t> x(n);
    std::iota(x.begin(), x.end(), 0u);
    size_t k = n / 40u;
    size_t trash = 0;
    std::cout << wtl::diff_rusage([&](){
        trash += *wtl::sample(n, k, rng64).begin();
    }, 3u) << "\t""sample int""\t" << trash << std::endl;;
    std::cout << wtl::diff_rusage([&](){
        trash += wtl::sample(x, k, rng64)[0];
    }, 3u) << "\t""sample""\t" << trash << std::endl;;
    std::cout << wtl::diff_rusage([&](){
        trash += wtl::sample_floyd(x, k, rng64)[0];
    }, 3u) << "\t""sample_floyd""\t" << trash << std::endl;;
    std::cout << wtl::diff_rusage([&](){
        trash += wtl::sample_fisher(x, k, rng64)[0];
    }, 3u) << "\t""sample_fisher""\t" << trash << std::endl;;
    std::cout << wtl::diff_rusage([&](){
        trash += wtl::sample_knuth(x, k, rng64)[0];
    }, 3u) << "\t""sample_knuth""\t" << trash << std::endl;;
    x.resize(6);
    std::cout << x << std::endl;
}

inline void random_engine() {
    constexpr size_t n = 1 * 1000 * 1000;
    std::vector<size_t> v(n);
    std::poisson_distribution<size_t> dist(2.0);
    // std::vector<double> v(n);
    // std::normal_distribution<double> dist(0.0, 1.0);
    // std::uniform_real_distribution<double> dist(0.0, 1.0);
    auto lambda_random = [&](auto&& generator) mutable {
        for (size_t j=0; j<n; ++j) {
            v[j] = dist(generator);
        }
    };
    std::cout << wtl::diff_rusage<std::micro>([&]() {
      lambda_random(std::mt19937{});
    }, 3) << "\t""mt" << std::endl;
    std::cout << wtl::diff_rusage<std::micro>([&]() {
      lambda_random(std::mt19937_64{});
    }, 3) << "\t""mt64" << std::endl;
    std::cout << wtl::diff_rusage<std::micro>([&]() {
      lambda_random(wtl::sfmt19937{});
    }, 3) << "\t""sfmt" << std::endl;;
    std::cout << wtl::diff_rusage<std::micro>([&]() {
      lambda_random(wtl::sfmt19937_64{});
    }, 3) << "\t""sfmt64" << std::endl;
    std::cout << wtl::diff_rusage<std::micro>([&]() {
      lambda_random(pcglite::pcg32{});
    }, 3) << "\t""pcglite::pcg32" << std::endl;
    std::cout << wtl::diff_rusage<std::micro>([&]() {
      lambda_random(pcglite::pcg64{});
    }, 3) << "\t""pcglite::pcg64" << std::endl;
    std::cout << wtl::diff_rusage<std::micro>([&]() {
      lambda_random(pcg32{});
    }, 3) << "\t""pcg32" << std::endl;
    std::cout << wtl::diff_rusage<std::micro>([&]() {
      lambda_random(pcg64{});
    }, 3) << "\t""pcg64" << std::endl;
    std::cout << wtl::mean(v) << std::endl;
}

inline void random_binomial() {
    pcglite::pcg64 rng64{};
    constexpr size_t n = 256u * 1024u;
    int trash = 0;
    std::binomial_distribution binom01(10000, 0.05);
    std::binomial_distribution binom03(10000, 0.3);
    std::binomial_distribution binom05(10000, 0.5);
    std::binomial_distribution binom07(10000, 0.7);
    std::binomial_distribution binom09(10000, 0.95);
    std::cout << wtl::diff_rusage([&](){
        for (size_t i=0; i<n; ++i) { trash += binom01(rng64); }
    }, 3u) << "\t""binom01" << std::endl;;
    std::cout << wtl::diff_rusage([&](){
        for (size_t i=0; i<n; ++i) { trash += binom03(rng64); }
    }, 3u) << "\t""binom03" << std::endl;;
    std::cout << wtl::diff_rusage([&](){
        for (size_t i=0; i<n; ++i) { trash += binom05(rng64); }
    }, 3u) << "\t""binom05" << std::endl;;
    std::cout << wtl::diff_rusage([&](){
        for (size_t i=0; i<n; ++i) { trash += binom07(rng64); }
    }, 3u) << "\t""binom07" << std::endl;;
    std::cout << wtl::diff_rusage([&](){
        for (size_t i=0; i<n; ++i) { trash += binom09(rng64); }
    }, 3u) << "\t""binom09" << std::endl;;
    std::cerr << trash << std::endl;
}

int main() {
    random_uint32();
    random_canonical();
    random_sample();
    random_engine();
    random_binomial();
}
