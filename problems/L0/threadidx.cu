#include <stdio.h>

__global__ void printIndex()
{
    int idx = blockDim.x * blockIdx.x + threadIdx.x;

    printf("My id: %d\n", idx);
}

int main()
{
    printIndex<<<1, 32>>>();

    cudaDeviceSynchronize();
}