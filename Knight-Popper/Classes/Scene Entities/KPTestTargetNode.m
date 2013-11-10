//
//  KPTestTargetNode.m
//  Knight-Popper
//
//  Created by Morgan on 10/11/2013.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import "KPTestTargetNode.h"
#import "ColliderTypes.h"

@implementation KPTestTargetNode

- (id)initWithSpriteSheet:(SKTexture*)spriteSheet
                  columns:(unsigned int)columns
                     rows:(unsigned int)rows
                numFrames:(unsigned int)numFrames
          horizontalOrder:(BOOL)horizontalOrder
             timePerFrame:(double)timePerFrame {
    if (self = [super initWithSpriteSheet:spriteSheet
                                  columns:columns
                                     rows:rows
                                numFrames:numFrames
                          horizontalOrder:horizontalOrder
                             timePerFrame:timePerFrame]) {
        SKPhysicsBody* physicsBody =
            [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
        physicsBody.dynamic = YES;
        physicsBody.affectedByGravity = NO;
        physicsBody.categoryBitMask = ColliderTypeTarget;
        physicsBody.contactTestBitMask = ColliderTypeProjectile;
        [self setPhysicsBody:physicsBody];
    }
    return self;
}

- (unsigned int)getColliderCategory {
    return ColliderTypeTarget;
}

@end
