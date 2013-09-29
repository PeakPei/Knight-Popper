/**
 * @filename HHState.m
 * @author Morgan Wall
 * @date 27-9-2013
 *
 * @brief The implementation of the HHState class.
 */

#import "HHState.h"

#pragma mark - Interface

@interface HHState ()

/**
 * @brief The state stack to which the state belongs.
 */
@property HHStateStack* stack;

@end

#pragma mark - Implementation

@implementation HHState

- (id)initWithStateStack:(HHStateStack*)stateStack
                textureManager:(HHTextureManager*)textureManager {
    if (self = [super init]) {
        self.stack = stateStack;
        self.isActive = YES;
        self.textures = textureManager;
    }
    return self;
}

- (void)requestStackPush:(StateID)stateID {
    [self.stack pushState:stateID];
}

- (void)requestStackPop {
    [self.stack popState];
}

- (void)requestStackClear {
    [self.stack clearStates];
}

- (void)update:(CFTimeInterval)deltaTime {
    // override in subclass
}

#pragma mark HHStateStackHandler

- (void)buildState {
    // override in subclass
}

#pragma mark - Properties

@synthesize isActive;
@synthesize textures;
@synthesize stack;

@end
