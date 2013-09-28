//
//  HHAction.h
//  Harlequin-Havoc
//
//  Created by Morgan on 28/09/13.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#include "HHActionCategories.h"

@interface HHAction : NSObject

- (id)initWithCategory:(ActionCategory)category
                action:(SKAction*)action;

- (id)initWithCategory:(ActionCategory)category
           actionBlock:(void(^)(void))actionBlock;

@property (readonly) ActionCategory category;

@property (readonly) SKAction* action;

@end
