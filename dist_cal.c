#include<stdio.h>
#include<math.h>
#include<stdint.h>
#include <time.h>

float fabsf(float x) {
    uint32_t i = *(uint32_t *)&x;  // Read the bits of the float into an integer
    i &= 0x7FFFFFFF;               // Clear the sign bit to get the absolute value
    x = *(float *)&i;              // Write the modified bits back into the float
    return x;
}
float euclidean_distance(float p[],int dimension){
    float sum = 0;
    for(int i = 0 ; i < 3 ; i++)
        sum += p[i] * p[i];
    return sqrt(sum);
}
float manhattan_distance(float p[],int dimension){
    float sum = 0;
    for(int i = 0 ; i < dimension ; i++)
        sum += fabsf(p[i]);
    return sum;
}
float better_manhattan_distance(float p[],int dimension){
    float sum = 0;
    for(int i = 0 ; i < dimension ; i++)
        sum += fabsf(p[i]);
    return sum;
}
int main(){
    clock_t start , end;
    float p[3] = {-3.5,12.75,-5};

    //clock_gettime();

    start = clock();
    euclidean_distance(p,3);
    end = clock();

    double exetime= end - start;
    printf("the time : %f ms", exetime);
} 