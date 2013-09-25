//
//  HPProjectileNode.m
//  Knight Popper
//
//  Created by Morgan on 23/09/13.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import "HPProjectileNode.h"
#import "HPActionCategories.h"
#include "TextureIDs.h"

#pragma mark - Interface

@interface HPProjectileNode ()

+ (TextureID)textureIDForType:(ProjectileType)type;

@property ActionCategory category;

@end

#pragma mark - Implementation

@implementation HPProjectileNode

- (id)initWithType:(ProjectileType)projectileType textures:(HPTextureManager*)textures {
    TextureID identifier = [HPProjectileNode textureIDForType:projectileType];
    SKTexture* texture = [textures getTexture:identifier];
    
    if (self = [super initWithTexture:texture]) {
        self.category = ActionCategoryNone;
        self.name = [HPActionCategories nodeNameForCategory:self.category];
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
