// echo | clang++ -E -dM -
// echo | g++ -E -dM -

#include <fmt/base.h>

int main() {
    fmt::println("__TIMESTAMP__  {}", __TIMESTAMP__);
    fmt::println("__DATE__       {}", __DATE__);
    fmt::println("__TIME__       {}", __TIME__);
    fmt::println("__FILE__       {}", __FILE__);
    fmt::println("__LINE__       {}", __LINE__);
    fmt::println("__func__       {}", __func__);
    fmt::println("__cplusplus    {}", __cplusplus);

#ifdef __STDCPP_THREADS__
    fmt::println("__STDCPP_THREADS__ {}", __STDCPP_THREADS__);
#endif

#ifdef __LP64__
    fmt::println("__LP64__");
#elif defined __LLP64__
    fmt::println("__LLP64__");
#elif defined __ILP64__
    fmt::println("__ILP64__");
#endif

#ifdef __unix__
    fmt::println("__unix__");
#endif
#ifdef __linux__
    fmt::println("__linux__");
#endif
#ifdef __APPLE__
    fmt::println("__APPLE__");
#endif
#ifdef _WIN32
    fmt::println("_WIN32");
#endif
#ifdef _WIN64
    fmt::println("_WIN64");
#endif

#ifdef __SSE__
    fmt::println("__SSE__");
#endif
#ifdef __SSE2__
    fmt::println("__SSE2__");
#endif
#ifdef __SSE3__
    fmt::println("__SSE3__");
#endif

    return 0;
}
