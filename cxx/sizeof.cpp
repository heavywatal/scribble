#include <fmt/base.h>

#include <cstdint>
#include <cstddef>
#include <bitset>
#include <vector>
#include <deque>
#include <valarray>
#include <array>
#include <set>
#include <unordered_set>
#include <map>
#include <unordered_map>
#include <tuple>
#include <memory>

inline void primitive() {
    fmt::println("sizeof(primitive) ----------------");
    fmt::println("char          {}", sizeof(char));
    fmt::println("bool          {}", sizeof(bool));
    fmt::println("short         {}", sizeof(short));
    fmt::println("int           {}", sizeof(int));
    fmt::println("long          {}", sizeof(long));
    fmt::println("long long     {}", sizeof(long long));
    fmt::println("double        {}", sizeof(double));
    fmt::println("long double   {}", sizeof(long double));
    fmt::println("uint_fast8_t  {}", sizeof(uint_fast8_t));
    fmt::println("uint_fast16_t {}", sizeof(uint_fast16_t));
    fmt::println("uint_fast32_t {}", sizeof(uint_fast32_t));
    fmt::println("uint_fast64_t {}", sizeof(uint_fast64_t));
    fmt::println("intmax_t      {}", sizeof(intmax_t));
    fmt::println("intptr_t      {}", sizeof(intptr_t));
    fmt::println("ptrdiff_t     {}", sizeof(ptrdiff_t));
    fmt::println("size_t        {}", sizeof(size_t));
#ifdef __SIZEOF_INT128__
    fmt::println("__uint128_t   {}", sizeof(__uint128_t));
#endif
}

inline void container() {
    fmt::println("sizeof(container) ----------------");
    fmt::println("vector<int>     {} + data", sizeof(std::vector<int>(7)));
    fmt::println("deque<int>      {} + data", sizeof(std::deque<int>(7)));
    fmt::println("valarray<int>   {} + data", sizeof(std::valarray<int>(7)));
    fmt::println("set<int>        {} + data", sizeof(std::set<int>{}));
    fmt::println("map<int,int>    {} + data", sizeof(std::map<int, int>{}));
    fmt::println("uo_set<int>     {} + data", sizeof(std::unordered_set<int>{}));
    fmt::println("uo_map<int,int> {} + data", sizeof(std::unordered_map<int, int>{}));
    fmt::println("pair<int,int>   {}", sizeof(std::pair<int, int>{}));
    fmt::println("pair<int,long>  {}", sizeof(std::pair<int, long>{}));
    fmt::println("pair<long,long> {}", sizeof(std::pair<long, long>{}));
    fmt::println("tuple<int,int>  {}", sizeof(std::tuple<int, int>{}));
    fmt::println("tuple<int,long> {}", sizeof(std::tuple<int, long>{}));
    fmt::println("array<int,7>    {}", sizeof(std::array<int, 7>{}));
    fmt::println("array<long,7>   {}", sizeof(std::array<long, 7>{}));
    fmt::println("bitset<1>       {}", sizeof(std::bitset<1>{}));
    fmt::println("bitset<65>      {}", sizeof(std::bitset<65>{}));
    fmt::println("bitset<129>     {}", sizeof(std::bitset<129>{}));
    fmt::println("shared_ptr<int> {} + data", sizeof(std::make_shared<int>(42)));
    fmt::println("unique_ptr<int> {} + data", sizeof(std::make_unique<int>(42)));
}

int main() {
    primitive();
    container();
    return 0;
}
