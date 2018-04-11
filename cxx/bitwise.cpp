#include <wtl/exception.hpp>

#include <cstdint>
#include <iostream>

inline void uint_int() {
    WTL_ASSERT(uint8_t(0b00000000) ==    0u);
    WTL_ASSERT(uint8_t(0b10000000) ==  128u);
    WTL_ASSERT(uint8_t(0b11111111) ==  255u);
    WTL_ASSERT( int8_t(0b01111111) ==  127);
    WTL_ASSERT( int8_t(0b10000000) == -128);
    WTL_ASSERT( int8_t(0b10000001) == -127);
    WTL_ASSERT( int8_t(0b10000010) == -126);
    WTL_ASSERT( int8_t(0b11111101) ==   -3);
    WTL_ASSERT( int8_t(0b11111110) ==   -2);
    WTL_ASSERT( int8_t(0b11111111) ==   -1);
}

inline void operation() {
    uint8_t u = 5u;
    WTL_ASSERT( u          == 0b00000101);
    WTL_ASSERT((u & 1)     == 0b00000001);  //   1u
    WTL_ASSERT((u | 2)     == 0b00000111);  //   7u
    WTL_ASSERT((u ^ 3)     == 0b00000110);  //   6u
    WTL_ASSERT((u << 1)    == 0b00001010);  //  10u
    WTL_ASSERT((u >> 1)    == 0b00000010);  //   2u
    WTL_ASSERT(uint8_t(~u) == 0b11111010u); // 250u
    WTL_ASSERT(uint8_t(-u) == 0b11111011u); // 251u
    WTL_ASSERT(       (~u) == 4294967290u); // NOTE: implicit ~u is not 8-bit
    WTL_ASSERT(       (-u) == 4294967291u); // NOTE: implicit -u is not 8-bit
    int8_t i = 5;
    WTL_ASSERT((~i) == int8_t(0b11111010)); //  -6
    WTL_ASSERT((-i) == int8_t(0b11111011)); //  -5
    WTL_ASSERT((~i) ==                -6);  // NOTE: implicit ~i is not 8-bit
    WTL_ASSERT((-i) ==                -5);  // NOTE: implicit -i is not 8-bit
    WTL_ASSERT(250  ==        0b11111010);  // NOTE: implicit int is not 8-bit
}

inline void right_shift() {
    uint8_t u = 0b10000000;
    int8_t  i = 0b10000000;
    WTL_ASSERT((u >> 2) == uint8_t(0b00100000));
    WTL_ASSERT((i >> 2) ==  int8_t(0b11100000)); // undefined?
}

int main() {
    uint_int();
    operation();
    right_shift();
    return 0;
}
