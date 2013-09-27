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
    
    SKSpriteNode* background = [[SKSpriteNode alloc] initWithImageNamed:@"background.png"];
    background.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    [background setSize:CGSizeMake(1024, 768)];
    
    [self addChild:background];
}

- (void)clearStateScene {
    [super clearStateScene];
}

@end
