#include <fmt/base.h>

#include <vector>

class Vector {
  public:
    Vector() = delete;
    Vector(size_t n, int x) noexcept: vec_(n, x) {
        fmt::println("constructor");
    }
    ~Vector() noexcept {
        fmt::println("destructor");
    }
    Vector(const Vector& o) noexcept: vec_(o.vec_) {
        fmt::println("copy!");
    }
    Vector& operator=(const Vector& o) noexcept {
        fmt::println("copy assign");
        vec_ = o.vec_;
        return *this;
    }
    Vector(Vector&& o) noexcept: vec_(std::move(o.vec_)) {
        fmt::println("move");
    }
    Vector& operator=(Vector&& o) noexcept {
        fmt::println("move assign");
        vec_ = std::move(o.vec_);
        return *this;
    }
    void times (int x) {
        for (auto& y: vec_) {y *= x;}
    }
  private:
    std::vector<int> vec_;
};

Vector factory(size_t n) {
    return Vector(n, 1);    // copy elision
}

Vector pass_by_const_ref(const Vector& vec) {
    Vector tmp(vec);        // copy ctor
    tmp.times(2);
    return tmp;             // copy elision
}

Vector pass_by_value(Vector vec) {
    vec.times(2);
    return vec;             // move ctor
}

Vector overload(const Vector& vec) {
    fmt::println("overload const&");
    Vector tmp(vec);        // copy ctor
    tmp.times(2);
    return tmp;             // copy elision
}

Vector overload(Vector&& vec) {
    fmt::println("overload &&");
    vec.times(2);
    return std::move(vec);  // move ctor
}

void pass_by_const_ref() {
    fmt::println("## pass_by_const_ref");
    auto vec0 = factory(3);
    fmt::println("### lvalue");
    auto vec1 = pass_by_const_ref(vec0);             //  lvalue: 1 copy
    fmt::println("### xvalue");
    auto vec2 = pass_by_const_ref(std::move(vec0));  //  xvalue: 1 copy
    fmt::println("### prvalue");
    auto vec3 = pass_by_const_ref(factory(3));       // prvalue: 1 copy
    fmt::print("\n");
}

void pass_by_value() {
    fmt::println("## pass_by_value");
    auto vec0 = factory(3);
    fmt::println("### lvalue");
    auto vec1 = pass_by_value(vec0);             //  lvalue: 1 copy 1 move
    fmt::println("### xvalue");
    auto vec2 = pass_by_value(std::move(vec0));  //  xvalue:        2 move
    fmt::println("### prvalue");
    auto vec3 = pass_by_value(factory(3));       // prvalue:        1 move
    fmt::print("\n");
}

void overload() {
    fmt::println("## overload");
    auto vec0 = factory(3);
    fmt::println("### lvalue");
    auto vec1 = overload(vec0);             //  lvalue c&: 1 copy
    fmt::println("### xvalue");
    auto vec2 = overload(std::move(vec0));  //  xvalue &&:        1 move
    fmt::println("### prvalue");
    auto vec3 = overload(factory(3));       // prvalue &&:        1 move
    fmt::print("\n");
}

template <class T>
auto universal_ref(T&& vec) {
    // T is Vector& for lvalue
    // T is Vector  for rvalue
    return overload(std::forward<T>(vec));
}

void universal_ref() {
    fmt::println("## universal_ref");
    auto vec0 = factory(3);
    fmt::println("### lvalue");
    auto vec1 = universal_ref(vec0);             //  lvalue 1 copy
    fmt::println("### xvalue");
    auto vec2 = universal_ref(std::move(vec0));  //  xvalue        1 move
    fmt::println("### prvalue");
    auto vec3 = universal_ref(factory(3));       // prvalue        1 move
    fmt::print("\n");
}

int main() {
    pass_by_const_ref();
    pass_by_value();
    overload();
    universal_ref();
    return 0;
}
