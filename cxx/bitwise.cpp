#include <cstdint>
#include <iostream>

inline void uint_int() {
    static_assert(uint8_t(0b00000000) ==    0u, "");
    static_assert(uint8_t(0b10000000) ==  128u, "");
    static_assert(uint8_t(0b11111111) ==  255u, "");
    static_assert( int8_t(0b01111111) ==  127, "");
    static_assert( int8_t(0b10000000) == -128, "");
    static_assert( int8_t(0b10000001) == -127, "");
    static_assert( int8_t(0b10000010) == -126, "");
    static_assert( int8_t(0b11111101) ==   -3, "");
    static_assert( int8_t(0b11111110) ==   -2, "");
    static_assert( int8_t(0b11111111) ==   -1, "");
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
    uint_int();
    operation();
    right_shift();
    return 0;
}
