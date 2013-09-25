//
//  HPPlayerNode.m
//  Knight Popper
//
//  Created by Morgan on 24/09/13.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import "HPPlayerNode.h"
#import "HPActionCategories.h"

#pragma mark - Interface

@interface HPPlayerNode ()

+ (TextureID)textureIDForType:(PlayerType)type;

@property ActionCategory category;

@end

#pragma mark - Implementation

@implementation HPPlayerNode

- (id)initWithType:(PlayerType)playerType textures:(HPTextureManager*)textures {
    TextureID identifier = [HPPlayerNode textureIDForType:playerType];
    SKTexture* texture = [textures getTexture:identifier];
    
    if (self = [super initWithTexture:texture]) {
        self.category = ActionCategoryNone;
        self.name = [HPActionCategories nodeNameForCategory:self.category];
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
