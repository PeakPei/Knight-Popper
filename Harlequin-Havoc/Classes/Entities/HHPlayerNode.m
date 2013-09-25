//
//  HPPlayerNode.m
//  Harlequin-Havoc
//
//  Created by Morgan on 24/09/13.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import "HHPlayerNode.h"
#import "HHActionCategories.h"

#pragma mark - Interface

@interface HHPlayerNode ()

+ (TextureID)textureIDForType:(PlayerType)type;

@property ActionCategory category;

@end

#pragma mark - Implementation

@implementation HHPlayerNode

- (id)initWithType:(PlayerType)playerType textures:(HHTextureManager*)textures {
    TextureID identifier = [HHPlayerNode textureIDForType:playerType];
    SKTexture* texture = [textures getTexture:identifier];
    
    if (self = [super initWithTexture:texture]) {
        self.category = ActionCategoryNone;
        self.name = [HHActionCategories nodeNameForCategory:self.category];
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.dynamic = NO;
    }
    return self;
}

+ (TextureID)textureIDForType:(PlayerType)type {
    TextureID identifier;
    
    switch (type) {
        case PlayerTypeBlue:
            identifier = TextureIDNone;
            break;
            
        case PlayerTypePink:
            identifier = TextureIDNone;
            break;
    }
    
    return identifier;
}

#pragma mark - Properties

@synthesize category;

@end
