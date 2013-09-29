/**
 * @filename HHStateStack.m
 * @author Morgan Wall
 * @date 26-9-2013
 *
 * @brief The implementation of the HHStateStack class.
 */

#import "HHStateStack.h"
#import "HHState.h"
#import "HHAction.h"
#import "HHActionHandler.h"
#import "HHStateStackHandler.h"

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

/**
 * @brief The texture manager containing the textures used by the states in
 * the state stack.
 */
@property HHTextureManager* textures;

@end

#pragma mark - Implementation

@implementation HHStateStack

- (id)initWithTextureManager:(HHTextureManager*)textureManager size:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.pendingStackChanges = [[NSMutableArray alloc] init];
        self.stateFactories = [[NSMutableDictionary alloc] init];
        self.textures = textureManager;
    }
    return self;
}

- (void)registerState:(Class)stateClass stateID:(StateID)stateID {
    if (![stateClass isSubclassOfClass:[HHState class]]) {
        [[NSException
          exceptionWithName:@"InvalidStateClassException"
          reason:@"The class specified is not a subclass of HHState"
          userInfo:nil] raise];
    }
    
    HHState* (^stateFactory)() = ^{
        return [[stateClass alloc] initWithStateStack:self textureManager:self.textures];
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
                    HHState* (^stateFactory)() =
                        [self.stateFactories objectForKey:
                         [NSNumber numberWithUnsignedInt:stackChangeInfo.stateIdentifier]];
                    HHState* state = stateFactory();
                    // TODO: set anchor point
                    state.position = CGPointMake(CGRectGetMidX(self.frame),
                                                 CGRectGetMidY(self.frame));
                    [self addChild:state];
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
    
    [self.pendingStackChanges removeAllObjects];
}

#pragma mark - SKScene

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    // stub
}

- (void)update:(CFTimeInterval)currentTime {
    // Update the states in the state stack
//    NSEnumerator* enumerator = [self.children objectEnumerator];
//    HHState* child;
//    while (child == [enumerator nextObject]) {
//        [child update:currentTime];
//    }
    
    // Apply changes to the state stack
    [self applyPendingStackChanges];
    
    // Check that the state stack is not empty
    // N.B. iOS applications do not have a concept of quitting.
    if ([self isEmpty]) {
        [[NSException
          exceptionWithName:@"EmptyStackStateException"
          reason:@"The stack state does not containing any states to render"
          userInfo:nil] raise];
    }
}

- (void)addChild:(SKNode *)node {
    [super addChild:node];
    
    if (![node conformsToProtocol:@protocol(HHStateStackHandler)]) {
        [[NSException
          exceptionWithName:@"ProtocolNotImplementedException"
          reason:@"The object does not implement the HHStateStackHandler protocol"
          userInfo:nil] raise];
    }
    
    [(id)node buildState];
}

#pragma mark - Properties

@synthesize pendingStackChanges;
@synthesize stateFactories;
@synthesize textures;

@end
