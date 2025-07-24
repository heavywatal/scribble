#include <filesystem>
#include <iostream>
#include <cstdlib>

#include <toml++/toml.hpp>

int main() {
    const std::filesystem::path home(std::getenv("HOME"));
    const auto file = home / ".config" / "ruff" / "ruff.toml";
    auto obj = toml::parse_file(file.string());
    std::cout << obj << std::endl;
    return 0;
}
