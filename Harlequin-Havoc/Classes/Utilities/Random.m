/**
 * @file Random.cpp
 * @author Malcolm Corney, Morgan Wall
 * @date 23-9-2013
 *
 * @brief Implementation of the Random class.
 */

#import "Random.h"
#include <stdlib.h>
#include <time.h>

@implementation Random

- (id)init {
    if (self = [super init]) {
        srand((int)time(NULL));
    }
    return self;
}

- (int)generateInteger:(int)lowerBound upperBound:(int)upperBound {
    double d = (double)(rand()) / ((double)RAND_MAX + 1);
    int k = (int)(d * (upperBound - lowerBound  + 1));
    return lowerBound + k;
}

- (double)generateDouble:(double)lowerBound upperBound:(double)upperBound {
    double d = (double)(rand()) / ((double)RAND_MAX + 1);
	return lowerBound + d * (upperBound - lowerBound);
}

- (BOOL)generateBool:(double)probability {
    return [self generateDouble:0 upperBound:1] < probability;
}

@end
