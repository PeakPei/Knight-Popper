/**
 * @filename KPTargetNode.m
 * @author Morgan Wall
 * @date 23-9-2013
 */

#import "KPTargetNode.h"
#import "TextureIDs.h"
#import "KPActionCategories.h"
#import "ColliderTypes.h"
#import "PathParser.h"

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

- (id)initWithType:(TargetType)targetType
          textures:(SSKTextureManager*)textures
      timePerFrame:(double)timePerFrame {
    
    unsigned int const COLUMNS = 8;
    unsigned int const ROWS = 3;
    unsigned int const NUM_FRAMES = 20;
    BOOL const HORIZONTAL_ORDER = YES;
    
    TextureID spriteSheetID = [KPTargetNode textureIDForType:targetType];
    
    if (self = [super initWithSpriteSheet:[textures getTexture:spriteSheetID]
                                  columns:COLUMNS
                                     rows:ROWS
                                numFrames:NUM_FRAMES
                          horizontalOrder:HORIZONTAL_ORDER
                             timePerFrame:timePerFrame]) {
        _type = targetType;
        
        NSString* filename = TargetTypeBlueMonkey ? @"pink_monkey"
                                                  : @"blue_gold_monkeys";
        
        NSArray* paths =
            [PathParser parsePaths:filename columns:COLUMNS rows:ROWS
            numFrames:NUM_FRAMES horizontalOrder:HORIZONTAL_ORDER
            width:self.frame.size.width height:self.frame.size.height];
        
        SKPhysicsBody* physicsBody =
            [SKPhysicsBody bodyWithPolygonFromPath:(__bridge CGPathRef)(paths[0])];
        physicsBody.dynamic = YES;
        physicsBody.affectedByGravity = NO;
        physicsBody.categoryBitMask = ColliderTypeTarget;
        physicsBody.contactTestBitMask = ColliderTypeProjectile | ColliderTypeTarget;
        [self setPhysicsBody:physicsBody];
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

@synthesize type = _type;
@synthesize category;

@end