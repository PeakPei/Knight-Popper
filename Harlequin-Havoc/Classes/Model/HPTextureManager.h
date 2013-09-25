//
//  HPTextureManager.h
//  Knight Popper
//
//  Created by Morgan on 23/09/13.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "TextureIDs.h"

@interface HPTextureManager : NSObject

/**
 * @brief Initialise a texture manager with a pre-allocated size.
 *
 * @param count 
 * The number of textures to be pre-allocated for.
 *
 * @note Any natural number can be specified for ::count. Ideally, however,
 * a slight performance gain can be made be specifying an appropriate value.
 */
- (id)initWithTextureCount:(TextureID)count;

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
- (SKTexture*)getTexture:(TextureID)identifier;

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
- (void)loadTexture:(NSString*)textureName identifier:(TextureID)identifier;

@end
