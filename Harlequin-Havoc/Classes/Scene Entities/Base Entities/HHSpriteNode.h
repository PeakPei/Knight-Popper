//
//  HHSpriteNode.h
//  Harlequin-Havoc
//
//  Created by Morgan on 28/09/13.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "HHActionHandler.h"
#import "HHEventHandler.h"
#import "HHNodeRemovalHandler.h"

@interface HHSpriteNode : SKSpriteNode <HHActionHandler, HHEventHandler,
                                        HHNodeRemovalHandler>

@end
