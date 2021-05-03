// ***********************************************************************
//
// Demo program for education in subject
// Computer Architectures and Parallel Systems.
// Petr Olivka, dep. of Computer Science, FEI, VSB-TU Ostrava, 2020/11
// email:petr.olivka@vsb.cz
//
// Example of CUDA Technology Usage wit unified memory.
// Image transformation from RGB to BW schema. 
//
// ***********************************************************************

#include <stdio.h>
#include <cuda_device_runtime_api.h>
#include <cuda_runtime.h>
#include <string.h>

#include "cuda_img.h"

// Demo kernel to create picture with alpha channel gradient
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

__global__ void kernel_rotate( uchar4 *original,uchar4 *rotate, int sizex, int sizey )
{
    int y = blockDim.y * blockIdx.y + threadIdx.y;
    int x = blockDim.x * blockIdx.x + threadIdx.x;
    if ( x >= sizex ) return;
    if ( y >= sizey ) return;
    
    rotate[y * sizex + x] = original[(sizey - y - 1) * sizex + x];
 
}
 
void rotateImage( uchar4 *original, uchar4 *rotated, int width, int height )
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



// Demo kernel to create chess board
__global__ void kernel_chessboard( CudaImg t_color_cuda_img )
{
    // X,Y coordinates and check image dimensions
    int l_y = blockDim.y * blockIdx.y + threadIdx.y;
    int l_x = blockDim.x * blockIdx.x + threadIdx.x;
    if ( l_y >= t_color_cuda_img.m_size.y ) return;
    if ( l_x >= t_color_cuda_img.m_size.x ) return;

    unsigned char b_or_w = 255 * ( ( blockIdx.x + blockIdx.y ) & 1 );

    // Store point into image
    t_color_cuda_img.m_p_uchar3[ l_y * t_color_cuda_img.m_size.x + l_x ] = { b_or_w, b_or_w, b_or_w };
}

void cu_create_chessboard( CudaImg t_color_cuda_img, int t_square_size )
{
    cudaError_t l_cerr;

    // Grid creation, size of grid must be equal or greater than images
    dim3 l_blocks( ( t_color_cuda_img.m_size.x + t_square_size - 1 ) / t_square_size,
                   ( t_color_cuda_img.m_size.y + t_square_size - 1 ) / t_square_size );
    dim3 l_threads( t_square_size, t_square_size );
    kernel_chessboard<<< l_blocks, l_threads >>>( t_color_cuda_img );

    if ( ( l_cerr = cudaGetLastError() ) != cudaSuccess )
        printf( "CUDA Error [%d] - '%s'\n", __LINE__, cudaGetErrorString( l_cerr ) );

    cudaDeviceSynchronize();
}

// -----------------------------------------------------------------------------------------------

// Demo kernel to create picture with alpha channel gradient
__global__ void kernel_alphaimg( CudaImg t_color_cuda_img, uchar3 t_color )
{
    // X,Y coordinates and check image dimensions
    int l_y = blockDim.y * blockIdx.y + threadIdx.y;
    int l_x = blockDim.x * blockIdx.x + threadIdx.x;
    if ( l_y >= t_color_cuda_img.m_size.y ) return;
    if ( l_x >= t_color_cuda_img.m_size.x ) return;

    int l_diagonal = sqrtf( t_color_cuda_img.m_size.x * t_color_cuda_img.m_size.x + t_color_cuda_img.m_size.y * t_color_cuda_img.m_size.y );
    int l_dx = l_x - t_color_cuda_img.m_size.x / 2;
    int l_dy = l_y - t_color_cuda_img.m_size.y / 2;
    int l_dxy = sqrtf( l_dx * l_dx + l_dy * l_dy ) - l_diagonal / 2;

    // Store point into image
    t_color_cuda_img.m_p_uchar4[ l_y * t_color_cuda_img.m_size.x + l_x ] =
        { t_color.x, t_color.y, t_color.z, ( unsigned char ) ( 255 - 255 * l_dxy / ( l_diagonal / 2 ) ) };
}

void cu_create_alphaimg( CudaImg t_color_cuda_img, uchar3 t_color )
{
    cudaError_t l_cerr;

    // Grid creation, size of grid must be equal or greater than images
    int l_block_size = 32;
    dim3 l_blocks( ( t_color_cuda_img.m_size.x + l_block_size - 1 ) / l_block_size,
                   ( t_color_cuda_img.m_size.y + l_block_size - 1 ) / l_block_size );
    dim3 l_threads( l_block_size, l_block_size );
    kernel_alphaimg<<< l_blocks, l_threads >>>( t_color_cuda_img, t_color );

    if ( ( l_cerr = cudaGetLastError() ) != cudaSuccess )
        printf( "CUDA Error [%d] - '%s'\n", __LINE__, cudaGetErrorString( l_cerr ) );

    cudaDeviceSynchronize();
}

// -----------------------------------------------------------------------------------------------

// Demo kernel to create picture with alpha channel gradient
__global__ void kernel_insertimage( CudaImg t_big_cuda_pic, CudaImg t_small_cuda_pic, int2 t_position )
{
    // X,Y coordinates and check image dimensions
    int l_y = blockDim.y * blockIdx.y + threadIdx.y;
    int l_x = blockDim.x * blockIdx.x + threadIdx.x;
    if ( l_y >= t_small_cuda_pic.m_size.y ) return;
    if ( l_x >= t_small_cuda_pic.m_size.x ) return;
    int l_by = l_y + t_position.y;
    int l_bx = l_x + t_position.x;
    if ( l_by >= t_big_cuda_pic.m_size.y || l_by < 0 ) return;
    if ( l_bx >= t_big_cuda_pic.m_size.x || l_bx < 0 ) return;

    // Get point from small image
    uchar4 l_fg_bgra = t_small_cuda_pic.m_p_uchar4[ l_y * t_small_cuda_pic.m_size.x + l_x ];
    uchar3 l_bg_bgr = t_big_cuda_pic.m_p_uchar3[ l_by * t_big_cuda_pic.m_size.x + l_bx ];
    uchar3 l_bgr = { 0, 0, 0 };

    // compose point from small and big image according alpha channel
    l_bgr.x = l_fg_bgra.x * l_fg_bgra.w / 255 + l_bg_bgr.x * ( 255 - l_fg_bgra.w ) / 255;
    l_bgr.y = l_fg_bgra.y * l_fg_bgra.w / 255 + l_bg_bgr.y * ( 255 - l_fg_bgra.w ) / 255;
    l_bgr.z = l_fg_bgra.z * l_fg_bgra.w / 255 + l_bg_bgr.z * ( 255 - l_fg_bgra.w ) / 255;

    // Store point into image
    t_big_cuda_pic.m_p_uchar3[ l_by * t_big_cuda_pic.m_size.x + l_bx ] = l_bgr;
}

void cu_insertimage( CudaImg t_big_cuda_pic, CudaImg t_small_cuda_pic, int2 t_position )
{
    cudaError_t l_cerr;

    // Grid creation, size of grid must be equal or greater than images
    int l_block_size = 32;
    dim3 l_blocks( ( t_small_cuda_pic.m_size.x + l_block_size - 1 ) / l_block_size,
                   ( t_small_cuda_pic.m_size.y + l_block_size - 1 ) / l_block_size );
    dim3 l_threads( l_block_size, l_block_size );
    kernel_insertimage<<< l_blocks, l_threads >>>( t_big_cuda_pic, t_small_cuda_pic, t_position );

    if ( ( l_cerr = cudaGetLastError() ) != cudaSuccess )
        printf( "CUDA Error [%d] - '%s'\n", __LINE__, cudaGetErrorString( l_cerr ) );

    cudaDeviceSynchronize();
}
