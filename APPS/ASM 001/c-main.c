#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

char data[10] = "XYZXXXX";
void replaced();

/*uint8_t data2[4] = {4,3,2,1};
void msb_to_lsb();*/

int main()
{  
    replaced();
    printf(
      "login %s \n", 
      data
    );
}
