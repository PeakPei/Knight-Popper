//
//  HPTargetNode.m
//  Harlequin-Havoc
//
//  Created by Morgan on 23/09/13.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import "HHTargetNode.h"
#import "HHActionCategories.h"

#pragma mark - Interface

@interface HHTargetNode ()

+ (TextureID)textureIDForType:(TargetType)type;

@property ActionCategory category;

@end

#pragma mark - Implementation

@implementation HHTargetNode

- (id)initWithType:(TargetType)targetType textures:(HHTextureManager*)textures {
    TextureID identifier = [HHTargetNode textureIDForType:targetType];
    SKTexture* texture = [textures getTexture:identifier];
    
    if (self = [super initWithTexture:texture]) {
        self.category = ActionCategoryNone;
        self.name = [HHActionCategories nodeNameForCategory:self.category];
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
