#include <toml++/toml.hpp>
#include <fmt/base.h>
#include <fmt/ostream.h>

#include <filesystem>
#include <cstdlib>

template <> struct fmt::formatter<toml::table>: ostream_formatter{};

int main() {
    const std::filesystem::path home(std::getenv("HOME"));
    const auto file = home / ".config" / "ruff" / "ruff.toml";
    const auto obj = toml::parse_file(file.string());
    fmt::println("{}", obj);
    return 0;
}
