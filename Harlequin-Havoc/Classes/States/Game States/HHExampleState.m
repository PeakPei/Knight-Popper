//
//  HHExampleState.m
//  Harlequin-Havoc
//
//  Created by Morgan on 28/09/13.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import "HHExampleState.h"
#import "HHSpriteNode.h"
#import "HHTargetNode.h"

#import "HHAction.h"
#import "HHActionCategories.h"
#import "HHActionQueue.h"

#pragma mark - Interface

@interface HHExampleState ()

- (void)addPositionDisplayActionToQueue;

- (void)addTargetMoveActionToQueue;

@property HHActionQueue* actionQueue;

@end

#pragma mark - Implementation

@implementation HHExampleState

- (id)initWithStateStack:(HHStateStack *)stateStack
          textureManager:(HHTextureManager *)textureManager {
    if (self = [super initWithStateStack:stateStack textureManager:textureManager]) {
        self.actionQueue = [[HHActionQueue alloc] init];
    }
    return self;
}

#pragma mark HHState

- (void)update:(CFTimeInterval)deltaTime {
    if (self.isActive) {
        [self addPositionDisplayActionToQueue];
        [self addTargetMoveActionToQueue];
        
        while (![self.actionQueue isEmpty]) {
            [self onAction:[self.actionQueue pop]];
        }
    }
}

- (void)buildState {
    HHSpriteNode* background =
    [[HHSpriteNode alloc] initWithTexture:[self.textures getTexture:TextureIDBackground]];
    background.position = CGPointZero;
    
    HHTargetNode* target = [[HHTargetNode alloc] initWithType:TargetTypeBlueMonkey
                                                     textures:self.textures];
    target.position = CGPointZero;
    
    [self addChild:background];
    [self addChild:target];
}

#pragma mark Helper Methods

- (void)addPositionDisplayActionToQueue {
    void (^garbageAction)(SKNode*, CGFloat) = ^(SKNode* node, CGFloat elapsedTime) {
        NSLog(@"X: %f Y: %f", node.position.x, node.position.y);
    };
    
    HHAction *action = [[HHAction alloc] initWithCategory:ActionCategoryTarget
                                              actionBlock:garbageAction
                                             timeInterval:0];
    [self.actionQueue push:action];
}

- (void)addTargetMoveActionToQueue {
    SKAction *moveAction = [SKAction moveByX:3 y:3 duration:0];
    HHAction *action = [[HHAction alloc] initWithCategory:ActionCategoryTarget
                                                   action:moveAction];
    [self.actionQueue push:action];
}

#pragma mark - Properties

@synthesize actionQueue;

@end
