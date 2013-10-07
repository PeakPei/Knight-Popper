/**
 * @filename KPSpriteNode.m
 * @author Morgan Wall
 * @date 7-10-2013
 */

#import "KPSpriteNode.h"

@implementation KPSpriteNode

#pragma mark SSKEventHandler

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
