/**
 * @filename SKNode+TreeTraversal.h
 * @author Morgan Wall
 * @date 29-9-2013
 *
 * @brief A category that allows various operations to be undertaken on the 
 * scene graph of a Sprite Kit game using various traversal orderings.
 */

#import <SpriteKit/SpriteKit.h>

@interface SKNode (TreeTraversal)

/**
 * @brief Perform an operation on the scene graph in pre-root ordering.
 *
 * @param action
 * The operation to be executed on the nodes of the scene graph until it has
 * been fully handled.
 *
 * @returns true if the action has been fully handled by the node, otherwise
 * false.
 *
 * @note Given that the scene graph is not a binary tree, pre-root ordering is
 * defined by considering the root node then the children nodes, recursively,
 * from first added to last added.
 */
- (BOOL)traversePreOrder:(BOOL (^)(SKNode*))action;

/**
 * @brief Perform an operation on the scene graph in post-root ordering.
 *
 * @param action
 * The operation to be executed on the nodes of the scene graph until it has
 * been fully handled.
 *
 * @returns true if the action has been fully handled by the node, otherwise
 * false.
 *
 * @note Given that the scene graph is not a binary tree, post-root ordering is
 * defined by considering the children nodes, recursively, from the last added
 * to the first added followed by the root node.
 */
- (BOOL)traversePostOrder:(BOOL (^)(SKNode*))action;

@end
