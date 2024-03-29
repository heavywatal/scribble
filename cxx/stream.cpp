#include <iostream>
#include <sstream>
#include <fstream>

int main() {
    // pointer has be moved to the end explicitly
    std::ostringstream oss("Hello, ", std::ios_base::ate);
    oss << "ostringstream\n";
    std::cout << oss.str();
    // return copy as std::string
    // oss.rdbuf() cannot be read because it is output stream

    std::stringstream ss;
    ss << "Hello, stringstream\n";
    std::cout << ss.rdbuf();
    // return pointer to std::basic_streambuf

    ss.str("");  // reset content
    ss.clear();  // reset state flags
    ss << "Bye\n";
    std::cout << ss.rdbuf();

    // Check rdbuf().in_avail(), otherwise
    std::stringstream empty;
    std::cout << empty.rdbuf();
    // std::cout.setstate(badbit) exits silently unless
    // std::cout.exceptions(std::ios_base::badbit);
    std::cout << "not printed" << std::endl;
    return 0;
}
