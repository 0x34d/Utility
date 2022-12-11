#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>


int main(){
    uint8_t *payload;
    uint32_t remaining_length;

    char filename[256];
    int num;

    sprintf(filename, "data.%d.raw", num);

    FILE *fp = fopen(filename, "wb");

    fwrite(payload,remaining_length, 1, fp);
    fclose(fp);

    return 0;
}
