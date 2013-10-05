/**
 * @filename KPState.h
 * @author Morgan Wall
 * @date 27-9-2013
 *
 * @brief A state in the finite-state automaton that describes the flow of
 * the game. The concept of finite-state automaton is somewhat invalidated by the
 * design decision that an active state consists of a stack of individual states
 * describing, collectively, the entirety game window.
 */

#import <SpriteStackKit/SSKStateStack.h>
#import <SpriteStackKit/SSKTextureManager.h>
#import <SpriteStackKit/SSKNode.h>
#import <SpriteStackKit/SSKStateStackHandler.h>

@interface SSKState : SSKNode <SSKStateStackHandler>

/**
 * @brief Initialise a state for a specific state stack in the game.
 *
 * @param stack
 * The state stack the state is being added to.
 */
- (id)initWithStateStack:(SSKStateStack*)stateStack
                textureManager:(SSKTextureManager*)textureManager;

/**
 * @brief Request that a state of a the same type as this state be pushed to
 * the state stack to which this state belongs.
 */
- (void)requestStackPush:(unsigned int)stateID;

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
 * @brief Perform any logic updates on the state for the next frame.
 *
 * @param deltaTime
 * The time elapsed since the last frame.
 */
- (void)update:(CFTimeInterval)deltaTime;

/**
 * @brief Indicates whether the state is capable of handling events.
 */
@property BOOL isActive;

/**
 * @brief The texture manager containing the textures used in the state.
 *
 * @note This should have an encapsulation akin to protected in C++.
 */
@property SSKTextureManager* textures;

@end
