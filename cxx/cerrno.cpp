#include <cerrno>
#include <cstring>
#include <cstdio>
#include <string>
#include <iostream>
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
        std::cout << filename << ": " << std::strerror(errno) << std::endl;
        std::cout << wtl::strerror(filename) << std::endl;
        std::perror(filename.c_str());
    }
    return 0;
}
