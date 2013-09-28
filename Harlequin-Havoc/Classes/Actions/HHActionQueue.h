/**
 * @filename HHActionQueue.h
 * @author Morgan Wall
 * @date 28-9-2013
 *
 * @brief The abstract data type used to distribute actions inside the state stack.
 */

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#include "HHAction.h"

@interface HHActionQueue : NSObject

/**
 * @brief Insert an action into the queue.
 *
 * @param action
 * The action to be inserted.
 */
- (void)push:(HHAction*)action;

/**
 * @brief Retrieve an action from the front of the queue.
 *
 * @returns The action at the front of the queue.
 */
- (HHAction*)pop;

/**
 * @brief Check if the queue contains any actions.
 *
 * @returns true if the queue contains actions, otherwise false.
 */
- (BOOL)isEmpty;

@end
