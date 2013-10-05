/**
 * @filename KPActionQueue.h
 * @author Morgan Wall
 * @date 28-9-2013
 *
 * @brief The abstract data type used to distribute actions inside the state stack.
 */

#import <Foundation/Foundation.h>
#include <SpriteStackKit/SSKAction.h>

@interface SSKActionQueue : NSObject

/**
 * @brief Insert an action into the queue.
 *
 * @param action
 * The action to be inserted.
 */
- (void)push:(SSKAction*)action;

/**
 * @brief Retrieve an action from the front of the queue.
 *
 * @returns The action at the front of the queue.
 */
- (SSKAction*)pop;

/**
 * @brief Check if the queue contains any actions.
 *
 * @returns true if the queue contains actions, otherwise false.
 */
- (BOOL)isEmpty;

@end
