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
// Every thread displays information of its position in block,
// position of block in grid and global position.
//
// ***********************************************************************


#include <stdio.h>
#include <cuda_device_runtime_api.h>
#include <cuda_runtime.h>

__global__ void insert_picture_half( CudaPic t_color_pic )
{
	// X,Y coordinates and check image dimensions
	int l_y = blockDim.y * blockIdx.y + threadIdx.y;
	int l_x = blockDim.x * blockIdx.x + threadIdx.x;
	if ( l_y >= t_color_pic.m_size.y ) return;
	if ( l_x >= t_color_pic.m_size.x ) return;

	// Get point from color picture
	uchar3 l_bgr = t_color_pic.m_p_uchar3[ l_y * t_color_pic.m_size.x + l_x ];

	t_color_pic.at3(l_x, l_y).x = l_bgr.x / 2;
	t_color_pic.at3(l_x, l_y).y = l_bgr.y / 2;
	t_color_pic.at3(l_x, l_y).z = l_bgr.z / 2;
}



void cu_run_insert_picture_half( CudaPic t_color_pic)
{
	cudaError_t l_cerr;

	// Grid creation, size of grid must be equal or greater than images
	int l_block_size = 16;
	dim3 l_blocks( ( t_color_pic.m_size.x + l_block_size - 1 ) / l_block_size, ( t_color_pic.m_size.y + l_block_size - 1 ) / l_block_size );
	dim3 l_threads( l_block_size, l_block_size );
	kernel_insert_picture_half<<< l_blocks, l_threads >>>( t_color_pic);

	if ( ( l_cerr = cudaGetLastError() ) != cudaSuccess )
		printf( "CUDA Error [%d] - '%s'\n", __LINE__, cudaGetErrorString( l_cerr ) );

	cudaDeviceSynchronize();
}


__global__ void insert_picture( CudaPic t_color_pic )
{
	// X,Y coordinates and check image dimensions
	int l_y = blockDim.y * blockIdx.y + threadIdx.y;
	int l_x = blockDim.x * blockIdx.x + threadIdx.x;
	if ( l_y >= t_color_pic.m_size.y ) return;
	if ( l_x >= t_color_pic.m_size.x ) return;

	// Get point from color picture
	uchar3 l_bgr = t_color_pic.m_p_uchar3[ l_y * t_color_pic.m_size.x + l_x ];

    if(t_color_pic.at3(l_x, l_y).x > 127)
    {
        t_color_pic.at3(l_x, l_y).x = 127;   
    }
	
    if(t_color_pic.at3(l_x, l_y).y > 127)
    {
        t_color_pic.at3(l_x, l_y).y = 127;
    }
	
    if(t_color_pic.at3(l_x, l_y).z > 127)
    {
        t_color_pic.at3(l_x, l_y).z = 127;
    }
}



void cu_run_insert_picture( CudaPic t_color_pic)
{
	cudaError_t l_cerr;

	// Grid creation, size of grid must be equal or greater than images
	int l_block_size = 16;
	dim3 l_blocks( ( t_color_pic.m_size.x + l_block_size - 1 ) / l_block_size, ( t_color_pic.m_size.y + l_block_size - 1 ) / l_block_size );
	dim3 l_threads( l_block_size, l_block_size );
	kernel_insert_picture<<< l_blocks, l_threads >>>( t_color_pic);

	if ( ( l_cerr = cudaGetLastError() ) != cudaSuccess )
		printf( "CUDA Error [%d] - '%s'\n", __LINE__, cudaGetErrorString( l_cerr ) );

	cudaDeviceSynchronize();
}