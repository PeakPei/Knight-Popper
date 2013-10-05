//
//  HHExampleState.m
//  Knight-Popper
//
//  Created by Morgan on 28/09/13.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import "KPExampleState.h"
#import "KPTargetNode.h"
#import "KPActionCategories.h"
#import "TextureIDs.h"
#import <SpriteStackKit/SSKSpriteNode.h>
#import <SpriteStackKit/SSKAction.h>
#import <SpriteStackKit/SSKActionQueue.h>


#pragma mark - Interface

@interface KPExampleState ()

- (void)addPositionDisplayActionToQueue;

- (void)addTargetMoveActionToQueue;

@property SSKActionQueue* actionQueue;

@end

#pragma mark - Implementation

@implementation KPExampleState

- (id)initWithStateStack:(SSKStateStack *)stateStack
          textureManager:(SSKTextureManager *)textureManager {
    if (self = [super initWithStateStack:stateStack textureManager:textureManager]) {
        self.actionQueue = [[SSKActionQueue alloc] init];
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
    SSKSpriteNode* background =
    [[SSKSpriteNode alloc] initWithTexture:[self.textures getTexture:TextureIDBackground]];
    background.position = CGPointZero;
    
    KPTargetNode* target = [[KPTargetNode alloc] initWithType:TargetTypeBlueMonkey
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
    
    SSKAction *action = [[SSKAction alloc] initWithCategory:ActionCategoryTarget
                                              actionBlock:garbageAction
                                             timeInterval:0];
    [self.actionQueue push:action];
}

- (void)addTargetMoveActionToQueue {
    SKAction *moveAction = [SKAction moveByX:3 y:3 duration:0];
    SSKAction *action = [[SSKAction alloc] initWithCategory:ActionCategoryTarget
                                                   action:moveAction];
    [self.actionQueue push:action];
}

#pragma mark - Properties

@synthesize actionQueue;

@end
