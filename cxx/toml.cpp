#include <toml.hpp>
#include <iostream>

int main() {
    std::string file = "/Users/watal/git/offline/config/_default/hugo.toml";
    toml::value obj = toml::parse(file);
    std::cout << obj << std::endl;
    return 0;
}
