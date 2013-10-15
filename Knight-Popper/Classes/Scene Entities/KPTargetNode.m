/**
 * @filename HHTargetNode.m
 * @author Morgan Wall
 * @date 23-9-2013
 *
 * @brief The implementation of the HHTargetNode class.
 */

#import "KPTargetNode.h"
#import "TextureIDs.h"
#import "KPActionCategories.h"

#pragma mark - Interface

@interface KPTargetNode ()

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

@implementation KPTargetNode

- (id)initWithType:(TargetType)targetType textures:(SSKTextureManager*)textures {
    TextureID identifier = [KPTargetNode textureIDForType:targetType];
    SKTexture* texture = [textures getTexture:identifier];
    
    if (self = [super initWithTexture:texture state:NULL soundManager:NULL]) {
        self.category = ActionCategoryNone;
        self.name = [KPActionCategories nodeNameForCategory:self.category];
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.dynamic = NO;
    }
    return self;
}

+ (TextureID)textureIDForType:(TargetType)type {
    TextureID identifier;
    
    switch (type) {
        case TargetTypeBlueMonkey:
            identifier = TextureIDBlueMonkeyTarget;
            break;
            
        case TargetTypePinkMonkey:
            identifier = TextureIDPinkMonkeyTarget;
            break;
    }
    
    return identifier;
}

#pragma mark SSKSpriteNode

- (unsigned int)getActionCategory {
    return ActionCategoryTarget;
}

#pragma mark - Properties

@synthesize category;

@end