#include <fmt/base.h>

#include <cerrno>
#include <cstring>
#include <cstdio>
#include <string>
#include <fstream>

namespace wtl {

inline std::string strerror(const std::string& message="") {
    if (message.empty()) {
        return std::strerror(errno);
    } else {
        return message + ": " + std::strerror(errno);
    }
}

}

int main() {
    std::string filename("noexist.txt");
    std::ifstream ifs(filename);
    if (ifs.fail() || ifs.bad()) {
        fmt::println("{}: {}", filename, std::strerror(errno));
        fmt::println("{}", wtl::strerror(filename));
        std::perror(filename.c_str());
    }
    return 0;
}
