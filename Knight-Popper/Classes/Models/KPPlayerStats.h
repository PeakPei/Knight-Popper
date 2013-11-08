/**
 * @filename KPPlayerStats.h
 * @author Morgan Wall
 * @date 9-11-2013
 *
 * @brief The model object used to store and manager a player's in-game stats.
 */

#import <Foundation/Foundation.h>

@interface KPPlayerStats : NSObject

/**
 * @brief Increment the counter of the number of pink balloons destroyed.
 */
- (void)incrementPinkTargetHitCounter;

/**
 * @brief Increment the counter of the number of blue balloons destroyed.
 */
- (void)incrementBlueTargetHitCounter;

/**
 * @brief Increment the counter of the number of gold balloons destroyed.
 */
- (void)incrementGoldTargetHitCounter;

/**
 * @brief The number of pink balloons the player has destroyed.
 */
@property (readonly) unsigned int pinkTargetsHit;

/**
 * @brief The number of blue balloons the player has destroyed.
 */
@property (readonly) unsigned int blueTargetsHit;

/**
 * @brief The number of gold balloons the player has destroyed.
 */
@property (readonly) unsigned int goldTargetsHit;

@end
