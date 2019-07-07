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
#include <iostream>

inline void primitive() {
    std::cout << "sizeof(primitive) ----------------\n";
    std::cout << "char          " << sizeof(char) << "\n";
    std::cout << "bool          " << sizeof(bool) << "\n";
    std::cout << "short         " << sizeof(short) << "\n";
    std::cout << "int           " << sizeof(int) << "\n";
    std::cout << "long          " << sizeof(long) << "\n";
    std::cout << "long long     " << sizeof(long long) << "\n";
    std::cout << "double        " << sizeof(double) << "\n";
    std::cout << "long double   " << sizeof(long double) << "\n";
    std::cout << "uint_fast8_t  " << sizeof(uint_fast8_t) << "\n";
    std::cout << "uint_fast16_t " << sizeof(uint_fast16_t) << "\n";
    std::cout << "uint_fast32_t " << sizeof(uint_fast32_t) << "\n";
    std::cout << "uint_fast64_t " << sizeof(uint_fast64_t) << "\n";
    std::cout << "intmax_t      " << sizeof(intmax_t) << "\n";
    std::cout << "intptr_t      " << sizeof(intptr_t) << "\n";
    std::cout << "ptrdiff_t     " << sizeof(ptrdiff_t) << "\n";
    std::cout << "size_t        " << sizeof(size_t) << "\n";
}

inline void container() {
    std::cout << "sizeof(container) ----------------\n";
    std::vector<int> vi(7);
    std::cout << "vector<int>     " << sizeof(vi) << " + data\n";
    std::deque<int> di(7);
    std::cout << "deque<int>      " << sizeof(di) << " + data\n";
    std::valarray<int> vai(0, 7);
    std::cout << "valarray<int>   " << sizeof(vai) << " + data\n";
    std::set<int> si;
    std::cout << "set<int>        " << sizeof(si) << " + data\n";
    std::map<int,int> mii;
    std::cout << "map<int,int>    " << sizeof(mii) << " + data\n";
    std::unordered_set<int> uosi;
    std::cout << "uo_set<int>     " << sizeof(uosi) << " + data\n";
    std::unordered_map<int,int> uomii;
    std::cout << "uo_map<int,int> " << sizeof(uomii) << " + data\n";
    std::pair<int, int> pii;
    std::cout << "pair<int,int>   " << sizeof(pii) << "\n";
    std::pair<int, long> pil;
    std::cout << "pair<int,long>  " << sizeof(pil) << "\n";
    std::pair<long, long> pll;
    std::cout << "pair<long,long> " << sizeof(pll) << "\n";
    std::tuple<int, int> tii;
    std::cout << "tuple<int,int>  " << sizeof(tii) << "\n";
    std::tuple<int, long> til;
    std::cout << "tuple<int,long> " << sizeof(til) << "\n";
    std::array<int, 7> ai7;
    std::cout << "array<int,7>    " << sizeof(ai7) << "\n";
    std::array<long, 7> al7;
    std::cout << "array<long,7>   " << sizeof(al7) << "\n";
    std::bitset<1> bs1;
    std::cout << "bitset<1>       " << sizeof(bs1) << "\n";
    std::bitset<65> bs65;
    std::cout << "bitset<65>      " << sizeof(bs65) << "\n";
    std::bitset<129> bs129;
    std::cout << "bitset<129>     " << sizeof(bs129) << "\n";
    auto shptr = std::make_shared<int>(42);
    std::cout << "shared_ptr<int> " << sizeof(shptr) << "\n";
    auto unptr = std::make_unique<int>(42);
    std::cout << "unique_ptr<int> " << sizeof(unptr) << "\n";
}

int main() {
    primitive();
    container();
    return 0;
}
