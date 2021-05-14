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
//
// ***********************************************************************

#include <stdio.h>
#include <cuda_device_runtime_api.h>
#include <cuda_runtime.h>
#include <math.h>

#include "cuda_img.h"
#include "animation.h"


__global__ void kernel_rotate( uchar4 *original,uchar4 *rotate, int sizex, int sizey )
{
    int y = blockDim.y * blockIdx.y + threadIdx.y;
    int x = blockDim.x * blockIdx.x + threadIdx.x;
    if ( x >= sizex ) return;
    if ( y >= sizey ) return;
    
    rotate[y * sizex + x] = original[(sizey - y - 1) * sizex + x];
 
}
 
void cu_rotate( uchar4 *original, uchar4 *rotated, int width, int height )
{
    cudaError_t cerr;
    
    uchar4 *cudaOriginal;
    uchar4 *cudaRotate;
    cerr = cudaMalloc( &cudaOriginal, width * height * sizeof( uchar4 ) );
    if ( cerr != cudaSuccess )
        printf( "CUDA Error [%d] - '%s'\n", __LINE__, cudaGetErrorString( cerr ) );    
 
    cerr = cudaMalloc( &cudaRotate, width * height * sizeof( uchar4 ) );
    if ( cerr != cudaSuccess )
        printf( "CUDA Error [%d] - '%s'\n", __LINE__, cudaGetErrorString( cerr ) );    
 
   
    cerr = cudaMemcpy( cudaOriginal, original, width * height * sizeof( uchar4 ), cudaMemcpyHostToDevice );
    if ( cerr != cudaSuccess )
        printf( "CUDA Error [%d] - '%s'\n", __LINE__, cudaGetErrorString( cerr ) );    
 
    int block = 16;
    dim3 blocks( ( width + block - 1 ) / block, ( height + block - 1 ) / block );
    dim3 threads( block, block );
 
    
    kernel_rotate<<< blocks, threads >>>( cudaOriginal, cudaRotate, width, height );
 
    if ( ( cerr = cudaGetLastError() ) != cudaSuccess )
        printf( "CUDA Error [%d] - '%s'\n", __LINE__, cudaGetErrorString( cerr ) );
 
   
    cerr = cudaMemcpy( rotated, cudaRotate, width * height * sizeof( uchar4 ), cudaMemcpyDeviceToHost );
    if ( cerr != cudaSuccess )
        printf( "CUDA Error [%d] - '%s'\n", __LINE__, cudaGetErrorString( cerr ) );    
 
    
    cudaFree( cudaRotate );
    cudaFree( cudaOriginal );
 
}


__global__ void rotate_ok(uchar3 *original, uchar3 *rotated, int width, int height) 
{
	int x = blockDim.x * blockIdx.x + threadIdx.x;
	int y = blockDim.y * blockIdx.y + threadIdx.y;
	if(x >= width || y >= height) 
    {
		return;
	}


	int sizex = width / 2;
	int sizey = height / 2;

	float theta = 30 * 3.14 / 180;
	int x2 = (x-sizex) * cos(theta) - (y - sizey) * sin(theta) + sizex;
	int y2 = (x-sizex) * sin(theta) + (y - sizey) * cos(theta) + sizey;

	if(x2 >= 0 && x2 < width && y2 >=0 && y2 < height) 
    {
		rotated[y * width + x] = original[y2 * width + x2];
	} 
    else 
    {
		rotated[y * width + x] = (uchar3) {0, 0, 0};
	}
}

uchar3* cu_rotate_ok(uchar3 *img, int width, int height) 
{
	uchar3 *picture = new uchar3[width * heigth];

	uchar3 *original = NULL;
	uchar3 *rotated = NULL;
	cerr = cudaMalloc(&original, sizeof(uchar3) * width * height);
	cerr = cudaMalloc(&rotated, sizeof(uchar3) * width * height);

	cerr = cudaMemcpy(original, img, sizeof(uchar3) * width * height, cudaMemcpyHostToDevice);

	int count = 10;
	dim3 blocks((width + count)/ count, (height + count) / count);
	dim3 threads(count, count);
	rotate_ok<<<blocks, threads>>>(original, rotated, width, height);
	cerr = cudaPeekAtLastError();
	cerr = cudaMemcpy(picture, rotated, sizeof(uchar3) * width * height, cudaMemcpyDeviceToHost);
	cerr = cudaFree(original);
	cerr = cudaFree(rotated);

	return picture;
}


__global__ void kernel_blur( uchar3 *original, uchar3 *blurred, float t_level )
{
    for ( blockDim.x = 1; blockDim.x < threadIdx.y - 1; blockDim.x++ )
        for ( blockDim.y = 1; blockDim.y < threadIdx.x - 1; blockDim.y++ )
        {
            // initialize sum
            uchar3 l_bgr32 = { 0, 0, 0 };
            // loop for all neighbours
            for ( int nx = -1; nx <= 1; nx++ )
                for( int ny = -1; ny <= 1; ny++ )
                {
                    // pickup point from orig figure
                    uchar3 l_bgr = original(blockDim.y + ny, blockDim.x + nx);
                    // sum of r/g/b colors
                    for ( int b = 0; b < 3; b++ )
                    {
                        if ( !nx && !ny ) 
                            l_bgr32[ b ] += l_bgr[ b ];  
                        else 
                            l_bgr32[ b ] += l_bgr[ b ] * t_level;
                    }
                }
            // average
            l_bgr32 /= 1 + 8 * t_level;
            // put pixel into blur image
            blurred(blockDim.y, blockDim.x) = l_bgr32;
        }
}

void cu_blur( uchar3 *original, uchar3 *blurred, float t_level )
{
	cudaError_t l_cerr;

	// Grid creation, size of grid must be equal or greater than images
	int l_block_size = 32;
	dim3 l_blocks( ( t_small_cuda_pic.m_size.x + l_block_size - 1 ) / l_block_size,
			       ( t_small_cuda_pic.m_size.y + l_block_size - 1 ) / l_block_size );
	dim3 l_threads( l_block_size, l_block_size );
	kernel_blur<<< l_blocks, l_threads >>>( *original, *blurred, t_level);

	if ( ( l_cerr = cudaGetLastError() ) != cudaSuccess )
		printf( "CUDA Error [%d] - '%s'\n", __LINE__, cudaGetErrorString( l_cerr ) );

	cudaDeviceSynchronize();
}

__global__ void kernel_insert( CudaImg big_img, CudaImg small_img, int2 t_position )
{
    int l_y = blockDim.y * blockIdx.y + threadIdx.y;
    int l_x = blockDim.x * blockIdx.x + threadIdx.x;
    if ( l_y >= small_img.m_size.y ) return;
    if ( l_x >= small_img.m_size.x ) return;
    int l_by = l_y + t_position.y;
    int l_bx = l_x + t_position.x;
    if ( l_by >= big_img_size.y  l_by < 0 ) return;
    if ( l_bx >= big_img.m_size.x  l_bx < 0 ) return;

    big_img.m_p_uchar3[ l_by * big_img.m_size.x + l_bx ] = small_img.m_p_uchar3[ l_y * small_img.m_size.x + l_x ];
}

__global__ void kernel_clear( CudaImg img )
{
    int l_y = blockDim.y * blockIdx.y + threadIdx.y;
    int l_x = blockDim.x * blockIdx.x + threadIdx.x;
    if ( l_y >= t_color_cuda_img.m_size.y ) return;
    if ( l_x >= t_color_cuda_img.m_size.x ) return;

    img.m_p_uchar3[ l_y * img.m_size.x + l_x ] = { 0, 0, 0 };
}

void cu_insert( CudaImg big_img, CudaImg small_img, int2 t_position )
{
    cudaError_t l_cerr;

    int l_block_size = 32;
    dim3 l_blocks( ( small_img.m_size.x + l_block_size - 1 ) / l_block_size,
                   ( small_img.m_size.y + l_block_size - 1 ) / l_block_size );
    dim3 l_threads( l_block_size, l_block_size );

    dim3 l_blocks_b( ( big_img.m_size.x + l_block_size - 1 ) / l_block_size,
                   ( big_img.m_size.y + l_block_size - 1 ) / l_block_size );
    dim3 l_threads_b( l_block_size, l_block_size );

    kernel_clear<<<l_blocks_b, l_threads_b>>>(img);
    kernel_insert<<< l_blocks, l_threads >>>( big_img, small_img, t_position );

    if ( ( l_cerr = cudaGetLastError() ) != cudaSuccess )
        printf( "CUDA Error [%d] - '%s'\n", LINE, cudaGetErrorString( l_cerr ) );

    cudaDeviceSynchronize();
}

// -----------------------------------------------------------------------------------------------

void Animation::start( uchar4 *original,uchar4 *rotate, int sizex, int sizey )
{
	if ( m_initialized ) return;
	cudaError_t l_cerr;

	m_bg_cuda_img = t_bg_cuda_img;
	m_res_cuda_img = t_bg_cuda_img;
	m_ins_cuda_img = t_ins_cuda_img;

	// Memory allocation in GPU device
	// Memory for background
	l_cerr = cudaMalloc( &m_bg_cuda_img.m_p_void, m_bg_cuda_img.m_size.x * m_bg_cuda_img.m_size.y * sizeof( uchar3 ) );
	if ( l_cerr != cudaSuccess )
		printf( "CUDA Error [%d] - '%s'\n", __LINE__, cudaGetErrorString( l_cerr ) );

	// Creation of background gradient
	int l_block_size = 32;
	dim3 l_blocks( ( m_bg_cuda_img.m_size.x + l_block_size - 1 ) / l_block_size,
			       ( m_bg_cuda_img.m_size.y + l_block_size - 1 ) / l_block_size );
	dim3 l_threads( l_block_size, l_block_size );
	kernel_rotate<<< l_blocks, l_threads >>>(*original, *rotate, sizex, sizey);

	m_initialized = 1;
}

void Animation::next( uchar3 *original, uchar3 *blurred, float t_level );
{
	if ( !m_initialized ) return;

	cudaError_t cerr;

	// Copy data internally GPU from background into result
	cerr = cudaMemcpy( m_res_cuda_img.m_p_void, m_bg_cuda_img.m_p_void, m_bg_cuda_img.m_size.x * m_bg_cuda_img.m_size.y * sizeof( uchar3 ), cudaMemcpyDeviceToDevice );
	if ( cerr != cudaSuccess )
		printf( "CUDA Error [%d] - '%s'\n", __LINE__, cudaGetErrorString( cerr ) );

	// insert picture
	int l_block_size = 32;
	dim3 l_blocks( ( m_ins_cuda_img.m_size.x + l_block_size - 1 ) / l_block_size,
			       ( m_ins_cuda_img.m_size.y + l_block_size - 1 ) / l_block_size );
	dim3 l_threads( l_block_size, l_block_size );
    kernel_blur<<< l_blocks, l_threads >>>(*original, *blurred, t_level );

	// Copy data to GPU device
	cerr = cudaMemcpy( t_res_cuda_img.m_p_void, m_res_cuda_img.m_p_void, m_res_cuda_img.m_size.x * m_res_cuda_img.m_size.y * sizeof( uchar3 ), cudaMemcpyDeviceToHost );
	if ( cerr != cudaSuccess )
		printf( "CUDA Error [%d] - '%s'\n", __LINE__, cudaGetErrorString( cerr ) );

}

void Animation::stop()
{
	if ( !m_initialized ) return;

	cudaFree( m_bg_cuda_img.m_p_void );
	cudaFree( m_res_cuda_img.m_p_void );
	cudaFree( m_ins_cuda_img.m_p_void );

	m_initialized = 0;
}


