/**
 * @filename HHStateStackHandler.h
 * @author Morgan Wall
 * @date 29-9-2013
 *
 * @brief A protocol to be implemented on any node classes that represent a state
 * as a direct descendant to the state stack node describing the game. This 
 * protocol is used to manage the initial construction of states added to the 
 * state stack.
 */

#import <Foundation/Foundation.h>

@protocol HHStateStackHandler <NSObject>

@required

/**
 * @brief Construct the state.
 *
 * @note To construct the state means to add all the descendant nodes required to 
 * describe its visual appearance.
 */
- (void)buildState;

@end
