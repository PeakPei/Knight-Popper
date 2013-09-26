/**
 * @filename HHScene.m
 * @author Morgan Wall
 * @date 23-9-2013
 *
 * @brief The implementation of the HHScene class.
 */

#import "HHScene.h"

#pragma mark - Interface

@interface HHScene ()

@property BOOL contentCreated;

@end

#pragma mark - Implementation

@implementation HHScene

- (id)init {
    if (self = [super init]) {
        self.contentCreated = false;
    }
    return self;
}

- (void)didMoveToView:(SKView*)view {
    if (!self.contentCreated) {
        [self buildScene];
    }
}

- (void)buildScene {
    self.contentCreated = true;
}

- (void)clearScene {
    self.contentCreated = false;
}

#pragma mark - Properties

@synthesize contentCreated;

@end
