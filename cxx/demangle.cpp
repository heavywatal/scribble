#include <fmt/base.h>

#include <cxxabi.h>
#include <string>

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
    fmt::println("{}", typestr(i));
    fmt::println("{}", typestr(u));
    fmt::println("{}", typestr(d));
}
