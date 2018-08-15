#include <cstdint>
#include <cstddef>
#include <bitset>
#include <vector>
#include <deque>
#include <valarray>
#include <set>
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
    std::vector<int> vi;
    std::cout << "vector<int>     " << sizeof(vi) << " + data\n";
    std::vector<long> vl;
    std::cout << "vector<long>    " << sizeof(vl) << " + data\n";
    std::deque<int> di;
    std::cout << "deque<int>      " << sizeof(di) << " + data\n";
    std::valarray<int> vai;
    std::cout << "valarray<int>   " << sizeof(vai) << " + data\n";
    std::set<int> si;
    std::cout << "set<int>        " << sizeof(si) << " + data\n";
    std::pair<int, int> pii;
    std::cout << "pair<int,int>   " << sizeof(pii) << "\n";
    std::pair<int, long> pil;
    std::cout << "pair<int,long>  " << sizeof(pil) << "\n";
    std::pair<long, long> pll;
    std::cout << "pair<long,long> " << sizeof(pll) << "\n";
    std::bitset<1> bs1;
    std::cout << "bitset<1>       " << sizeof(bs1) << "\n";
    std::bitset<65> bs65;
    std::cout << "bitset<65>      " << sizeof(bs65) << "\n";
    std::bitset<129> bs129;
    std::cout << "bitset<129>     " << sizeof(bs129) << "\n";
}

int main() {
    primitive();
    container();
    return 0;
}
