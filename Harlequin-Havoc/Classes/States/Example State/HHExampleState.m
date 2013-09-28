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

- (void)buildStateScene {
    [super buildStateScene];
    
    HHSpriteNode* background =
        [[HHSpriteNode alloc] initWithTexture:[self.textures getTexture:TextureIDBackground]];
    background.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    
    HHTargetNode* target = [[HHTargetNode alloc] initWithType:TargetTypeBlueMonkey
                                                      textures:self.textures];
    target.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    
    [self addChild:background];
    [self addChild:target];
}

- (void)clearStateScene {
    [super clearStateScene];
}

@end
