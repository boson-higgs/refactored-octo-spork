//***************************************************************************
//
// Program for education in subject "Assembly Languages"
// petr.olivka@vsb.cz, Department of Computer Science, VSB-TUO
//
// Empty project
//
//***************************************************************************

#include <stdio.h>

char temp[25] = "HHHHHHeLLLLLLooo worlDDD";
char get_most_abundant_lowercase_char(char *resource);

int main()
{
  printf("nejvic vyskytujici se maly znak: '%c'\n", get_most_abundant_lowercase_char(temp));
}
