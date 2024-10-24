#include <cstdint>
#include <iostream>

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
    static_assert(       (~u) == 4294967290u, ""); // NOTE: implicit ~u is not 8-bit
    static_assert(       (-u) == 4294967291u, ""); // NOTE: implicit -u is not 8-bit
    constexpr int8_t i = 5;
    static_assert((~i) == int8_t(0b11111010), ""); //  -6
    static_assert((-i) == int8_t(0b11111011), ""); //  -5
    static_assert((~i) ==                -6, "");  // NOTE: implicit ~i is not 8-bit
    static_assert((-i) ==                -5, "");  // NOTE: implicit -i is not 8-bit
    static_assert(250  ==        0b11111010, "");  // NOTE: implicit int is not 8-bit
}

inline void right_shift() {
    constexpr uint8_t u = 0b10000000;
    constexpr int8_t  i = 0b10000000;
    static_assert((u >> 2) == uint8_t(0b00100000), "");
    static_assert((i >> 2) ==  int8_t(0b11100000), ""); // undefined?
}

int main() {
    rotate();
    uint_int();
    operation();
    right_shift();
    return 0;
}
