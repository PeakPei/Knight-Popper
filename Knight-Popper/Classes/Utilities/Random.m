/**
 * @file Random.cpp
 * @author Morgan Wall
 * @date 23-9-2013
 *
 * @brief The implementation of the Random class.
 */

#import "Random.h"
#include <stdlib.h>

@implementation Random

+ (int)generateInteger:(int)lowerBound upperBound:(int)upperBound {
    if (lowerBound > upperBound) {
        [[NSException
          exceptionWithName:@"InvalidArgumentsException"
          reason:@"lowerBound must be less than or equal to upperBound"
          userInfo:nil] raise];
    }
    
    u_int32_t range = abs(upperBound - lowerBound) + 1;
    u_int32_t randNum = arc4random_uniform(range);
    return (int)(lowerBound + randNum);
}

+ (long double)generateDouble:(double)lowerBound
                   upperBound:(double)upperBound {
    long double randNum =
        (long double)(arc4random()) / ((long double)UINT32_MAX + 1);
	return lowerBound + randNum * (upperBound - lowerBound);
}

+ (BOOL)generateBool:(double)probability {
    if (probability > 1.0 || probability < 0.0) {
        [[NSException
          exceptionWithName:@"InvalidArgumentsException"
          reason:@"probability must be between 0.0 and 1.0 inclusive"
          userInfo:nil] raise];
    }
    
    return [self generateDouble:0 upperBound:1] < probability;
}

@end
