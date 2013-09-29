//
//  HHNode.h
//  Harlequin-Havoc
//
//  Created by Morgan on 28/09/13.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "HHActionHandler.h"
#import "HHEventHandler.h"

@interface HHNode : SKNode <HHActionHandler, HHEventHandler>

@end
