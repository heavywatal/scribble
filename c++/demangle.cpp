#include <cxxabi.h>
#include <string>
#include <iostream>

inline std::string demangle(const char * type_info_name) {
    int status(0);
    return std::string(abi::__cxa_demangle(type_info_name, 0, 0, &status));
}

template <class T>
inline std::string typestr(const T& x) {
    return demangle(typeid(x).name());
}

int main() {
    int i = 0;
    unsigned int u = 0;
    double d = 0.0;
    std::cout << typestr(i) << std::endl;
    std::cout << typestr(u) << std::endl;
    std::cout << typestr(d) << std::endl;
}
