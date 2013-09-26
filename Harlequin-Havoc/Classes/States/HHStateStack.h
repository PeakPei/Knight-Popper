//
//  HHStateStack.h
//  Harlequin-Havoc
//
//  Created by Morgan on 26/09/13.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#include "StateIDs.h"

@interface HHStateStack : SKScene

/**
 * @brief An enumeration of the possible operations that can be performed on the
 * state stack.
 */
typedef enum Action {
    StateStackActionPush,
    StateStackActionPop,
    StateStackActionClear
} StateStackAction;

/**
 * @brief Insert a mapping of the unique state identifier to the factory
 * function used to create said state.
 *
 * @param stateClass
 * A subclass of the HHState class for which a factory method will be created
 * for.
 *
 * @param stateID
 * The unique state identifier.
 */
- (void)registerState:(Class)stateClass stateID:(StateID)stateID;

/**
 * @brief Add an impending change that requests a new state of a particular
 * type be pushed onto the top of the state stack (thereby giving it highest
 * priority).
 *
 * @param stateID
 * The unique identifier for the type of state to be pushed onto the stack.
 */
- (void)pushState:(StateID)stateID;

/**
 * @brief Add an impending change that requests a state to be popped from
 * the state stack.
 */
- (void)popState;

/**
 * @brief Add an impending change that requests all states to be removed
 * from that state stack.
 */
- (void)clearStates;

/**
 * @brief Check if the state stack is empty.
 *
 * @returns true if the state stack is empty, otherwise false.
 */
- (BOOL)isEmpty;

@end
