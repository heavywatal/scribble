#include <iostream>
#include <vector>

class Vector {
  public:
    Vector() = delete;
    Vector(size_t n, int x): vec_(n, x) {
        std::cout << "constructor\n";
    }
    ~Vector() {
        std::cout << "destructor\n";
    }
    Vector(const Vector& o): vec_(o.vec_) {
        std::cout << "copy!\n";
    }
    Vector(Vector&& o): vec_(std::move(o.vec_)) {
        std::cout << "move\n";
    }
    void times (int x) {
        for (auto& y: vec_) {y *= x;}
    }
    void print(std::ostream& ost) const {
        for (const auto x: vec_) {ost << x << " ";}
        ost << "\n";
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
    std::cout << "overload const&\n";
    Vector tmp(vec);        // copy ctor
    tmp.times(2);
    return tmp;             // copy elision
}

Vector overload(Vector&& vec) {
    std::cout << "overload &&\n";
    vec.times(2);
    return std::move(vec);  // move ctor
}

void pass_by_const_ref() {
    std::cout << "######## pass_by_const_ref\n";
    auto vec0 = factory(3);
    std::cout << "l\n";
    auto vec1 = pass_by_const_ref(vec0);             //  lvalue: 1 copy
    std::cout << "x\n";
    auto vec2 = pass_by_const_ref(std::move(vec0));  //  xvalue: 1 copy
    std::cout << "pr\n";
    auto vec3 = pass_by_const_ref(factory(3));       // prvalue: 1 copy
    std::cout << "\n";
}

void pass_by_value() {
    std::cout << "######## pass_by_value\n";
    auto vec0 = factory(3);
    std::cout << "l\n";
    auto vec1 = pass_by_value(vec0);             //  lvalue: 1 copy 1 move
    std::cout << "x\n";
    auto vec2 = pass_by_value(std::move(vec0));  //  xvalue:        2 move
    std::cout << "pr\n";
    auto vec3 = pass_by_value(factory(3));       // prvalue:        1 move
    std::cout << "\n";
}

void overload() {
    std::cout << "######## overload\n";
    auto vec0 = factory(3);
    std::cout << "l\n";
    auto vec1 = overload(vec0);             //  lvalue c&: 1 copy
    std::cout << "x\n";
    auto vec2 = overload(std::move(vec0));  //  xvalue &&:        1 move
    std::cout << "pr\n";
    auto vec3 = overload(factory(3));       // prvalue &&:        1 move
    std::cout << "\n";
}

int main() {
    pass_by_const_ref();
    pass_by_value();
    overload();
    return 0;
}
