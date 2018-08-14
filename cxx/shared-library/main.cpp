#include "test.hpp"
#include <iostream>
#include <thread>
#include <chrono>

int main() {
    std::cout << "start: " << Test::get_static_member() << ", " << global_variable << std::endl;
    Test::set_static_member(666);
    global_variable = 666;
    std::this_thread::sleep_for(std::chrono::seconds(2));
    std::cout << "end:   " << Test::get_static_member() << ", " << global_variable << std::endl;
    return 0;
}
