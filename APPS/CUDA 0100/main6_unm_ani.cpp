// ***********************************************************************
//
// Demo program for education in subject
// Computer Architectures and Parallel Systems.
// Petr Olivka, dep. of Computer Science, FEI, VSB-TU Ostrava, 2020/11
// email:petr.olivka@vsb.cz
//
// Example of CUDA Technology Usage without unified memory.
//
// Simple animation.
// Image manipulation is performed by OpenCV library. 
//
// ***********************************************************************

#include <stdio.h>
#include <sys/time.h>
#include <cuda_device_runtime_api.h>
#include <cuda_runtime.h>
#include <opencv2/opencv.hpp>

#include "uni_mem_allocator.h"
#include "cuda_img.h"
#include "animation.h"

#define BLOCKX 30 // width of block
#define BLOCKY 30 // height of block
 

void cu_rotate( uchar4 *original, uchar4 *rotated, int width, int height );
uchar3* cu_rotate_ok(uchar3 *img, int width, int height);
void cu_blur( uchar3 *original, uchar3 *blurred, float t_level );
void cu_insert( CudaImg big_img, CudaImg small_img, int2 t_position );
void Animation::start( uchar4 *original,uchar4 *rotate, int sizex, int sizey );
void Animation::next( uchar3 *original, uchar3 *blurred, float t_level );
void Animation::stop();


int main()
{
    IplImage *img = cvLoadImage("kolo.jpg");
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
 
    
    cv::VideoWriter animation(rotate_img);
    while(cvWaitKey( 0 )) 
    {
        cu_get_next(rotate_img);
        animation.write(rotate_img);
    }
    
    
    cvShowImage( "Rotate", rotate_img );
    cvWaitKey( 0 );
}