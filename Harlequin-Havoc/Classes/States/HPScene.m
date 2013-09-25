//
//  HPScene.m
//  Knight Popper
//
//  Created by Morgan on 23/09/13.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import "HPScene.h"

#pragma mark - Interface

@interface HPScene ()

@property BOOL contentCreated;

@end

#pragma mark - Implementation

@implementation HPScene

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
