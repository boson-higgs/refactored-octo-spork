// **************************************************************************
//
//               Demo program for labs
//
// Subject:      Computer Architectures and Parallel systems
// Author:       Petr Olivka, petr.olivka@vsb.cz, 09/2019
// Organization: Department of Computer Science, FEECS,
//               VSB-Technical University of Ostrava, CZ
//
// File:         OpenCV simulator of LCD
//
// **************************************************************************

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <iostream>
#include <fstream>
#include <time.h>
#include <pthread.h>
#include <vector>
#include <sys/time.h>
#include <sys/param.h>
#include <algorithm>

#include "lcd_lib.h"
#include "font8x12_lsb.h"

//#include "graph_struct.hpp"
//#include "graph_class.hpp"


cv::Mat g_canvas;

 int l_color_red = 0xF800;
 int l_color_green = 0x07E0;
 int l_color_blue = 0x001F;
 int l_color_white = 0xFFFF;

char character = 'C';

  void print_char( cv::Mat &mat, int x, int y, char character, cv::Vec3b color)
  {
        for (x = 0; x < 8; x++)
        {
            for (y = 0; y < 12; y++)
            {
                if ((font8x12_lsb[character][x] >> y) & 0x1)
                {
                    lcd_put_pixel(x, y, color);
                }
            }
        }
  }

void *thread_function(void *arg) 
{
  print_char( g_canvas, x, y, character, l_color_red );
  sleep(1);
  pthread_exit(NULL);
}




int main()
{
    lcd_init();                     // LCD initialization

    lcd_clear();                    // LCD clear screen

    pthread_t thread;
    
    pthread_create( &thread, NULL, &thread_function, NULL );
    pthread_join(thread, NULL);
    

    cv::imwrite( LCD.png, g_canvas );   // refresh content of "LCD"
    
}



