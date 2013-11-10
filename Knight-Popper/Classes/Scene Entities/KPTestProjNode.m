//
//  KPTestProjNode.m
//  Knight-Popper
//
//  Created by Morgan on 10/11/2013.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import "KPTestProjNode.h"
#import "ColliderTypes.h"

@implementation KPTestProjNode

- (id)initWithTexture:(SKTexture *)texture {
    if (self = [super initWithTexture:texture]) {
        SKPhysicsBody* physicsBody =
        [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
        physicsBody.dynamic = YES;
        physicsBody.affectedByGravity = NO;
        physicsBody.categoryBitMask = ColliderTypeProjectile;
        physicsBody.contactTestBitMask = ColliderTypeTarget;
        [self setPhysicsBody:physicsBody];
    }
    return self;
}

- (unsigned int)getColliderCategory {
    return ColliderTypeProjectile;
}


@end
