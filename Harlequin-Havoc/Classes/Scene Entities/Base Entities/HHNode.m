/**
 * @filename HHNode.m
 * @author Morgan Wall
 * @date 28-9-2013
 *
 * @brief The implementation of the HHNode class.
 */

#import "HHNode.h"
#import "SKNode+TreeTraversal.h"

#pragma mark - Implementation

@implementation HHNode

#pragma mark HHActionHandler

- (void)onAction:(HHAction*)action {
    if (action.category == [self getActionCategory]) {
        [self runAction:action.action];
    }
    
    NSEnumerator *enumerator = [self.children objectEnumerator];
    id child;
    
    while (child = [enumerator nextObject]) {
        if (![child conformsToProtocol:@protocol(HHActionHandler)]) {
            [[NSException
              exceptionWithName:@"ProtocolNotImplementedException"
              reason:@"The object does not implement the HHActionHandler protocol"
              userInfo:nil] raise];
        }
        
        [child onAction:action];
    }
}

- (ActionCategory)getActionCategory {
    return ActionCategoryNone;
}

#pragma mark HHEventHandler

- (BOOL)handleEvent:(UIEvent*)event touch:(UITouch *)touch {
    return NO;
}

#pragma mark NodeRemovalHandler

- (BOOL)isDestroyed {
    return NO;
}

- (void)destroy {}

- (void)executeRemovalRequests {
    BOOL (^removalRequest)(SKNode*) = ^(SKNode* node) {
        if ([node conformsToProtocol:@protocol(HHNodeRemovalHandler)]) {
            if ([(id)node isDestroyed]) {
                [(id)node removeAllChildren];
                [(id)node removeFromParent];
            }
        } else {
            [[NSException
              exceptionWithName:@"ProtocolNotImplementedException"
              reason:@"The object does not implement the HHNodeRemovalHandler protocol"
              userInfo:nil] raise];
        }
        return NO;
    };
    
    [self traversePostOrder:removalRequest];
}

@end
