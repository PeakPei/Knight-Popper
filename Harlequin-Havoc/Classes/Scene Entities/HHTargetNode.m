/**
 * @filename HHTargetNode.m
 * @author Morgan Wall
 * @date 23-9-2013
 *
 * @brief The implementation of the HHTargetNode class.
 */

#import "HHTargetNode.h"
#import "HHActionCategories.h"

#pragma mark - Interface

@interface HHTargetNode ()

/**
 * @brief Retrieve the unique texture identifier associated with a specific 
 * target type.
 *
 * @param targetType
 * The target type.
 *
 * @returns The unique texture identifier associated with the target type.
 */
+ (TextureID)textureIDForType:(TargetType)type;

/**
 * @brief The category defining the actions handled by the node.
 */
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
            identifier = TextureIDTarget;
            break;
            
        case TargetTypePinkMonkey:
            identifier = TextureIDTarget;
            break;
    }
    
    return identifier;
}

#pragma mark HHSpriteNode

- (ActionCategory)getActionCategory {    
    return ActionCategoryTarget;
}

#pragma mark - Properties

@synthesize category;

@end
