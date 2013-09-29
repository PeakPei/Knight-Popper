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

@implementation HHExampleState

#pragma mark - HHState

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

@end
