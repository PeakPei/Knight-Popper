/**
 * @filename KPProjectileNode.h
 * @author Morgan Wall
 * @date 10-11-2013
 *
 * @brief The base class for sprite describing a projectile in the scene graph of
 * a game state.
 */

#import <SpriteStackKit/SSKSpriteAnimationNode.h>
#import <SpriteStackKit/SSKTextureManager.h>

@interface KPProjectileNode : SSKSpriteAnimationNode

/**
 * @brief An enumeration of the types of projectiles.
 */
typedef enum projectileType {
    ProjectileTypeLeft = 0,
    ProjectileTypeRight
} ProjectileType;

/**
 * @brief Initialise a projectile node with a specific target type and texture.
 *
 * @param projectileType
 * The type of projectile.
 *
 * @param textures
 * A model object containing all the textures loaded for the game.
 *
 * @param timePerFrame
 * The amount of time each frame is displayed (in seconds).
 */
- (id)initWithType:(ProjectileType)projectileType
          textures:(SSKTextureManager*)textures
      timePerFrame:(double)timePerFrame;

/**
 * @brief The type of projectile node.
 */
@property ProjectileType type;

@end
