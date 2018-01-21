#include <boost/math/distributions/normal.hpp>

#include <iostream>

namespace bmath = boost::math;

inline double normal_cdf(const double x, const double mean, const double sd) {
    if (sd == 0.0) {return 0.0;}
    return bmath::cdf(bmath::normal(mean, sd), x);
}

inline double normal_ccdf(const double x, const double mean, const double sd) {
    if (sd == 0.0) {return 0.0;}
    return bmath::cdf(bmath::complement(bmath::normal(mean, sd), x));
}

int main() {
    std::cout << normal_cdf(0.0, 0.0, 1.0) << std::endl;
    std::cout << normal_cdf(0.0, 0.0, 1.0) << std::endl;
    return 0;
}
