/**
 * @filename HHAction.h
 * @author Morgan Wall
 * @date 28-9-2013
 *
 * @brief The definition of the core data structure used in the distribution
 * of actions to various nodes within the scene graph describing the game.
 */

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#include "HHActionCategories.h"

@interface HHAction : NSObject

/**
 * @brief Initialse an in-built Sprite Kit action.
 *
 * @param category
 * The receiver category the action is intended for.
 *
 * @param action
 * The Sprite Kit action to be distributed.
 */
- (id)initWithCategory:(ActionCategory)category
                action:(SKAction*)action;

/**
 * @brief Initialse a custom action.
 *
 * @param category
 * The receiver category the action is intended for.
 *
 * @param action
 * A block describing an action to be distributed.
 */
- (id)initWithCategory:(ActionCategory)category
           actionBlock:(void(^)(SKNode*, CGFloat))actionBlock
          timeInterval:(NSTimeInterval)timeInterval;

/**
 * @brief The receiver category the action is aimed at.
 */
@property (readonly) ActionCategory category;

/**
 * @brief The action being distributed.
 */
@property (readonly) SKAction* action;

@end
