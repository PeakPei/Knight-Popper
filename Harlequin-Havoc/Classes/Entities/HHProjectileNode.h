//
//  HPProjectileNode.h
//  Harlequin-Havoc
//
//  Created by Morgan on 23/09/13.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "HHTextureManager.h"

@interface HHProjectileNode : SKSpriteNode

typedef enum type {
    ProjectileTypeLollipop
} ProjectileType;

- (id)initWithType:(ProjectileType)projectileType textures:(HHTextureManager*)textures;

@end
