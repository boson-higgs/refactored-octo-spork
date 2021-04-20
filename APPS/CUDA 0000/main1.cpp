// ***********************************************************************
//
// Demo program for education in subject
// Computer Architectures and Parallel Systems.
// Petr Olivka, dep. of Computer Science, FEI, VSB-TU Ostrava, 2020/11
// email:petr.olivka@vsb.cz
//
// Example of CUDA Technology Usage.
// Global variables usage in threads, the use of printf.
//
// ***********************************************************************

#include <stdio.h>
#include <cuda_device_runtime_api.h>
#include <cuda_runtime.h>

// Prototype of function from .cu file
void cu_run_insert_picture_half( CudaPic t_color_pic);
void cu_run_insert_picture( CudaPic t_color_pic);

int main()
{
   // Uniform Memory allocator for Mat
	UniformAllocator allocator;
	cv::Mat::setDefaultAllocator( &allocator );

	// Load image
	cv::Mat l_cv_bgr = cv::imread( t_arg[ 1 ], "1004730.jpg");

	if ( !l_cv_bgr.data )
	{
		printf( "Unable to read file '%s'\n", t_arg[ 1 ] );
		return 1;
	}

	// create empty image
	cv::Mat l_cv( l_cv_bgr.size(), CV_8U );


	// Function calling from .cu file
	CudaPic pic(l_cv_bgr);

    cu_run_insert_picture_half(pic);
    cu_run_insert_picture(pic);

	// Show the Color and BW image
	cv::imshow( "Color", l_cv );
	cv::waitKey( 0 );
}

