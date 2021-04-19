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

#include "lcd_lib.h"

// Simple graphic interface

struct Point2D 
{
    int32_t x, y;
};

struct RGB
{
    uint8_t r, g, b;
};

class GraphElement
{
public:
    // foreground and background color
    RGB m_fg_color, m_bg_color;

    // constructor
    GraphElement( RGB t_fg_color, RGB t_bg_color ) : 
        m_fg_color( t_fg_color ), m_bg_color( t_bg_color ) {}

    // ONLY ONE INTERFACE WITH LCD HARDWARE!!!
    void drawPixel( int32_t t_x, int32_t t_y ) { lcd_put_pixel( t_x, t_y, convert_RGB888_to_RGB565( m_fg_color ) ); }
    
    // Draw graphics element
    virtual void draw() = 0;
    
    // Hide graphics element
    virtual void hide() { swap_fg_bg_color(); draw(); swap_fg_bg_color(); }
private:
    // swap foreground and backgroud colors
    void swap_fg_bg_color() { RGB l_tmp = m_fg_color; m_fg_color = m_bg_color; m_bg_color = l_tmp; } 

    // IMPLEMENT!!!
    // conversion of 24-bit RGB color into 16-bit color format
    uint16_t convert_RGB888_to_RGB565( RGB t_color ) { return 0x07E0; /* green color */ }
};


class Pixel : public GraphElement
{
public:
    // constructor
    Pixel( Point2D t_pos, RGB t_fg_color, RGB t_bg_color ) : GraphElement( t_fg_color, t_bg_color ), m_pos( t_pos ) {}
    // Draw method implementation
    virtual void draw() { drawPixel( m_pos.x, m_pos.y ); }
    // Position of Pixel
    Point2D m_pos;
};


class Circle : public GraphElement
{
public:
    // Center of circle
    Point2D m_center;
    // Radius of circle
    int32_t radius;

    Circle( Point2D t_center, int32_t t_radius, RGB t_fg, RGB t_bg ) : 
        GraphElement( t_fg, t_bg ), m_center( t_center ), radius( t_radius ) {}

    void draw() { } // IMPLEMENT!!!
};

class Character : public GraphElement 
{
public:
    // position of character
    Point2D m_pos;
    // character
    char m_character;

    Character( Point2D t_pos, char t_char, RGB t_fg, RGB t_bg ) : 
      GraphElement( t_fg, t_bg ), m_pos( t_pos ), m_character( t_char ) {};

    void draw() { }; // IMPLEMENT!!!
};

class Line : public GraphElement
{
public:
    // the first and the last point of line
    Point2D m_pos1, m_pos2;

    Line( Point2D t_pos1, Point2D t_pos2, RGB t_fg, RGB t_bg ) : 
      GraphElement( t_fg, t_bg ), m_pos1( t_pos1 ), m_pos2( t_pos2 ) {}

    void draw() {  }; // IMPLEMENT!!!
};

