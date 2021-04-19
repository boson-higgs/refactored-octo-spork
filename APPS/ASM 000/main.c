#include <stdio.h>
#include <stdint.h>



void swap_endiannes(uint8_t pole[], int n)
{
    uint8_t temp[n];
    for (int i = 0; i < n; i++)
    {
        temp[n-1-i] = pole[i];
    }
    for (int i = 0; i < n; i++)
    {
        pole[i] = temp[i];
    }
}



uint8_t check_bit(uint8_t bity, int pozice)
{
    return ((bity >> pozice) & 1);
}


int main()
{
    uint8_t data[4] = {1,2,3,4};
    swap_endiannes(data, 4);
    printf(
            "Array %d, %d, %d, %d\n",
            data[0],
            data[1],
            data[2],
            data[3]
    );


    uint8_t item = 0b10101010;
    printf(
            "zeroth bit: %d, first bit: %d, last bit: %d\n",
            check_bit(item, 0),
            check_bit(item, 1),
            check_bit(item, 7)
    );

    return 0;
}
