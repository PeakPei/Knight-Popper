/**
 * @filename SSKNodeRemovalHandler.h
 * @author Morgan Wall
 * @date 29-9-2013
 *
 * @brief A protocol to be implemented on any node classes that are to be included
 * as descendants to the state stack node describing the game. This protocol is 
 * used to manage the removal of nodes from portions of the tree graph that 
 * describes the entire game at any point in time.
 */

#import <Foundation/Foundation.h>

@protocol SSKNodeRemovalHandler <NSObject>

@required

/**
 * @brief Determine if the node has been destroyed.
 *
 * @returns true if the node has been flagged for removal, otherwise false.
 */
- (BOOL)isDestroyed;

/**
 * @brief Flag the node for removal from the tree.
 */
- (void)destroy;

/**
 * @brief Remove any nodes from the tree that have been flagged for removal.
 */
- (void)executeRemovalRequests;

@end
