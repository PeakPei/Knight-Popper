/**
 * @filename KPBalloonPopNode.h
 * @author Morgan Wall
 * @date 11-11-2013
 *
 * @brief The base class for sprite describing a balloon pop in the scene graph 
 * of a game state.
 */

#import <SpriteStackKit/SSKSpriteAnimationNode.h>
#import <SpriteStackKit/SSKTextureManager.h>

@interface KPBalloonPopNode : SSKSpriteAnimationNode

/**
 * @brief An enumeration of the types of balloon pops.
 */
typedef enum popType {
    PopTypePink = 0,
    PopTypeBlue,
    PopTypeGold
} PopType;

/**
 * @brief Initialise a balloon pop node of a specific type.
 *
 * @param popType
 * The type of balloon pop.
 *
 * @param textures
 * A model object containing all the textures loaded for the game.
 *
 * @param timePerFrame
 * The amount of time each frame is displayed (in seconds).
 */
- (id)initWithType:(PopType)popType
          textures:(SSKTextureManager*)textures
      timePerFrame:(double)timePerFrame;

/**
 * @brief The type of projectile node.
 */
@property (readonly) PopType type;

@end