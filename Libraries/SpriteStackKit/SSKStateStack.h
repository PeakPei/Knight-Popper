/**
 * @filename KPStateStack.h
 * @author Morgan Wall
 * @date 26-9-2013
 *
 * @brief A class representing an active state in the game. An active state has
 * been defined in terms of as stack, hence the active or "current" state is not
 * limited to an individual piece. Instead a state may consist of several
 * "stacked" pieces (e.g. the pause screen overlayed on the game screen).
 *
 * @note A state is an independent screen in a game which encapsulates its own
 * logic and graphics. Based on the stack definition of an active state, the
 * physical screen can consist of multiple independent screens at any one time.
 */

#import <SpriteKit/SpriteKit.h>
#import <SpriteStackKit/SSKTextureManager.h>
#import <SpriteStackKit/SSKEventHandler.h>

@interface SSKStateStack : SKScene <SSKEventHandler>

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
 * @brief Initialise a state stack with a texture manager.
 *
 * @param textureManager
 * The texture manager containing all the textures usable by the states registered 
 * by the state stack.
 *
 * @param size
 * The bounds of the state stack.
 */
- (id)initWithTextureManager:(SSKTextureManager*)textureManager size:(CGSize)size;

/**
 * @brief Insert a mapping of the unique state identifier to the factory
 * function used to create said state.
 *
 * @param stateClass
 * A subclass of the KPState class for which a factory method will be created
 * for.
 *
 * @param stateID
 * The unique state identifier.
 *
 * @throws NSException
 * If ::stateClass is not a subclass of KPState.
 */
- (void)registerState:(Class)stateClass stateID:(unsigned int)stateID;

/**
 * @brief Add an impending change that requests a new state of a particular
 * type be pushed onto the top of the state stack (thereby giving it highest
 * priority).
 *
 * @param stateID
 * The unique identifier for the type of state to be pushed onto the stack.
 */
- (void)pushState:(unsigned int)stateID;

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