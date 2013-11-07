//
//  KPShapeAnimationNode.m
//  Knight-Popper
//
//  Created by Morgan on 7/11/2013.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import "KPShapeAnimationNode.h"

@implementation KPShapeAnimationNode

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
