#include <wtl/concurrent.hpp>

#include <fmt/base.h>
#include <fmt/std.h>

#include <cstdio>

int main() {
    const unsigned int concurrency = std::thread::hardware_concurrency();
    fmt::println(stderr, "std::thread::hardware_concurrency(): {}", concurrency);

    std::vector<std::future<int>> futures;
    wtl::Semaphore semaphore(2);
    constexpr int n = 6;

    for (int i = 0; i < n; ++i) {
        // manual lock before thread creation: thread IDs are reused
        semaphore.lock();
        futures.push_back(std::async(std::launch::async, [&semaphore, i] {
            std::lock_guard<wtl::Semaphore> scope_unlock(semaphore, std::adopt_lock);
            fmt::println(stderr, "{}: {}", std::this_thread::get_id(), i);
            std::this_thread::sleep_for(std::chrono::milliseconds(300));
            return i;
        }));
    }
    for (auto& x: futures) x.wait();
    for (auto& x: futures) {
        fmt::print(stderr, "{} ", x.get());
    }
    fmt::print(stderr, "\n");

    futures.clear();
    for (int i = 0; i < n; ++i) {
        // RAII lock after thread creation: new thread IDs are created
        futures.push_back(std::async(std::launch::async, [&semaphore, i] {
            std::lock_guard<wtl::Semaphore> _(semaphore);
            fmt::println(stderr, "{}: {}", std::this_thread::get_id(), i);
            std::this_thread::sleep_for(std::chrono::milliseconds(300));
            return i;
        }));
    }
    for (auto& x: futures) x.wait();
    for (auto& x: futures) {
        fmt::print(stderr, "{} ", x.get());
    }
    fmt::print(stderr, "\n");
}
