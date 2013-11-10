/**
 * @filename KPPlayerScore.m
 * @author Morgan Wall
 * @date 9-11-2013
 */

#import "KPPlayerScore.h"

#pragma mark - Implementation

@implementation KPPlayerScore

- (id)init {
    if (self = [super init]) {
        _score = 0;
    }
    return self;
}

- (void)modifyScore:(int)delta {
    int const MIN_SCORE = 0;
    if ((int)self.score + delta < MIN_SCORE) {
        [[NSException
          exceptionWithName:@"InvalidArgumentsException"
          reason:@"The score delta specified results in a negative value"
          userInfo:nil] raise];
    } else {
        [self willChangeValueForKey:@"score"];
        _score += delta;
        [self didChangeValueForKey:@"score"];
    }
}

#pragma mark - Properties

@synthesize score = _score;

@end
