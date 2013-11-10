/**
 * @filename KPTargetNode.h
 * @author Morgan Wall
 * @date 23-9-2013
 *
 * @brief The base class for sprite describing a target in the scene graph of
 * a game state.
 */

#import <SpriteStackKit/SSKSpriteAnimationNode.h>
#import <SpriteStackKit/SSKTextureManager.h>

@interface KPTargetNode : SSKSpriteAnimationNode

/**
 * @brief An enumeration of the types of targets.
 */
typedef enum targetType {
    TargetTypeBlueMonkey = 0,
    TargetTypePinkMonkey
} TargetType;

/**
 * @brief Initialise a target node with a specific target type and texture.
 *
 * @param targetType
 * The type of target.
 *
 * @param textures
 * A model object containing all the textures loaded for the game.
 *
 * @param timePerFrame
 * The amount of time each frame is displayed (in seconds).
 */
- (id)initWithType:(TargetType)targetType
          textures:(SSKTextureManager*)textures
      timePerFrame:(double)timePerFrame;

/**
 * @brief The type of target node.
 */
@property (readonly) TargetType type;

@end