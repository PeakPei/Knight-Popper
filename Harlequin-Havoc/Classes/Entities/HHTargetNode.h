//
//  HPTargetNode.h
//  Harlequin-Havoc
//
//  Created by Morgan on 23/09/13.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "HHTextureManager.h"

@interface HHTargetNode : SKSpriteNode

typedef enum type {
    TargetTypeBlueMonkey,
    TargetTypePinkMonkey
} TargetType;

- (id)initWithType:(TargetType)targetType textures:(HHTextureManager*)textures;

@end
