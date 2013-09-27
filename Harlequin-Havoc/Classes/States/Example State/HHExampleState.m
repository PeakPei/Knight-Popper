//
//  HHExampleState.m
//  Harlequin-Havoc
//
//  Created by Morgan on 28/09/13.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import "HHExampleState.h"

@implementation HHExampleState

- (void)buildStateScene {
    [super buildStateScene];
    
    SKSpriteNode* background =
        [[SKSpriteNode alloc] initWithTexture:[self.textures getTexture:TextureIDBackground]];
    background.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    
    [self addChild:background];
}

- (void)clearStateScene {
    [super clearStateScene];
}

@end
