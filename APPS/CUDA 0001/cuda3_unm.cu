// ***********************************************************************
//
// Demo program for education in subject
// Computer Architectures and Paralel Systems.
// Petr Olivka, dep. of Computer Science, FEI, VSB-TU Ostrava, 2020/11
// email:petr.olivka@vsb.cz
//
// Example of CUDA Technology Usage with unified memory.
//
// Manipulation with prepared image.
//
// ***********************************************************************

#include <cuda_device_runtime_api.h>
#include <cuda_runtime.h>
#include <stdio.h>
#include "cuda_img.h"


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

__global__ void kernel_resize(uchar3 *original, uchar3 *resize, int sizex, int sizey, int sizex1, int sizey1) 
{
	int x = blockDim.x * blockIdx.x + threadIdx.x;
	int y = blockDim.y * blockIdx.y + threadIdx.y;
    if ( x >= sizex ) return;
    if ( y >= sizey ) return;
    
	uchar3 pixel1 = original[y*2 * sizex + x*2];
	uchar3 pixel2 = original[(y*2 + 1) * sizex + x*2 + 1];

	resize[y * sizex1 + x].x = (pixel1.x + pixel2.x) / 9;
	resize[y * sizex1 + x].y = (pixel1.y + pixel2.y) / 9;
	resize[y * sizex1 + x].z = (pixel1.z + pixel2.z) / 9;
}

uchar3* resizeImage(uchar3 *img, int sizex, int sizey, int sizex1, int sizey1) 
{
	uchar3 *picture = new uchar3[sizex1 * sizey1];

	uchar3 *original = NULL;
	uchar3 *resize = NULL;
	cerr = cudaMalloc(&original, sizeof(uchar3) * sizex * sizey);
	cerr = cudaMalloc(&resize, sizeof(uchar3) * sizex1 * sizey1);

	cerr = cudaMemcpy(original, img, sizeof(uchar3) * sizex * sizey, cudaMemcpyHostToDevice);

	int count = 10;
	dim3 blocks((sizex1 + count)/ count, (sizey1 + count) / count);
	dim3 threads(count, count);
	kernel_resize<<<blocks, threads>>>(original, resize, sizex, sizey, sizex1, sizey1);
	cerr = cudaPeekAtLastError();
	cerr = cudaMemcpy(picture, resize, sizeof(uchar3)*sizex1*sizey1, cudaMemcpyDeviceToHost);
	cerr = cudaFree(original);
	cerr = cudaFree(resize);

	return picture;
}