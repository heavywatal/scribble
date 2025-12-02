#include <fmt/base.h>

#include <cstddef>
#include <cmath>
#include <limits>

template <class T> inline
void common() {
    fmt::println("max() {}", std::numeric_limits<T>::max());
    fmt::println("min() {}", std::numeric_limits<T>::min());
    fmt::println("lowest() {}", std::numeric_limits<T>::lowest());
    fmt::println("digits {}", std::numeric_limits<T>::digits);
    fmt::println("digits10 {}", std::numeric_limits<T>::digits10);
    fmt::println("log10(max()) {}", std::log10(std::numeric_limits<T>::max()));
}

template <class T> inline
void floating() {
    fmt::println("max_digits10 {}", std::numeric_limits<T>::max_digits10);
    fmt::println("epsilon() {}", std::numeric_limits<T>::epsilon());
    fmt::println("max_exponent {}", std::numeric_limits<T>::max_exponent);
    fmt::println("max_exponent10 {}", std::numeric_limits<T>::max_exponent10);
    fmt::println("min_exponent {}", std::numeric_limits<T>::min_exponent);
    fmt::println("min_exponent10 {}", std::numeric_limits<T>::min_exponent10);
}

int main() {
    fmt::println("## std::numeric_limits<int>");
    common<int>();
    fmt::println("## std::numeric_limits<unsigned>");
    common<unsigned>();
    fmt::println("## std::numeric_limits<ptrdiff_t>");
    common<ptrdiff_t>();
    fmt::println("## std::numeric_limits<size_t>");
    common<size_t>();
    fmt::println("## std::numeric_limits<double>");
    common<double>();
    floating<double>();
    if constexpr (sizeof(long double) > sizeof(double)) {
        fmt::println("## std::numeric_limits<long double>");
        common<long double>();
        floating<long double>();
    }
    return 0;
}
