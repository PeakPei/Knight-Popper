//
//  HPProjectileNode.h
//  Knight Popper
//
//  Created by Morgan on 23/09/13.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "HPTextureManager.h"

@interface HPProjectileNode : SKSpriteNode

typedef enum type {
    ProjectileTypeLollipop
} ProjectileType;

- (id)initWithType:(ProjectileType)projectileType textures:(HPTextureManager*)textures;

@end
