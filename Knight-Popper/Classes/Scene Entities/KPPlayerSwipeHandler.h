//
//  KPPlayerSwipeHandler.h
//  Knight-Popper
//
//  Created by Morgan on 11/11/2013.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KPPlayerSwipeHandler <NSObject>

- (void)handleThrow:(CGVector)vector player:(unsigned int)player;

@end
