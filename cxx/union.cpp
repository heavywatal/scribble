#include <cstdint>
#include <iostream>
#include <valarray>
#include <bitset>

union bits128_t {
    int64_t as_int64_t[2];
    int32_t as_int32_t[4];
    long double as_long_double;
    std::bitset<128> as_bitset() const {
        const int64_t* const p = as_int64_t;
        std::bitset<128> bs(*(p + 1));
        bs <<= 64;
        return bs |= std::bitset<128>(*p);
    }

    bits128_t(int32_t x, int32_t y, int32_t z, int32_t t=0u): as_int32_t{x, y, z, t} {}
    bits128_t(int64_t x, int64_t y): as_int64_t{x, y} {}
    bits128_t(long double x): as_long_double{x} {}
    bits128_t(const std::valarray<int>& v): as_int32_t{v[0u], v[1u], v[2u], v[3u]} {}
};

template<typename T> inline
std::bitset<8 * sizeof(T)> bin(const T* const x) {
    return std::bitset<8 * sizeof(T)>(*x);
}

int main() {
    const std::valarray<int> va{1, 3, 7, 15};
    std::cout << va[0] << " " << va[1] << " "
              << va[2] << " " << va[3] << std::endl;
    const bits128_t b(va);
    const int64_t* const p = b.as_int64_t;
    std::cout << bin(p) << "\n"
              << bin(p + 1) << std::endl;
    std::cout << b.as_long_double << std::endl;
    std::cout << b.as_bitset() << std::endl;

    const bits128_t ld(1.0L);
    std::cout << ld.as_long_double << std::endl;
    std::cout << ld.as_bitset() << std::endl;
    return 0;
}
