#include <cstdint>
#include <cmath>
#include <limits>
#include <iostream>

inline void sizeof_() {
    std::cout << "sizeof(T) ----------------\n";
    std::cout << "char          " << sizeof(char) << "\n";
    std::cout << "bool          " << sizeof(bool) << "\n";
    std::cout << "int           " << sizeof(int) << "\n";
    std::cout << "long          " << sizeof(long) << "\n";
    std::cout << "long long     " << sizeof(long long) << "\n";
    std::cout << "double        " << sizeof(double) << "\n";
    std::cout << "long double   " << sizeof(long double) << "\n";
    std::cout << "uint_fast8_t  " << sizeof(uint_fast8_t) << "\n";
    std::cout << "uint_fast16_t " << sizeof(uint_fast16_t) << "\n";
    std::cout << "uint_fast32_t " << sizeof(uint_fast32_t) << "\n";
    std::cout << "uint_fast64_t " << sizeof(uint_fast64_t) << "\n";
    std::cout << "size_t        " << sizeof(size_t) << "\n";
}

template <class T> inline
void common() {
    std::cout << "max() " << std::numeric_limits<T>::max() << "\n";
    std::cout << "min() " << std::numeric_limits<T>::min() << "\n";
    std::cout << "lowest() " << std::numeric_limits<T>::lowest() << "\n";
    std::cout << "digits " << std::numeric_limits<T>::digits << "\n";
    std::cout << "digits10 " << std::numeric_limits<T>::digits10 << "\n";
    std::cout << "log10(max()) " << std::log10(std::numeric_limits<T>::max()) << "\n";
}

template <class T> inline
void floating() {
    std::cout << "max_digits10 " << std::numeric_limits<T>::max_digits10 << "\n";
    std::cout << "epsilon() " << std::numeric_limits<T>::epsilon() << "\n";
    std::cout << "max_exponent " << std::numeric_limits<T>::max_exponent << "\n";
    std::cout << "max_exponent10 " << std::numeric_limits<T>::max_exponent10 << "\n";
    std::cout << "min_exponent " << std::numeric_limits<T>::min_exponent << "\n";
    std::cout << "min_exponent10 " << std::numeric_limits<T>::min_exponent10 << "\n";
}

inline void numeric_limits() {
    std::cout << "std::numeric_limits<int> ----------------\n";
    common<int>();
    std::cout << "std::numeric_limits<size_t> ----------------\n";
    common<size_t>();
    std::cout << "std::numeric_limits<double> ----------------\n";
    common<double>();
    floating<double>();
}

int main() {
    sizeof_();
    numeric_limits();
    return 0;
}
