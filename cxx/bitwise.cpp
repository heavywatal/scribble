#include <cstdint>
#include <limits>
#include <stdexcept>

template <class T> inline
constexpr T urotl(T x, unsigned s) noexcept {
    constexpr unsigned dig = std::numeric_limits<T>::digits;
    return (x << (s % dig)) | (x >> ((-s) % dig));
}

template <class T> inline
constexpr T urotr(T x, unsigned s) noexcept {
    constexpr unsigned dig = std::numeric_limits<T>::digits;
    return (x >> (s % dig)) | (x << ((-s) % dig));
}

template <class T> inline
constexpr T rotr(T x, int s) noexcept {
    constexpr unsigned dig = std::numeric_limits<T>::digits;
    if (s == 0)
      return x;
    if (s < 0) {
      return (x << ((-s) % dig)) | (x >> (s % dig));
    }
    return (x >> (s % dig)) | (x << ((-s) % dig));
}

template <class T> inline
constexpr T rotl(T x, int s) noexcept {
    return rotr(x, -s);
}

inline void rotate() {
    constexpr uint32_t u32 = 0b10100000'00000000'00000000'00000101u;
    static_assert(u32 % 8u == (u32 & 7u), "");
    static_assert(urotr(u32,  1u) == 0b11010000'00000000'00000000'00000010u, "");
    static_assert(urotr(u32,  2u) == 0b01101000'00000000'00000000'00000001u, "");
    static_assert(urotr(u32,  0u) == u32, "");
    static_assert(urotr(u32, 32u) == u32, "");
    static_assert(urotr(u32, -1 ) == 0b01000000'00000000'00000000'00001011u, "");
    static_assert(urotr(u32, -2 ) == 0b1000000'00000000'00000000'000010110u, "");
    static_assert( rotr(u32,  1 ) == 0b11010000'00000000'00000000'00000010u, "");
    static_assert( rotr(u32,  2 ) == 0b011010000'00000000'00000000'0000001u, "");
    static_assert( rotr(u32,  0 ) == u32, "");
    static_assert( rotr(u32, 32 ) == u32, "");
    static_assert( rotr(u32, -1 ) == 0b01000000'00000000'00000000'00001011u, "");
    static_assert( rotr(u32, -2 ) == 0b1000000'00000000'00000000'000010110u, "");
}

inline void uint_int() {
    static_assert(       0b00000000u ==    0u, "");
    static_assert(       0b10000000u ==  128u, "");
    static_assert(       0b11111111u ==  255u, "");
    static_assert(       0b01111111  ==  127, "");
    static_assert(       0b10000000  ==  128, "");
    static_assert(int8_t(0b10000000) == -128, "");
    static_assert(int8_t(0b10000001) == -127, "");
    static_assert(int8_t(0b10000010) == -126, "");
    static_assert(int8_t(0b11111101) ==   -3, "");
    static_assert(int8_t(0b11111110) ==   -2, "");
    static_assert(int8_t(0b11111111) ==   -1, "");
    static_assert(0b11111111u == uint8_t(-1u), "");
}

inline void operation() {
    constexpr uint8_t u = 5u;
    static_assert( u          == 0b00000101, "");
    static_assert((u & 1)     == 0b00000001, "");  //   1u
    static_assert((u | 2)     == 0b00000111, "");  //   7u
    static_assert((u ^ 3)     == 0b00000110, "");  //   6u
    static_assert((u << 1)    == 0b00001010, "");  //  10u
    static_assert((u >> 1)    == 0b00000010, "");  //   2u
    static_assert(uint8_t(~u) == 0b11111010u, ""); // 250u
    static_assert(uint8_t(-u) == 0b11111011u, ""); // 251u
#ifdef __clang__
    static_assert((~u) == 4294967290u, ""); // NOTE: unsigned, not 8-bit
    static_assert((-u) == 4294967291u, ""); // NOTE: unsigned, not 8-bit
#else
    static_assert((~u) == -6 , ""); // NOTE: signed, not 8-bit
    static_assert((-u) == -5 , ""); // NOTE: signed, not 8-bit
#endif
    constexpr int8_t i = 5;
    static_assert((~i) == int8_t(0b11111010), ""); //  -6
    static_assert((-i) == int8_t(0b11111011), ""); //  -5
    static_assert((~i) ==                -6, "");  // NOTE: implicit ~i is not 8-bit
    static_assert((-i) ==                -5, "");  // NOTE: implicit -i is not 8-bit
    static_assert(250  ==        0b11111010, "");  // NOTE: implicit int is not 8-bit
}

inline void right_shift() {
    constexpr uint8_t u = 0b10000000;
#ifdef __clang__
    constexpr int8_t  i = 0b10000000;
#else
    constexpr auto  i = static_cast<int8_t>(0b10000000);
#endif
    static_assert((u >> 2) == uint8_t(0b00100000), "");
    static_assert((i >> 2) ==  int8_t(0b11100000), ""); // undefined?
}

inline void runtime_assert(bool cond) {
   if (!cond) throw std::logic_error("");
}

union bits64_t {
    uint64_t as_uint64_t;
    uint32_t as_uint32_t[2];
    double as_double;

    bits64_t(uint64_t x): as_uint64_t{x} {}
    bits64_t(uint32_t x, uint32_t y): as_uint32_t{x, y} {}

    // Use only 52 bits
    double as_canonical() const {
        return bits64_t{as_uint64_t}.as_canonical_inplace().as_double;
    }

    constexpr bits64_t& as_canonical_inplace() {
        as_uint64_t &= 0x3fff'ffff'ffff'ffffu;
        as_uint64_t |= 0x3ff0'0000'0000'0000u;
        as_double -= 1.0;
        return *this;
    }
};

inline void ieee754_double() {
    bits64_t min_0x3ff{uint64_t{0x3ff0'0000'0000'0000u}}; // 1.0
    bits64_t max_0x3ff{uint64_t{0x3fff'ffff'ffff'ffffu}}; // 1.999...
    runtime_assert(min_0x3ff.as_double == 1.0);
    runtime_assert(max_0x3ff.as_double < 2.0);
    runtime_assert((min_0x3ff.as_double - 1.0) == 0.0);
    runtime_assert((max_0x3ff.as_double - 1.0) < 1.0);
    runtime_assert(bits64_t{0u}.as_canonical() == 0.0);
    runtime_assert(bits64_t{~0u}.as_canonical() < 1.0);
}

int main() {
    rotate();
    uint_int();
    operation();
    right_shift();
    ieee754_double();
    return 0;
}
