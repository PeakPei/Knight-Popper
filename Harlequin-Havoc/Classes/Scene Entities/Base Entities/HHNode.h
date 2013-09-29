/**
 * @filename HHNode.h
 * @author Morgan Wall
 * @date 28-9-2013
 *
 * @brief The base class for a node stored in the state stack. This replaces the
 * usage of the SKNode class.
 */

#import <SpriteKit/SpriteKit.h>
#import "HHActionHandler.h"
#import "HHEventHandler.h"
#import "HHNodeRemovalHandler.h"

@interface HHNode : SKNode <HHActionHandler, HHEventHandler, HHNodeRemovalHandler>

@end
