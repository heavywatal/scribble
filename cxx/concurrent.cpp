#include <wtl/concurrent.hpp>

#include <iostream>
#include <sstream>

int main() {
    const unsigned int concurrency = std::thread::hardware_concurrency();
    std::cerr << "std::thread::hardware_concurrency(): "
              << concurrency << std::endl;

    std::vector<std::future<size_t>> futures;
    wtl::Semaphore semaphore(2u);
    constexpr size_t n = 6u;

    for (size_t i=0; i<n; ++i) {
        // manual lock before thread creation: thread IDs are reused
        semaphore.lock();
        futures.push_back(std::async(std::launch::async, [&semaphore, i] {
            std::lock_guard<wtl::Semaphore> scope_unlock(semaphore, std::adopt_lock);
            std::ostringstream oss;
            oss << std::this_thread::get_id() << ": " << i << "\n";
            std::cerr << oss.str() << std::flush;
            std::this_thread::sleep_for(std::chrono::milliseconds(300));
            return i;
        }));
    }
    for (auto& x: futures) x.wait();
    for (auto& x: futures) {
        std::cerr << x.get() << " ";
    }
    std::cerr << std::endl;

    futures.clear();
    for (size_t i=0; i<n; ++i) {
        // RAII lock after thread creation: new thread IDs are created
        futures.push_back(std::async(std::launch::async, [&semaphore, i] {
            std::lock_guard<wtl::Semaphore> _(semaphore);
            std::ostringstream oss;
            oss << std::this_thread::get_id() << ": " << i << "\n";
            std::cerr << oss.str() << std::flush;
            std::this_thread::sleep_for(std::chrono::milliseconds(300));
            return i;
        }));
    }
    for (auto& x: futures) x.wait();
    for (auto& x: futures) {
        std::cerr << x.get() << " ";
    }
    std::cerr << std::endl;
}
