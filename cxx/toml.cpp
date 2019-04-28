#include <cpptoml.h>
#include <iostream>

int main() {
    auto obj = cpptoml::parse_file("/Users/watal/git/offline/config.toml");
    std::cout << *obj << std::endl;
    return 0;
}
