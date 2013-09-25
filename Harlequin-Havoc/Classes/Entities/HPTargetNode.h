//
//  HPTargetNode.h
//  Knight Popper
//
//  Created by Morgan on 23/09/13.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "HPTextureManager.h"

@interface HPTargetNode : SKSpriteNode

typedef enum type {
    TargetTypeBlueMonkey,
    TargetTypePinkMonkey
} TargetType;

- (id)initWithType:(TargetType)targetType textures:(HPTextureManager*)textures;

@end
