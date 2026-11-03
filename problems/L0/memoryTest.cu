#include <stdio.h>
#include <stdlib.h>

__global__ void doArrayThing(float* arr, int size)
{
    int idx = blockDim.x * blockIdx.x + threadIdx.x;

    if(idx < size)
        arr[idx] = arr[idx] + idx;
}

int main()
{
    const int arrSize = 13;
    float* hostArray, *deviceArray;
    hostArray = (float*)malloc(sizeof(float) * arrSize);
    if(hostArray == NULL)
    {
        return -1;
    }

    cudaError_t response = cudaMalloc(&deviceArray, sizeof(float)*arrSize);

    if(response != cudaSuccess)
        return -1;

    for(int i = 0; i < arrSize; i++)
    {
        hostArray[i] = 13.0f;
    }

    response = cudaMemcpy(deviceArray, hostArray, sizeof(float) * arrSize, cudaMemcpyHostToDevice);

    if(response != cudaSuccess)
    {
        cudaFree(deviceArray);
        free(hostArray);
        return -1;
    }

    doArrayThing<<<1, 32>>>(deviceArray, arrSize);

    cudaDeviceSynchronize();

    response = cudaMemcpy(hostArray, deviceArray, sizeof(float) * 13, cudaMemcpyDeviceToHost);

    if(response != cudaSuccess)
    {    
        cudaFree(deviceArray);
        free(hostArray);
        return -1;
    }

    for(int i = 0; i < arrSize; i++)
    {
        printf("%f ", hostArray[i]);
    }
    printf("\n");

    cudaFree(deviceArray);
    free(hostArray);

    return 0;
}