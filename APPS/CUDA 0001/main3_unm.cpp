// ***********************************************************************
//
// Demo program for education in subject
// Computer Architectures and Parallel Systems.
// Petr Olivka, dep. of Computer Science, FEI, VSB-TU Ostrava, 2020/11
// email:petr.olivka@vsb.cz
//
// Example of CUDA Technology Usage without unified memory.
//
// Image creation and its modification using CUDA.
// Image manipulation is performed by OpenCV library. 
//
// ***********************************************************************

#include <stdio.h>
#include <cuda_device_runtime_api.h>
#include <cuda_runtime.h>
#include <opencv2/opencv.hpp>

#include "uni_mem_allocator.h"
#include "cuda_img.h"
 

void rotateImage( uchar4 *original, uchar4 *rotated, int width, int height );
 

#define BLOCKX 30 // width of block
#define BLOCKY 30 // height of block
 
int main()
{
    IplImage *img = cvLoadImage("tram.jpg");
    int height = img->height;
    int width = img->width;
    
    IplImage *img2 = cvLoadImage("ikarus.jpg");
    int height = img->height;
    int width = img->width;
 
 
    uchar4 *original = new uchar4[ width * height ];
    uchar4 *rotate = new uchar4[ width * height ];
     
    rotateImage(original,rotate,width,height);
    IplImage *rotate_img = cvCreateImage( cvSize( height, width ), IPL_DEPTH_8U, 3 );
    
 
    for ( int y = 0; y < width; y++ )
        for ( int x  = 0; x < height; x++ )
        {
            uchar4 bgr = rotate[ y * height + x ];
            CvScalar s = { bgr.x, bgr.y, bgr.z };
            cvSet2D( rotate_img, y, x, s );
        }
 
    cvShowImage( "Rotate", rotate_img );
    cvWaitKey( 0 );
}