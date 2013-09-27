//
//  HHState.m
//  Harlequin-Havoc
//
//  Created by Morgan on 27/09/13.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import "HHState.h"

#pragma mark - Interface

@interface HHState ()

/**
 * @brief The state stack to which the state belongs.
 */
@property HHStateStack* stack;

@property BOOL contentCreated;

@end

#pragma mark - Implementation

@implementation HHState

- (id)initWithStateStack:(HHStateStack*)stateStack
                textureManager:(HHTextureManager*)textureManager {
    if (self = [super init]) {
        self.stack = stateStack;
        self.isActive = YES;
        self.contentCreated = NO;
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

- (void)didMoveToView:(SKView*)view {
    if (!self.contentCreated) {
        [self buildStateScene];
    }
}

- (void)buildStateScene {
    self.contentCreated = true;
}

- (void)clearStateScene {
    self.contentCreated = false;
}

#pragma mark - Properties

@synthesize isActive;
@synthesize textures;
@synthesize stack;
@synthesize contentCreated;

@end
