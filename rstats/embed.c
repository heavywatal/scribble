/*
R_FRAMEWORK="/Library/Frameworks/R.framework"
clang  -I"${R_FRAMEWORK}/Headers" -L"${R_FRAMEWORK}/Libraries" -lR embed.c
gcc-10 -I"${R_FRAMEWORK}/Headers" -L"${R_FRAMEWORK}/Libraries" -lR embed.c
/usr/bin/gcc -I"/usr/share/R/include/" -L"/usr/lib/R/lib/" -lR embed.c
/usr/bin/gcc -I"/usr/share/R/include/" -L"/usr/lib/R/lib/" embed.c -lR
*/

#include <Rembedded.h>
#include <stdio.h>

int main() {
    char* argv[] = {"R", "--slave", "--no-save"};
    printf("Initializing R\n");
    Rf_initialize_R(3, argv);
    printf("Setting up main loop\n");
    setup_Rmainloop();
    printf("Done\n");
    return 0;
}
