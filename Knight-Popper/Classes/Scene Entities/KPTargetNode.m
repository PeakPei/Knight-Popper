/**
 * @filename KPTargetNode.m
 * @author Morgan Wall
 * @date 23-9-2013
 */

#define MASS 0.324426

#import "KPTargetNode.h"
#import "TextureIDs.h"
#import "KPActionCategories.h"
#import "ColliderTypes.h"
#import "PathParser.h"
#import <SpriteStackKit/SSKSpriteAnimationNode.h>

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
          textures:(SSKTextureManager*)textures {
    TextureID textureID = [KPTargetNode textureIDForType:targetType];

    if (self = [super initWithTexture:[textures getTexture:textureID]]) {
    
        _type = targetType;
        
        if (self.type == TargetTypeGoldMonkey) {
            SSKSpriteAnimationNode* twinkle =
                [[SSKSpriteAnimationNode alloc]
                 initWithSpriteSheet:[textures getTexture:TextureIDGoldTwinkle]
                 columns:8 rows:2 numFrames:16 horizontalOrder:YES
                 timePerFrame:1.0/14.0];
            twinkle.anchorPoint = CGPointMake(0,1);
            twinkle.position = CGPointMake(-self.frame.size.width/2 + 10,
                                           self.frame.size.height/2 - 10);
            [self addChild:twinkle];
            [twinkle animate];
        }
        
        NSString* filename = TargetTypeBlueMonkey ? @"pink_monkey"
                                                  : @"blue_gold_monkeys";
        
        NSArray* paths =
            [PathParser parsePaths:filename columns:1 rows:1
            numFrames:1 horizontalOrder:YES
            width:self.frame.size.width height:self.frame.size.height];
        
        SKPhysicsBody* physicsBody =
            [SKPhysicsBody bodyWithPolygonFromPath:(__bridge CGPathRef)(paths[0])];
        physicsBody.dynamic = YES;
        physicsBody.affectedByGravity = NO;
        physicsBody.mass = MASS;
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
            
        case TargetTypeGoldMonkey:
            identifier = TextureIDGoldMonkeyTarget;
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