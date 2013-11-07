//
//  KPShapeNode.m
//  Knight-Popper
//
//  Created by Morgan on 6/11/2013.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import "KPShapeNode.h"

@implementation KPShapeNode

- (BOOL)handleEvent:(UIEvent*)event touch:(UITouch *)touch {
    BOOL eventHandled = NO;
    CGPoint touchLocation = [touch locationInNode:[self parent]];
    
    if ([self containsPoint:touchLocation]) {
        [self destroy];
        eventHandled = YES;
    }
    
    return eventHandled;
}

@end
