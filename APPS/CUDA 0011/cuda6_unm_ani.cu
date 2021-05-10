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

__global__ void kernel_cv_run_bilin_scale( uchar3 *original, uchar3 *resized )
{
    float l_scale_x = original.blockDim.y - 1;
    float l_scale_y = original.blockDim.x- 1;
    l_scale_x /= resized.blockDim.x;
    l_scale_y /= resized.blockDim.y;

    for ( int l_resize_x = 0; l_resize_x < resized.blockDim.y; l_resize_x++ )
    {
        for ( int l_resize_y = 0; l_resize_y < resized.blockDim.x; l_resize_y++ )
        {
            // new real position
            float l_orig_x = l_resize_x * l_scale_x;
            float l_orig_y = l_resize_y * l_scale_y;
            // diff x and y
            float l_diff_x = l_orig_x - ( int ) l_orig_x;
            float l_diff_y = l_orig_y - ( int ) l_orig_y;

            // points
            uchar3 bgr00 = original(( int ) l_orig_y, ( int ) l_orig_x );
            uchar3 bgr01 = original(( int ) l_orig_y, 1 + ( int ) l_orig_x );
            uchar3 bgr10 = original( 1 + ( int ) l_orig_y, ( int ) l_orig_x );
            uchar3 bgr11 = original( 1 + ( int ) l_orig_y, 1 + ( int ) l_orig_x );

            uchar3 bgr;
            for ( int i = 0; i < 3; i++ )
            {
                // color calculation
                bgr[ i ] = bgr00[ i ] * ( 1 - l_diff_y ) * ( 1 - l_diff_x ) +
                           bgr01[ i ] * ( 1 - l_diff_y ) * ( l_diff_x ) +
                           bgr10[ i ] * ( l_diff_y ) * ( 1 - l_diff_x ) +
                           bgr11[ i ] * ( l_diff_y ) * ( l_diff_x );
                resized( l_resize_y, l_resize_x ) = bgr;
            }
        }
    }
}

void cu_cv_run_bilin_scale( uchar3 *original, uchar3 *resized )
{
	cudaError_t l_cerr;

	// Grid creation, size of grid must be equal or greater than images
	int l_block_size = 32;
	dim3 l_blocks( ( t_small_cuda_pic.m_size.x + l_block_size - 1 ) / l_block_size,
			       ( t_small_cuda_pic.m_size.y + l_block_size - 1 ) / l_block_size );
	dim3 l_threads( l_block_size, l_block_size );
	kernel_cv_run_bilin_scale<<< l_blocks, l_threads >>>( *original, *resized );

	if ( ( l_cerr = cudaGetLastError() ) != cudaSuccess )
		printf( "CUDA Error [%d] - '%s'\n", __LINE__, cudaGetErrorString( l_cerr ) );

	cudaDeviceSynchronize();
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


__global__ void kernel_text( CudaImg t_color_cuda_img, int2 t_pos, char* t_text, char* t_font, uchar2 t_fsize, uchar3 t_color )
{
    // X,Y coordinates and check image dimensions
    int l_y = blockDim.y * blockIdx.y + threadIdx.y;
    int l_x = blockDim.x * blockIdx.x + threadIdx.x;
    if ( l_y >= t_color_cuda_img.m_size.y ) return;
    if ( l_x >= t_color_cuda_img.m_size.x ) return;

    char l_znak = t_text[blockIdx.x];
    char l_bity = t_font[l_znak * t_fsize.y + threadIdx.y];

    if(l_bity & (1 << threadIdx.x))
        t_color_cuda_img.m_p_uchar3[ (l_y + t_pos.y) * t_color_cuda_img.m_size.x + l_x + t_pos.x ] = t_color;
}

void cu_text( CudaImg t_color_pic, int2 t_pos, const char* t_text, char* t_font, uchar2 t_fsize, uchar3 t_color )
{
    cudaError_t l_cerr;

    // Grid creation, size of grid must be equal or greater than images
    int l_block_size_x = t_fsize.x;
    int l_block_size_y = t_fsize.y;
    dim3 l_blocks( strlen(t_text), 1 );
    dim3 l_threads( l_block_size_x, l_block_size_y );
    char* l_text;
    cudaMallocManaged(&l_text, strlen(t_text));
    strcpy(l_text, t_text);
    kernel_text<<< l_blocks, l_threads >>>( t_color_pic, t_pos, l_text, t_font, t_fsize, t_color );
    cudaFree(l_text);

    if ( ( l_cerr = cudaGetLastError() ) != cudaSuccess )
        printf( "CUDA Error [%d] - '%s'\n", __LINE__, cudaGetErrorString( l_cerr ) );

    cudaDeviceSynchronize();
}



// Demo kernel to create chess board
__global__ void kernel_creategradient( CudaImg t_color_cuda_img )
{
	// X,Y coordinates and check image dimensions
	int l_y = blockDim.y * blockIdx.y + threadIdx.y;
	int l_x = blockDim.x * blockIdx.x + threadIdx.x;
	if ( l_y >= t_color_cuda_img.m_size.y ) return;
	if ( l_x >= t_color_cuda_img.m_size.x ) return;

	int l_dy = l_x * t_color_cuda_img.m_size.y / t_color_cuda_img.m_size.x + l_y - t_color_cuda_img.m_size.y;
	unsigned char l_color = 255 * abs( l_dy ) / t_color_cuda_img.m_size.y;

	uchar3 l_bgr = ( l_dy < 0 ) ? ( uchar3 ) { l_color, 255 - l_color, 0 } : ( uchar3 ) { 0, 255 - l_color, l_color };

	// Store point into image
	t_color_cuda_img.m_p_uchar3[ l_y * t_color_cuda_img.m_size.x + l_x ] = l_bgr;
}

// -----------------------------------------------------------------------------------------------

// Demo kernel to create picture with alpha channel gradient
__global__ void kernel_insertimage( CudaImg t_big_cuda_img, CudaImg t_small_cuda_pic, int2 t_position )
{
	// X,Y coordinates and check image dimensions
	int l_y = blockDim.y * blockIdx.y + threadIdx.y;
	int l_x = blockDim.x * blockIdx.x + threadIdx.x;
	if ( l_y >= t_small_cuda_pic.m_size.y ) return;
	if ( l_x >= t_small_cuda_pic.m_size.x ) return;
	int l_by = l_y + t_position.y;
	int l_bx = l_x + t_position.x;
	if ( l_by >= t_big_cuda_img.m_size.y || l_by < 0 ) return;
	if ( l_bx >= t_big_cuda_img.m_size.x || l_bx < 0 ) return;

	// Get point from small image
	uchar4 l_fg_bgra = t_small_cuda_pic.m_p_uchar4[ l_y * t_small_cuda_pic.m_size.x + l_x ];
	uchar3 l_bg_bgr = t_big_cuda_img.m_p_uchar3[ l_by * t_big_cuda_img.m_size.x + l_bx ];
	uchar3 l_bgr = { 0, 0, 0 };

	// compose point from small and big image according alpha channel
	l_bgr.x = l_fg_bgra.x * l_fg_bgra.w / 255 + l_bg_bgr.x * ( 255 - l_fg_bgra.w ) / 255;
	l_bgr.y = l_fg_bgra.y * l_fg_bgra.w / 255 + l_bg_bgr.y * ( 255 - l_fg_bgra.w ) / 255;
	l_bgr.z = l_fg_bgra.z * l_fg_bgra.w / 255 + l_bg_bgr.z * ( 255 - l_fg_bgra.w ) / 255;

	// Store point into image
	t_big_cuda_img.m_p_uchar3[ l_by * t_big_cuda_img.m_size.x + l_bx ] = l_bgr;
}

void cu_insertimage( CudaImg t_big_cuda_img, CudaImg t_small_cuda_pic, int2 t_position )
{
	cudaError_t l_cerr;

	// Grid creation, size of grid must be equal or greater than images
	int l_block_size = 32;
	dim3 l_blocks( ( t_small_cuda_pic.m_size.x + l_block_size - 1 ) / l_block_size,
			       ( t_small_cuda_pic.m_size.y + l_block_size - 1 ) / l_block_size );
	dim3 l_threads( l_block_size, l_block_size );
	kernel_insertimage<<< l_blocks, l_threads >>>( t_big_cuda_img, t_small_cuda_pic, t_position );

	if ( ( l_cerr = cudaGetLastError() ) != cudaSuccess )
		printf( "CUDA Error [%d] - '%s'\n", __LINE__, cudaGetErrorString( l_cerr ) );

	cudaDeviceSynchronize();
}

// -----------------------------------------------------------------------------------------------

void Animation::start( CudaImg t_bg_cuda_img, CudaImg t_ins_cuda_img )
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
	kernel_creategradient<<< l_blocks, l_threads >>>( m_bg_cuda_img );

	m_initialized = 1;
}

void Animation::next( CudaImg t_res_cuda_img, int2 t_position )
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
	kernel_insertimage<<< l_blocks, l_threads >>>( m_res_cuda_img, m_ins_cuda_img, t_position );

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


