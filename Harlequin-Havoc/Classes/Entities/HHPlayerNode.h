//
//  HPPlayerNode.h
//  Harlequin-Havoc
//
//  Created by Morgan on 24/09/13.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "HHTextureManager.h"

@interface HHPlayerNode : SKSpriteNode

typedef enum type {
    PlayerTypeBlue,
    PlayerTypePink
} PlayerType;

- (id)initWithType:(PlayerType)playerType textures:(HHTextureManager*)textures;

@end
