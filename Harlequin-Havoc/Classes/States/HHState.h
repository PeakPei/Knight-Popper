/**
 * @filename HHState.h
 * @author Morgan Wall
 * @date 27-9-2013
 *
 * @brief A state in the finite-state automaton that describes the flow of
 * the game. The concept of finite-state automaton is somewhat invalidated by the
 * design decision that an active state consists of a stack of individual states
 * describing, collectively, the entirety game window.
 */

#import <SpriteKit/SpriteKit.h>
#import "HHStateStack.h"
#import "HHTextureManager.h"
#include "StateIDs.h"

@interface HHState : SKNode

/**
 * @brief Initialise a state for a specific state stack in the game.
 *
 * @param stack
 * The state stack the state is being added to.
 */
- (id)initWithStateStack:(HHStateStack*)stateStack
                textureManager:(HHTextureManager*)textureManager;

/**
 * @brief Request that a state of a the same type as this state be pushed to
 * the state stack to which this state belongs.
 */
- (void)requestStackPush:(StateID)stateID;

/**
 * @brief Request that the state of highest priority be popped off the state
 * stack to which this state belongs.
 */
- (void)requestStackPop;

/**
 * @brief Request that all states be removed from the state stack to which
 * this state belongs.
 */
- (void)requestStackClear;

/**
 * @brief Construct the scene graph to describe a state in the game.
 *
 * @note Subclasses should override this method to construct the scene graph.
 * All subclasses must call the buildScene method on it's superclass.
 */
- (void)buildStateScene;

/**
 * @brief Deconstruct the scene graph associated with the state.
 *
 * @note Subclasses should override this method to deconstruct the scene graph.
 * All subclasses must call the buildScene method on it's superclass.
 */
- (void)clearStateScene;

/**
 * @brief Indicates whether the state is capable of handling events.
 */
@property BOOL isActive;

/**
 * @brief The texture manager containing the textures used in the state.
 *
 * @note This should have an encapsulation akin to protected in C++.
 */
@property HHTextureManager* textures;

@end
