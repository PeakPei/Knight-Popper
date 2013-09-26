//
//  HHStateStack.m
//  Harlequin-Havoc
//
//  Created by Morgan on 26/09/13.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import "HHStateStack.h"

#pragma mark - Interface

@interface HHStateStack ()

/**
 * @brief An structure describing an impending change to the state stack.
 */
struct PendingStackChange {
    StateStackAction action;
};

/**
 * @brief Apply any pending changes to the state stack.
 *
 * @note Stack changes may be postponed until an appropriate point in the
 * game's cycle since changing the state stack is unsafe whilst events,
 * updates, and draw request are being fed to its constituent components.
 */
- (void)applyPendingStackChanges;

/**
 * @brief The pending changes to the state stack.
 *
 * @note Such changes include the basic push, pop, and clear stack operations.
 */
@property NSMutableArray* pendingStackChanges;

@property NSMutableDictionary* stateFactories;

@end

#pragma mark - Implementation

@implementation HHStateStack

- (id)init {
    if (self = [super init]) {
        self.pendingStackChanges = [[NSMutableArray alloc] init];
        self.stateFactories = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)registerState:(Class)stateClass stateID:(StateID)stateID {
    
}

- (void)pushState:(StateID)stateID {
    
}

- (void)popState {
    
}

- (void)clearStates {
    
}

- (BOOL)isEmpty {
    return !self.children.count;
}

- (void)applyPendingStackChanges {
    NSEnumerator *enumerator = [self.pendingStackChanges objectEnumerator];
    id stackChange;
    
    while (stackChange = [enumerator nextObject]) {
        // stub
    }
}

#pragma mark - Properties

@synthesize pendingStackChanges;
@synthesize stateFactories;

@end
