#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "lfsr.h"

void lfsr_calculate(uint16_t *reg) {
    /* YOUR CODE HERE */
    int re0 = (*reg >> 0) & 1;
    int re2 = (*reg >> 2) & 1;
    int re3 = (*reg >> 3) & 1;
    int re5 = (*reg >> 5) & 1;
    int re = re0 ^ re2 ^ re3 ^ re5;
    *reg = (*reg >> 1) | (re << 15);
}

