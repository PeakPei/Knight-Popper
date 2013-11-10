/**
 * @filename KPPlayerScore.h
 * @author Morgan Wall
 * @date 9-11-2013
 *
 * @brief The model object used to store and manager a player's in-game score.
 */

#import <Foundation/Foundation.h>

@interface KPPlayerScore : NSObject

/**
 * @brief Modify the player's score.
 *
 * @param delta
 * The delta applied to the player's current score.
 *
 * @throws NSException
 * If the player's score becomes negative under the given delta.
 *
 * @note A player's score must remain non-negative.
 */
- (void)modifyScore:(int)delta;

/**
 * @brief The player's score.
 */
@property (readonly) unsigned int score;

@end
