/**
 * @filename HHSpriteNode.h
 * @author Morgan Wall
 * @date 28-9-2013
 *
 * @brief The base class for a sprite node stored in the state stack. This 
 * replaces the usage of the SKSpriteNode class.
 */

#import <SpriteKit/SpriteKit.h>
#import "HHActionHandler.h"
#import "HHEventHandler.h"
#import "HHNodeRemovalHandler.h"

@interface HHSpriteNode : SKSpriteNode <HHActionHandler, HHEventHandler,
                                        HHNodeRemovalHandler>

@end
