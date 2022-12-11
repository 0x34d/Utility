#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

int num;

property__read_all_write(uint8_t *payload,uint32_t remaining_length){

    char filename[256];

    sprintf(filename, "data.%d.raw", num);

    FILE *fp = fopen(filename, "wb");

    fwrite(payload,remaining_length, 1, fp);
    fclose(fp);    
}

	property__read_all_write(packet.payload,packet.remaining_length);

