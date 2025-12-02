#include <fmt/base.h>

#include <vector>
#include <type_traits>
#include <typeinfo>

class MoveImplicit {
  public:
    MoveImplicit() {
        fmt::println("ctor");
    }
    ~MoveImplicit() = default;
    MoveImplicit(const MoveImplicit&) {
        fmt::println("copied!");
    }
    // copied by implicit move ctor;
};

class MoveNaive {
  public:
    MoveNaive() {
        fmt::println("ctor");
    }
    ~MoveNaive() = default;
    MoveNaive(const MoveNaive&) {
        fmt::println("copied!");
    }
    MoveNaive(MoveNaive&&) {
        fmt::println("moved");
    }
    // copied by std::move_if_noexcept(), e.g., in std::vector reallocation
};

class MoveNoExcept {
  public:
    MoveNoExcept() noexcept {
        fmt::println("ctor");
    }
    ~MoveNoExcept() noexcept = default;
    MoveNoExcept(const MoveNoExcept&) noexcept {
        fmt::println("copied!");
    }
    MoveNoExcept(MoveNoExcept&&) noexcept {
        fmt::println("moved");
    }
};

static_assert(!std::is_nothrow_move_constructible<MoveImplicit>{}, "");
static_assert(!std::is_nothrow_move_constructible<MoveNaive>{}, "");
static_assert( std::is_nothrow_move_constructible<MoveNoExcept>{}, "");

template <class T>
void test() {
    fmt::println("## {}", typeid(T).name());
    std::vector<T> v;
    fmt::println("### push_back");
    v.push_back(T{});
    fmt::println("### emplace_back");
    v.emplace_back();
    fmt::println("### resize");
    v.resize(3u);
}

int main() {
    test<MoveImplicit>();
    test<MoveNaive>();
    test<MoveNoExcept>();
    return 0;
}
