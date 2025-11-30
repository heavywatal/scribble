#include <unordered_map>

#include <fmt/base.h>

int main() {
    // load_factor() == size() / bucket_count();
    std::unordered_map<int, double> dict;
    fmt::println("bucket_count: {} / {}", dict.bucket_count(), dict.max_bucket_count());
    fmt::println("load_factor: {} / {}", dict.load_factor(), dict.max_load_factor());
    dict.reserve(1000);
    fmt::println("bucket_count: {} / {}", dict.bucket_count(), dict.max_bucket_count());
    fmt::println("load_factor: {} / {}", dict.load_factor(), dict.max_load_factor());
    for (int i=0; i<1000; ++i) {
        dict.emplace(i, static_cast<double>(i) * 0.1);
    }
    fmt::println("bucket_count: {} / {}", dict.bucket_count(), dict.max_bucket_count());
    fmt::println("load_factor: {} / {}", dict.load_factor(), dict.max_load_factor());
    dict.reserve(10000);
    fmt::println("bucket_count: {} / {}", dict.bucket_count(), dict.max_bucket_count());
    fmt::println("load_factor: {} / {}", dict.load_factor(), dict.max_load_factor());
    return 0;
}
