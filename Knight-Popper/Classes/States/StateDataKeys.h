/**
 * @filename StateDataKeys.h
 * @author Morgan Wall
 * @date 9-11-2013
 *
 * @brief The unique identifiers used for keys in the NSDictionary objects used
 * to pass data between states that constitute the game.
 */

#ifndef Knight_Popper_StateDataKeys_h
#define Knight_Popper_StateDataKeys_h

typedef enum stateDataKeys {
    StateDataKeyPlayerOneScore = 0,
    StateDataKeyPlayerTwoScore,
    StateDataKeyPlayerOneStats,
    StateDataKeyPlayerTwoStats
} StateDataKey;

#endif
