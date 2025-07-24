#include <unordered_map>
#include <iostream>

int main() {
    // load_factor() == size() / bucket_count();
    std::unordered_map<int, double> dict;
    std::cout << "bucket_count: " << dict.bucket_count()
              << " / " << dict.max_bucket_count() << std::endl;
    std::cout << "load_factor: " << dict.load_factor()
              << " / " << dict.max_load_factor() << std::endl;
    dict.reserve(1000);
    std::cout << "bucket_count: " << dict.bucket_count()
              << " / " << dict.max_bucket_count() << std::endl;
    std::cout << "load_factor: " << dict.load_factor()
              << " / " << dict.max_load_factor() << std::endl;
    for (size_t i=0; i<1000u; ++i) {
        dict.emplace(i, static_cast<double>(i) * 0.1);
    }
    std::cout << "bucket_count: " << dict.bucket_count()
              << " / " << dict.max_bucket_count() << std::endl;
    std::cout << "load_factor: " << dict.load_factor()
              << " / " << dict.max_load_factor() << std::endl;
    dict.reserve(10000);
    std::cout << "bucket_count: " << dict.bucket_count()
              << " / " << dict.max_bucket_count() << std::endl;
    std::cout << "load_factor: " << dict.load_factor()
              << " / " << dict.max_load_factor() << std::endl;
    return 0;
}
