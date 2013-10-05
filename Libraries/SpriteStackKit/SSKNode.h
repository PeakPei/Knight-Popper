/**
 * @filename KPNode.h
 * @author Morgan Wall
 * @date 28-9-2013
 *
 * @brief The base class for a node stored in the state stack. This replaces the
 * usage of the SKNode class.
 *
 * @note The action category for this base class is the empty string "".
 */

#import <SpriteKit/SpriteKit.h>
#import <SpriteStackKit/SSKActionHandler.h>
#import <SpriteStackKit/SSKEventHandler.h>
#import <SpriteStackKit/SSKNodeRemovalHandler.h>

@interface SSKNode : SKNode <SSKActionHandler, SSKEventHandler, SSKNodeRemovalHandler>

@end
