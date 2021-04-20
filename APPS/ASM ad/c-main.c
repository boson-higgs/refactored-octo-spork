//***************************************************************************
//
// Program for education in subject "Assembly Languages"
// petr.olivka@vsb.cz, Department of Computer Science, VSB-TUO
//
// Empty project
//
//***************************************************************************

#include <stdio.h>

int filter_number_and_test(char* str_number, int test_number);
char num_sys_detect(char* t_res, int count);
char asm_formatting_char(char* code);

// Variables


int main()
{
    char test[128] = "f1f2f3";
    printf("%d\n", filter_number_and_test(test, 5));

    char test2[128] = "   \t\n\n\nffff";
    printf("%c", asm_formatting_char(test2));
    
    char g_text0[]="110011";  //1
    char g_text1[]="1234";     //2
    char g_text2[]="9F";      //3
    char g_text3[]=" 110011"; //0
    printf("%c\n", num_sys_detect(g_text0, 6));
    printf("%c\n", num_sys_detect(g_text1, 4));
    printf("%c\n", num_sys_detect(g_text2, 2));
    printf("%c\n", num_sys_detect(g_text3, 7));

    return 0;
}
