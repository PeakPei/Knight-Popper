/**
 * @filename KPTextureManager.h
 * @author Morgan Wall
 * @date 23-8-2013
 *
 * @brief The model object used to store all the texture assets not used for
 * animation. These assets are heavy-weight in terms of their
 * memory requirements, hence the purpose of this class is to avoid their
 * reallocation during execution.
 *
 * @note For storing textures used for animation see the SKTextureAtlas class.
 */

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface SSKTextureManager : NSObject

/**
 * @brief Initialise a texture manager with a pre-allocated size.
 *
 * @param count 
 * The number of textures to be pre-allocated for.
 *
 * @note Any natural number can be specified for ::count. Ideally, however,
 * a slight performance gain can be made be specifying an appropriate value.
 */
- (id)initWithTextureCount:(unsigned int)count;

/**
 * @brief Retrieve a texture resource.
 *
 * @param identifier
 * The unique identifier for the texture resource.
 *
 * @throws NSException
 * If a texture does not exist with ::identifier as a unique id.
 *
 * @returns The resource specified by ::identifier.
 */
- (SKTexture*)getTexture:(unsigned int)identifier;

/**
 * @brief Load a resource into the manager.
 *
 * @param textureName
 * The name of the texture to be loaded into the manager (from the app bundle).
 *
 * @param identifier
 * The unique identifier used to denote the texture being loaded.
 *
 * @throws NSException
 * If a texture is already manager with ::identifier as a unique id.
 */
- (void)loadTexture:(NSString*)textureName identifier:(unsigned int)identifier;

@end
