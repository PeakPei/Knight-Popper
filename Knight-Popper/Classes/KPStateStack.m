/**
 * @filename KPStateStack.m
 * @author Morgan Wall
 * @date 10-11-2013
 */

#import "KPStateStack.h"

@implementation KPStateStack

- (void)didBeginContact:(SKPhysicsContact *)contact {
    NSLog(@"CONTACT!");
}

- (void)didEndContact:(SKPhysicsContact *)contact {
    NSLog(@"NO MORE CONTACT!");
}

@end
