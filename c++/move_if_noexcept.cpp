#include <iostream>
#include <vector>
#include <type_traits>
#include <typeinfo>

class MoveImplicit {
  public:
    MoveImplicit() {
        std::cout << "ctor\n";
    }
    ~MoveImplicit() = default;
    MoveImplicit(const MoveImplicit&) {
        std::cout << "copied!\n";
    }
    // copied by implicit move ctor;
};

class MoveNaive {
  public:
    MoveNaive() {
        std::cout << "ctor\n";
    }
    ~MoveNaive() = default;
    MoveNaive(const MoveNaive&) {
        std::cout << "copied!\n";
    }
    MoveNaive(MoveNaive&&) {
        std::cout << "moved\n";
    }
    // copied by std::move_if_noexcept(), e.g., in std::vector reallocation
};

class MoveNoExcept {
  public:
    MoveNoExcept() noexcept {
        std::cout << "ctor\n";
    }
    ~MoveNoExcept() noexcept = default;
    MoveNoExcept(const MoveNoExcept&) noexcept {
        std::cout << "copied!\n";
    }
    MoveNoExcept(MoveNoExcept&&) noexcept {
        std::cout << "moved\n";
    }
};

static_assert(!std::is_nothrow_move_constructible<MoveImplicit>{}, "");
static_assert(!std::is_nothrow_move_constructible<MoveNaive>{}, "");
static_assert( std::is_nothrow_move_constructible<MoveNoExcept>{}, "");

template <class T>
void test() {
    std::cout << "######## " << typeid(T).name() << " ########\n";
    std::vector<T> v;
    v.push_back(T{});
    v.emplace_back();
    v.resize(3u);
}

int main() {
    test<MoveImplicit>();
    test<MoveNaive>();
    test<MoveNoExcept>();
    return 0;
}
