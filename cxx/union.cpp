#include <fmt/base.h>
#include <fmt/ranges.h>
#include <fmt/std.h>

#include <cstdint>
#include <valarray>
#include <bitset>

union bits128_t {
    uint64_t as_uint64_t[2];
    uint32_t as_uint32_t[4];
    long double as_long_double; // useful only if quadruple-precision binary128
    std::bitset<128> as_bitset() const {
        const uint64_t* const p = as_uint64_t;
        std::bitset<128> bs(*(p + 1));
        bs <<= 64;
        return bs |= std::bitset<128>(*p);
    }

    bits128_t(uint32_t x, uint32_t y, uint32_t z, uint32_t t=0u): as_uint32_t{x, y, z, t} {}
    bits128_t(uint64_t x, uint64_t y): as_uint64_t{x, y} {}
    bits128_t(long double x): as_long_double{x} {}
    bits128_t(const std::valarray<unsigned>& v): as_uint32_t{v[0u], v[1u], v[2u], v[3u]} {}
    bits128_t(const std::bitset<128>& bs): as_uint64_t{(bs << 64 >> 64).to_ullong(), (bs >> 64).to_ullong()} {}
};

template<typename T> inline
std::bitset<8 * sizeof(T)> bin(const T* const x) {
    return std::bitset<8 * sizeof(T)>(*x);
}

int main() {
    const std::valarray<unsigned> va{1u, 3u, 7u, 15u};
    fmt::println("valarray: {}", va);
    const bits128_t b(va);
    const uint64_t* const p = b.as_uint64_t;
    fmt::println("lower64bits: {}", bin(p));
    fmt::println("upper64bits: {}", bin(p + 1));
    fmt::println("bitset<128>: {}", b.as_bitset());
    fmt::println("long double: {}", b.as_long_double);

    fmt::println("sizeof(bits128_t): {}", sizeof(bits128_t));
    fmt::println("sizeof(long double): {}", sizeof(long double));
    // 16 bytes
    // - 16 bytes quadruple-precision binary128: not so common
    // - 80 bits extended-precision + 6 bytes padding on x86_64
    // 8 bytes
    // - double-precision on Darwin arm64
    const bits128_t ld(0.0L);
    fmt::println("as_long_double: {}", ld.as_long_double);
    fmt::println("as_long_double: {}", bits128_t{ld.as_bitset()}.as_long_double);
    fmt::println("{}", ld.as_bitset());
    fmt::println("{}", bits128_t{ld.as_bitset()}.as_bitset());
    // round-trip may fail depending on the long double format
    return 0;
}
