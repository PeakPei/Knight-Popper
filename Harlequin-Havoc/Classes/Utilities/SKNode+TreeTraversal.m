/**
 * @filename SKNode+TreeTraversal.m
 * @author Morgan Wall
 * @date 29-9-2013
 */

#import "SKNode+TreeTraversal.h"

#pragma mark - Implementation

@implementation SKNode (TreeTraversal)

- (BOOL)traversePreOrder:(BOOL (^)(SKNode*))action {
    BOOL actionHandled = NO;
    
    actionHandled = action(self);
    
    NSEnumerator* enumerator = [self.children objectEnumerator];
    SKNode* child;
    while ((child = [enumerator nextObject]) && !actionHandled) {
        actionHandled = action(child);
        [self traversePreOrder:action];
    }
    
    return actionHandled;
}

- (BOOL)traversePostOrder:(BOOL (^)(SKNode*))action {
    BOOL actionHandled = NO;
    
    NSEnumerator* enumerator = [self.children reverseObjectEnumerator];
    SKNode* child;
    while ((child = [enumerator nextObject]) && !actionHandled) {
        [child traversePostOrder:action];
        actionHandled = action(child);
    }
    
    actionHandled = action(self);
    
    return actionHandled;
}

@end
