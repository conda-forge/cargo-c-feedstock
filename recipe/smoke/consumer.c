#include <cargo_c_smoke.h>
#include <stdio.h>

int main(void)
{
    if (cargo_c_add(17, 25) != 42 || cargo_c_add(-7, 3) != -4)
        return 1;
    puts("PASS: C consumer of cargo-c generated and installed library");
    return 0;
}
