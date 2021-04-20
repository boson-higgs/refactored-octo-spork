#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>


int main()
{  
  int number_array[8] = {-25, 20, 30, 40, 50, 60, -100, 10};
  printf( "Numbers greater than 20: %d",  greater_than(number_array, 8, 20));

}