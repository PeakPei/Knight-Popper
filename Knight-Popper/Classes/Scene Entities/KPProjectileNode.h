/**
 * @filename KPProjectileNode.h
 * @author Morgan Wall
 * @date 10-11-2013
 *
 * @brief The base class for sprite describing a projectile in the scene graph of
 * a game state.
 */

#import <SpriteStackKit/SSKSpriteNode.h>
#import <SpriteStackKit/SSKTextureManager.h>

@interface KPProjectileNode : SSKSpriteNode

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
 */
- (id)initWithType:(ProjectileType)projectileType
          textures:(SSKTextureManager*)textures;

/**
 * @brief The type of projectile node.
 */
@property (readonly) ProjectileType type;

@end
