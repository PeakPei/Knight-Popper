/**
 * @filename KPTargetNode.h
 * @author Morgan Wall
 * @date 23-9-2013
 *
 * @brief The base class for sprite describing a target in the scene graph of
 * a game state.
 */

#import <SpriteStackKit/SSKSpriteNode.h>
#import <SpriteStackKit/SSKTextureManager.h>

@interface KPTargetNode : SSKSpriteNode

/**
 * @brief An enumeration of the types of targets.
 */
typedef enum targetType {
    TargetTypeBlueMonkey = 0,
    TargetTypePinkMonkey,
    TargetTypeGoldMonkey
} TargetType;

/**
 * @brief Initialise a target node with a specific target type and texture.
 *
 * @param targetType
 * The type of target.
 *
 * @param textures
 * A model object containing all the textures loaded for the game.
 */
- (id)initWithType:(TargetType)targetType
          textures:(SSKTextureManager*)textures;

/**
 * @brief The type of target node.
 */
@property (readonly) TargetType type;

/**
 * @brief Denotes if the target has collided with a projectile.
 */
@property BOOL collided;

@end