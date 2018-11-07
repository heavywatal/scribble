// echo | clang++ -E -dM -
// echo | g++ -E -dM -

#include <iostream>

int main() {
    std::cout << "\n__TIMESTAMP__  " << __TIMESTAMP__;
    std::cout << "\n__DATE__       " << __DATE__;
    std::cout << "\n__TIME__       " << __TIME__;
    std::cout << "\n__FILE__       " << __FILE__;
    std::cout << "\n__LINE__       " << __LINE__;
    std::cout << "\n__func__       " << __func__;
    std::cout << "\n__cplusplus    " << __cplusplus;

#ifdef __LP64__
    std::cout << "\n__LP64__";
#elif defined __LLP64__
    std::cout << "\n__LLP64__";
#elif defined __ILP64__
    std::cout << "\n__ILP64__";
#endif

#ifdef __unix__
    std::cout << "\n__unix__";
#endif
#ifdef __linux__
    std::cout << "\n__linux__";
#endif
#ifdef __APPLE__
    std::cout << "\n__APPLE__";
#endif
#ifdef _WIN32
    std::cout << "\n_WIN32";
#endif
#ifdef _WIN64
    std::cout << "\n_WIN64";
#endif

#ifdef __SSE__
    std::cout << "\n__SSE__";
#endif
#ifdef __SSE2__
    std::cout << "\n__SSE2__";
#endif
#ifdef __SSE3__
    std::cout << "\n__SSE3__";
#endif

    std::cout << "\n";
    return 0;
}
