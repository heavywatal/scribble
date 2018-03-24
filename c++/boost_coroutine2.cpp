#include <iostream>
#include <boost/coroutine2/coroutine.hpp>

using coro_t = boost::coroutines2::coroutine<int>;

coro_t::pull_type Fibonacci(const int n) {
    return typename coro_t::pull_type([n](typename coro_t::push_type& yield){
        int x = 0u;
        for (int i=x, next=1; i<=n; ++i) {
            yield(x);
            auto prev = x;
            x = next;
            next += prev;
        }
    });
}

int main() {
    for (const auto x: Fibonacci(20u)) {
        std::cout << x << " ";
    }
    std::cout << "\n";
    return 0;
}
