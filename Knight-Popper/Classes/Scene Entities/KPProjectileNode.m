/**
 * @filename KPProjectileNode.m
 * @author Morgan Wall
 * @date 10-11-2013
 */

#import "KPProjectileNode.h"
#import "KPActionCategories.h"
#import "TextureIDs.h"
#import "ColliderTypes.h"
#import "PathParser.h"

#pragma mark - Interface

@interface KPProjectileNode()

/**
 * @brief Retrieve the unique texture identifier associated with a specific
 * projectile type.
 *
 * @param projectileType
 * The projectile type.
 *
 * @returns The unique texture identifier associated with the projectile type.
 */
+ (TextureID)textureIDForType:(ProjectileType)type;

/**
 * @brief The category defining the actions handled by the node.
 */
@property ActionCategory category;

@end

#pragma mark - Implementation

@implementation KPProjectileNode

- (id)initWithType:(ProjectileType)projectileType
          textures:(SSKTextureManager*)textures
      timePerFrame:(double)timePerFrame {
    
    unsigned int const COLUMNS = 3;
    unsigned int const ROWS = 3;
    unsigned int const NUM_FRAMES = 8;
    BOOL const HORIZONTAL_ORDER = YES;
    
    TextureID spriteSheetID = [KPProjectileNode textureIDForType:projectileType];
    
    if (self = [super initWithSpriteSheet:[textures getTexture:spriteSheetID]
                                  columns:COLUMNS
                                     rows:ROWS
                                numFrames:NUM_FRAMES
                          horizontalOrder:HORIZONTAL_ORDER
                             timePerFrame:timePerFrame]) {
        NSString* filename = ProjectileTypeLeft ? @"lollipop_right_projectile"
                                                : @"lollipop_left_projectile";
        
        NSArray* paths = [PathParser parsePaths:filename columns:COLUMNS rows:ROWS
                          numFrames:NUM_FRAMES horizontalOrder:HORIZONTAL_ORDER
                          width:self.frame.size.width height:self.frame.size.height];
        
        SKPhysicsBody* physicsBody =
            [SKPhysicsBody bodyWithPolygonFromPath:(__bridge CGPathRef)(paths[0])];
        physicsBody.dynamic = YES;
        physicsBody.affectedByGravity = NO;
        physicsBody.categoryBitMask = ColliderTypeProjectile;
        physicsBody.contactTestBitMask = ColliderTypeTarget | ColliderTypeProjectile;
        [self setPhysicsBody:physicsBody];
    }
    
    return self;
}

+ (TextureID)textureIDForType:(ProjectileType)type {
    TextureID identifier;
    
    switch (type) {
        case ProjectileTypeLeft:
            identifier = TextureIDLollipopLeftProjectile;
            break;
            
        case ProjectileTypeRight:
            identifier = TextureIDLollipopRightProjectile;
            break;
    }
    
    return identifier;
}

#pragma mark SSKSpriteNode

- (unsigned int)getActionCategory {
    return ActionCategoryProjectile;
}

#pragma mark - Properties

@synthesize type;
@synthesize category;

@end
