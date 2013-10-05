/**
 * @filename KPSpriteNode.h
 * @author Morgan Wall
 * @date 28-9-2013
 *
 * @brief The base class for a sprite node stored in the state stack. This 
 * replaces the usage of the SKSpriteNode class.
 *
 * @note The action category for this base class is the empty string "".
 */

#import <SpriteKit/SpriteKit.h>
#import <SpriteStackKit/SSKActionHandler.h>
#import <SpriteStackKit/SSKEventHandler.h>
#import <SpriteStackKit/SSKNodeRemovalHandler.h>

@interface SSKSpriteNode : SKSpriteNode <SSKActionHandler, SSKEventHandler,
                                        SSKNodeRemovalHandler>

@end
