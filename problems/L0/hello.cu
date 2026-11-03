#include <stdio.h>

__global__ void printFromGpu()
{
    printf("Hello!\n");
}

int main()
{
    printFromGpu<<<1, 1>>>();

    cudaDeviceSynchronize();
}