//
//  SKNode+TreeTraversal.m
//  Harlequin-Havoc
//
//  Created by Morgan on 29/09/13.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import "SKNode+TreeTraversal.h"

@implementation SKNode (TreeTraversal)

- (BOOL)traversePreOrder:(BOOL (^)(SKNode*))action {
    BOOL actionHandled = NO;
    
    actionHandled = action(self);
    
    NSEnumerator* enumerator = [self.children objectEnumerator];
    SKNode* child;
    while ((child = [enumerator nextObject]) && !actionHandled) {
        actionHandled = action(child);
    }
    
    return actionHandled;
}

- (BOOL)traversePostOrder:(BOOL (^)(SKNode*))action {
    BOOL actionHandled = NO;
    
    NSEnumerator* enumerator = [self.children reverseObjectEnumerator];
    SKNode* child;
    while ((child = [enumerator nextObject]) && !actionHandled) {
        actionHandled = action(child);
    }
    
    actionHandled = action(self);
    
    return actionHandled;
}

@end
