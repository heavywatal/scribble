#include <cmath>
#include <limits>
#include <iostream>

int main() {
    std::cout << std::numeric_limits<size_t>::max() << std::endl;
    std::cout << std::log2(std::numeric_limits<size_t>::max()) << std::endl;
    std::cout << std::log10(std::numeric_limits<size_t>::max()) << std::endl;
}
