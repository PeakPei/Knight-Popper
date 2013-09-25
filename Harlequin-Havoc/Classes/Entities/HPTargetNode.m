//
//  HPTargetNode.m
//  Knight Popper
//
//  Created by Morgan on 23/09/13.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import "HPTargetNode.h"
#import "HPActionCategories.h"

#pragma mark - Interface

@interface HPTargetNode ()

+ (TextureID)textureIDForType:(TargetType)type;

@property ActionCategory category;

@end

#pragma mark - Implementation

@implementation HPTargetNode

- (id)initWithType:(TargetType)targetType textures:(HPTextureManager*)textures {
    TextureID identifier = [HPTargetNode textureIDForType:targetType];
    SKTexture* texture = [textures getTexture:identifier];
    
    if (self = [super initWithTexture:texture]) {
        self.category = ActionCategoryNone;
        self.name = [HPActionCategories nodeNameForCategory:self.category];
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.dynamic = NO;
    }
    return self;
}

+ (TextureID)textureIDForType:(TargetType)type {
    TextureID identifier;
    
    switch (type) {
        case TargetTypeBlueMonkey:
            identifier = TextureIDNone;
            break;
            
        case TargetTypePinkMonkey:
            identifier = TextureIDNone;
            break;
    }
    
    return identifier;
}

#pragma mark - Properties

@synthesize category;

@end
