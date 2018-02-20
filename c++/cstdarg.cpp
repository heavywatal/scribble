#include <cstdarg>
#include <string>
#include <iostream>

inline std::string strprintf(const char* const format, ...) {
    va_list args;
    std::string buffer;
    va_start(args, format);
    const int length = std::vsnprintf(nullptr, 0, format, args) ;
    va_end(args);
    if (length < 0) throw std::runtime_error(format);
    buffer.resize(static_cast<size_t>(length) + 1u);
    va_start(args, format);
    const int result = std::vsnprintf(&buffer[0], static_cast<size_t>(length) + 1u, format, args);
    va_end(args);
    if (result < 0) throw std::runtime_error(format);
    buffer.pop_back();
    return buffer;
}

int main() {
    auto s = strprintf("Who am I? %d!", 24601);
    std::cout << s << std::endl;
    return 0;
}
