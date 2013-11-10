/**
 * @filename KPPlayerNode.h
 * @author Morgan Wall
 * @date 10-11-2013
 *
 * @brief The base class for sprite describing a player in the scene graph of
 * a game state.
 */

#import <SpriteStackKit/SSKSpriteAnimationNode.h>
#import <SpriteStackKit/SSKTextureManager.h>

@interface KPPlayerNode : SSKSpriteAnimationNode

/**
 * @brief An enumeration of the types of projectiles.
 */
typedef enum playerType {
    PlayerTypeLeft = 0,
    PlayerTypeRight
} PlayerType;

/**
 * @brief Initialise a player node of a specific type.
 *
 * @param playerType
 * The type of player.
 *
 * @param textures
 * A model object containing all the textures loaded for the game.
 *
 * @param timePerFrame
 * The amount of time each frame is displayed (in seconds).
 */
- (id)initWithType:(PlayerType)playerType
          textures:(SSKTextureManager*)textures
      timePerFrame:(double)timePerFrame;

/**
 * @brief The type of projectile node.
 */
@property (readonly) PlayerType type;

@end