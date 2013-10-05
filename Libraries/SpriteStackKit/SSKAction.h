/**
 * @filename KPAction.h
 * @author Morgan Wall
 * @date 28-9-2013
 *
 * @brief The definition of the core data structure used in the distribution
 * of actions to various nodes within the scene graph describing the game.
 */

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface SSKAction : NSObject

/**
 * @brief Initialse an in-built Sprite Kit action.
 *
 * @param category
 * The receiver category the action is intended for.
 *
 * @param action
 * The Sprite Kit action to be distributed.
 */
- (id)initWithCategory:(unsigned int)category
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
- (id)initWithCategory:(unsigned int)category
           actionBlock:(void(^)(SKNode*, CGFloat))actionBlock
          timeInterval:(NSTimeInterval)timeInterval;

/**
 * @brief Retrieve the default action category.
 *
 * @returns the default action category (an empty string).
 *
 * @note This action category is used for base scene entities in the scene graph
 * and should not be used in subclasses of said entities. Instead, meaningful
 * identifiers should be used instead.
 */
+ (unsigned int)defaultActionCategory;

/**
 * @brief The receiver category the action is aimed at.
 */
@property (readonly) unsigned int category;

/**
 * @brief The action being distributed.
 */
@property (readonly) SKAction* action;

@end
