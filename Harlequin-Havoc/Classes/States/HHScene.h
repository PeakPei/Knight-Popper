/**
 * @filename HHScene.h
 * @author Morgan Wall
 * @date 23-9-2013
 *
 * @brief The base class for describing a scene in the game. A scene is defined
 * as the root node in the scene graph describing a state in the game.
 */

#import <SpriteKit/SpriteKit.h>

@interface HHScene : SKScene

/**
 * @brief Construct the scene graph to describe a state in the game.
 *
 * @note Subclasses should override this method to construct the scene graph.
 * All subclasses must call the buildScene method on it's superclass.
 */
- (void)buildScene;

/**
 * @brief Deconstruct the scene graph associated with the scene.
 *
 * @note Subclasses should override this method to deconstruct the scene graph.
 * All subclasses must call the buildScene method on it's superclass.
 */
- (void)clearScene;

@end
