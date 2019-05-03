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
    explicit DefaultCtorDefaultPlus(int x): _x(x) {_x += 0;}
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
    void suppress_warnings() {_x += 0;}
};

class NonTrivMember {
  private:
    std::vector<int> v_;
};

// scalars and pointers are trivial; reference and containers are not
static_assert( std::is_trivial<int>{}, "");
static_assert( std::is_trivial<int*>{}, "");
static_assert(!std::is_trivial<int&>{}, "");
static_assert(!std::is_trivial<std::vector<int>>{}, "");

// has no non-traivial member && has trivial default ctor/dtor
static_assert( std::is_trivially_default_constructible<Empty>{}, "");
static_assert( std::is_trivially_default_constructible<DefaultCtorDefault>{}, "");
static_assert( std::is_trivially_default_constructible<DefaultCtorDefaultPlus>{}, "");
static_assert(!std::is_trivially_default_constructible<DefaultCtor>{}, "");
static_assert( std::is_trivially_default_constructible<CopyCtorDefault>{}, "");
static_assert( std::is_trivially_default_constructible<CopyCtor>{}, "");
static_assert( std::is_trivially_default_constructible<MoveCtorDefault>{}, "");
static_assert( std::is_trivially_default_constructible<MoveCtor>{}, "");
static_assert( std::is_trivially_default_constructible<DtorDefault>{}, "");
static_assert(!std::is_trivially_default_constructible<Dtor>{}, "");
static_assert(!std::is_trivially_default_constructible<MemberInit>{}, "");
static_assert(!std::is_trivially_default_constructible<NonTrivMember>{}, "");

// std::memcpy()-able: trivial copy, move, dtor
static_assert( std::is_trivially_copyable<Empty>{}, "");
static_assert( std::is_trivially_copyable<DefaultCtorDefault>{}, "");
static_assert( std::is_trivially_copyable<DefaultCtorDefaultPlus>{}, "");
static_assert( std::is_trivially_copyable<DefaultCtor>{}, "");
static_assert( std::is_trivially_copyable<CopyCtorDefault>{}, "");
static_assert(!std::is_trivially_copyable<CopyCtor>{}, "");
static_assert( std::is_trivially_copyable<MoveCtorDefault>{}, "");
static_assert(!std::is_trivially_copyable<MoveCtor>{}, "");
static_assert( std::is_trivially_copyable<DtorDefault>{}, "");
static_assert(!std::is_trivially_copyable<Dtor>{}, "");
static_assert( std::is_trivially_copyable<MemberInit>{}, "");
static_assert(!std::is_trivially_copyable<NonTrivMember>{}, "");

// is_trivially_default_constructible && is_trivially_copyable
static_assert( std::is_trivial<Empty>{}, "");
static_assert( std::is_trivial<DefaultCtorDefault>{}, "");
static_assert( std::is_trivial<DefaultCtorDefaultPlus>{}, "");
static_assert(!std::is_trivial<DefaultCtor>{}, "");
static_assert( std::is_trivial<CopyCtorDefault>{}, "");
static_assert(!std::is_trivial<CopyCtor>{}, "");
static_assert( std::is_trivial<MoveCtorDefault>{}, "");
static_assert(!std::is_trivial<MoveCtor>{}, "");
static_assert( std::is_trivial<DtorDefault>{}, "");
static_assert(!std::is_trivial<Dtor>{}, "");
static_assert(!std::is_trivial<MemberInit>{}, "");
static_assert(!std::is_trivial<NonTrivMember>{}, "");

int main() {
    return 0;
}
