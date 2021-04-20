#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

bool is_prime(int n);


int main()
{   
 printf("prvocislo %s \n", is_prime(1) ? "ano" : "ne");
 printf("prvocislo %s \n", is_prime(97) ? "ano" : "ne");
 printf("prvocislo %s \n", is_prime(13) ? "ano" : "ne");
 printf("prvocislo %s \n", is_prime(12) ? "ano" : "ne");


 long multiples(long * numbers, int size, long factor);
 long numbers[5] = {10,5,15,12,11};       
 printf("nasobku %d", multiples(numbers, 5, 5));

void fill_pyramid_numbers(long * numbers, int size);
fill_pyramid_numbers(array, 10);


}
