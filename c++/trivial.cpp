#include <type_traits>
#include <vector>

class Empty {};

class DefaultCtorDefault {
  public:
    DefaultCtorDefault() = default;
};

class DefaultCtorDefaultPlus {
  public:
    DefaultCtorDefaultPlus() = default;
    explicit DefaultCtorDefaultPlus(int x): _x(x) {}
  private:
    int _x;
};

class DefaultCtor {
  public:
    DefaultCtor() {};
};

class CopyCtorDefault {
  public:
    CopyCtorDefault() = default;
    CopyCtorDefault(const CopyCtorDefault&) = default;
};

class CopyCtor {
  public:
    CopyCtor() = default;
    CopyCtor(const CopyCtor&) {};
};

class MoveCtorDefault {
  public:
    MoveCtorDefault() = default;
    MoveCtorDefault(MoveCtorDefault&&) = default;
};

class MoveCtor {
  public:
    MoveCtor() = default;
    MoveCtor(MoveCtor&&) {};
};

class DtorDefault {
  public:
    DtorDefault() = default;
    ~DtorDefault() = default;
};

class Dtor {
  public:
    Dtor() = default;
    ~Dtor() {};
};

class MemberInit {
  private:
    int _x = 0;
};

class NonTrivMember {
  private:
    std::vector<int> v_;
};

// scalars and pointers are trivial; reference and containers are not
static_assert( std::is_trivial<int>::value, "");
static_assert( std::is_trivial<int*>::value, "");
static_assert(!std::is_trivial<int&>::value, "");
static_assert(!std::is_trivial<std::vector<int>>::value, "");

// has no non-traivial member && has trivial default ctor/dtor
static_assert( std::is_trivially_default_constructible<Empty>::value, "");
static_assert( std::is_trivially_default_constructible<DefaultCtorDefault>::value, "");
static_assert( std::is_trivially_default_constructible<DefaultCtorDefaultPlus>::value, "");
static_assert(!std::is_trivially_default_constructible<DefaultCtor>::value, "");
static_assert( std::is_trivially_default_constructible<CopyCtorDefault>::value, "");
static_assert( std::is_trivially_default_constructible<CopyCtor>::value, "");
static_assert( std::is_trivially_default_constructible<MoveCtorDefault>::value, "");
static_assert( std::is_trivially_default_constructible<MoveCtor>::value, "");
static_assert( std::is_trivially_default_constructible<DtorDefault>::value, "");
static_assert(!std::is_trivially_default_constructible<Dtor>::value, "");
static_assert(!std::is_trivially_default_constructible<MemberInit>::value, "");
static_assert(!std::is_trivially_default_constructible<NonTrivMember>::value, "");

// std::memcpy()-able: trivial copy, move, dtor
static_assert( std::is_trivially_copyable<Empty>::value, "");
static_assert( std::is_trivially_copyable<DefaultCtorDefault>::value, "");
static_assert( std::is_trivially_copyable<DefaultCtorDefaultPlus>::value, "");
static_assert( std::is_trivially_copyable<DefaultCtor>::value, "");
static_assert( std::is_trivially_copyable<CopyCtorDefault>::value, "");
static_assert(!std::is_trivially_copyable<CopyCtor>::value, "");
static_assert( std::is_trivially_copyable<MoveCtorDefault>::value, "");
static_assert(!std::is_trivially_copyable<MoveCtor>::value, "");
static_assert( std::is_trivially_copyable<DtorDefault>::value, "");
static_assert(!std::is_trivially_copyable<Dtor>::value, "");
static_assert( std::is_trivially_copyable<MemberInit>::value, "");
static_assert(!std::is_trivially_copyable<NonTrivMember>::value, "");

// is_trivially_default_constructible && is_trivially_copyable
static_assert( std::is_trivial<Empty>::value, "");
static_assert( std::is_trivial<DefaultCtorDefault>::value, "");
static_assert( std::is_trivial<DefaultCtorDefaultPlus>::value, "");
static_assert(!std::is_trivial<DefaultCtor>::value, "");
static_assert( std::is_trivial<CopyCtorDefault>::value, "");
static_assert(!std::is_trivial<CopyCtor>::value, "");
static_assert( std::is_trivial<MoveCtorDefault>::value, "");
static_assert(!std::is_trivial<MoveCtor>::value, "");
static_assert( std::is_trivial<DtorDefault>::value, "");
static_assert(!std::is_trivial<Dtor>::value, "");
static_assert(!std::is_trivial<MemberInit>::value, "");
static_assert(!std::is_trivial<NonTrivMember>::value, "");

int main() {
    return 0;
}
