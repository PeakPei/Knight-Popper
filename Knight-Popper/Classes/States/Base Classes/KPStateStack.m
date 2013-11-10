/**
 * @filename KPStateStack.m
 * @author Morgan Wall
 * @date 10-11-2013
 */

#import "KPStateStack.h"

@implementation KPStateStack

- (void)didBeginContact:(SKPhysicsContact *)contact {
    NSEnumerator* enumerator = [self.children objectEnumerator];
    id child;
    
    while (child = [enumerator nextObject]) {
        if (![child conformsToProtocol:@protocol(SKPhysicsContactDelegate)]) {
            [[NSException
              exceptionWithName:@"ProtocolNotImplementedException"
              reason:@"The object does not implement the SKPhysicsContactDelegate protocol"
              userInfo:nil] raise];
        }
        
        [child didBeginContact:contact];
    }
}

- (void)didEndContact:(SKPhysicsContact *)contact {
    NSEnumerator* enumerator = [self.children objectEnumerator];
    id child;
    
    while (child = [enumerator nextObject]) {
        if (![child conformsToProtocol:@protocol(SKPhysicsContactDelegate)]) {
            [[NSException
              exceptionWithName:@"ProtocolNotImplementedException"
              reason:@"The object does not implement the SKPhysicsContactDelegate protocol"
              userInfo:nil] raise];
        }
        
        [child didBeginContact:contact];
    }
}

@end
