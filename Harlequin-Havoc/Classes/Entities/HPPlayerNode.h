//
//  HPPlayerNode.h
//  Knight Popper
//
//  Created by Morgan on 24/09/13.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "HPTextureManager.h"

@interface HPPlayerNode : SKSpriteNode

typedef enum type {
    PlayerTypeBlue,
    PlayerTypePink
} PlayerType;

- (id)initWithType:(PlayerType)playerType textures:(HPTextureManager*)textures;

@end
