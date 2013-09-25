//
//  HPProjectileNode.m
//  Harlequin-Havoc
//
//  Created by Morgan on 23/09/13.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import "HHProjectileNode.h"
#import "HHActionCategories.h"
#include "TextureIDs.h"

#pragma mark - Interface

@interface HHProjectileNode ()

+ (TextureID)textureIDForType:(ProjectileType)type;

@property ActionCategory category;

@end

#pragma mark - Implementation

@implementation HHProjectileNode

- (id)initWithType:(ProjectileType)projectileType textures:(HHTextureManager*)textures {
    TextureID identifier = [HHProjectileNode textureIDForType:projectileType];
    SKTexture* texture = [textures getTexture:identifier];
    
    if (self = [super initWithTexture:texture]) {
        self.category = ActionCategoryNone;
        self.name = [HHActionCategories nodeNameForCategory:self.category];
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.dynamic = YES;
    }
    return self;
}

+ (TextureID)textureIDForType:(ProjectileType)type {
    TextureID identifier;
    
    switch (type) {
        case ProjectileTypeLollipop:
            identifier = TextureIDNone;
            break;
    }
    
    return identifier;
}

#pragma mark - Properties

@synthesize category;

@end
