/**
 * @filename HHStateStack.m
 * @author Morgan Wall
 * @date 26-9-2013
 *
 * @brief The implementation of the HHStateStack class.
 */

#import "HHStateStack.h"

#pragma mark - Interface

@interface HHStateStack ()

/**
 * @brief An structure describing an impending change to the state stack.
 */
typedef struct PendingStackChange {
    StateStackAction action;
    StateID stateIdentifier;
} PendingStackChange;

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

/**
 * @brief A mapping of unique state identifiers to the factory functions
 * used to create said states.
 */
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
    SKNode* (^stateFactory)() = ^{
        return [[stateClass alloc] init];
    };
    
    [self.stateFactories setObject:stateFactory
                            forKey:[NSNumber numberWithUnsignedInt:stateID]];
}

- (void)pushState:(StateID)stateID {
    PendingStackChange stackChange;
    stackChange.action = StateStackActionPush;
    stackChange.stateIdentifier = stateID;
    
    NSValue* value =
        [NSValue valueWithBytes:&stackChange objCType:@encode(PendingStackChange)];
    [pendingStackChanges addObject:value];
}

- (void)popState {
    PendingStackChange stackChange;
    stackChange.action = StateStackActionPop;
    stackChange.stateIdentifier = StateIDNone;
    
    NSValue* value =
    [NSValue valueWithBytes:&stackChange objCType:@encode(PendingStackChange)];
    [pendingStackChanges addObject:value];
}

- (void)clearStates {
    PendingStackChange stackChange;
    stackChange.action = StateStackActionClear;
    stackChange.stateIdentifier = StateIDNone;
    
    NSValue* value =
    [NSValue valueWithBytes:&stackChange objCType:@encode(PendingStackChange)];
    [pendingStackChanges addObject:value];
}

- (BOOL)isEmpty {
    return !self.children.count;
}

- (void)applyPendingStackChanges {
    NSEnumerator *enumerator = [self.pendingStackChanges objectEnumerator];
    NSValue* stackChange;
    
    while (stackChange = [enumerator nextObject]) {
        PendingStackChange stackChangeInfo;
        [stackChange getValue:&stackChangeInfo];
        
        switch (stackChangeInfo.action) {
            case StateStackActionPush: {
                if (stackChangeInfo.stateIdentifier != StateIDNone) {
                    SKNode* (^stateFactory)() =
                        [self.stateFactories objectForKey:
                         [NSNumber numberWithUnsignedInt:stackChangeInfo.stateIdentifier]];
                    [self addChild:stateFactory()];
                }
                
                break;
            }
                
            case StateStackActionPop: {
                SKNode* rootStateNode = [[self children] lastObject];
                [self removeChildrenInArray:[NSArray arrayWithObject:rootStateNode]];
                break;
            }
                
            case StateStackActionClear:
                [self removeAllChildren];
                break;
        }
    }
}

#pragma mark - Properties

@synthesize pendingStackChanges;
@synthesize stateFactories;

@end
