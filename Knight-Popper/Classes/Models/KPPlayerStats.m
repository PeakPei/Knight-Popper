/**
 * @filename KPPlayerStats.m
 * @author Morgan Wall
 * @date 9-11-2013
 */

#import "KPPlayerStats.h"

#pragma mark - Implementation

@implementation KPPlayerStats

- (id)init {
    if (self = [super init]) {
        _pinkTargetsHit = 0;
        _blueTargetsHit = 0;
        _goldTargetsHit = 0;
    }
    return self;
}

- (void)incrementPinkTargetHitCounter {
    _pinkTargetsHit++;
}

- (void)incrementBlueTargetHitCounter {
    _blueTargetsHit++;
}

- (void)incrementGoldTargetHitCounter {
    _goldTargetsHit++;
}

#pragma mark - Properties

@synthesize pinkTargetsHit = _pinkTargetsHit;
@synthesize blueTargetsHit = _blueTargetsHit;
@synthesize goldTargetsHit = _goldTargetsHit;

@end
