/**
 * @filename StateIDs.h
 * @author Morgan Wall
 * @date 26-9-2013
 *
 * @brief The unique identifiers used for states that constitute the game.
 */

#ifndef Knight_Popper_StateIDs_h
#define Knight_Popper_StateIDs_h

typedef enum States {
    StateIDNone,
    StateIDTitle,
    StateIDMenu,
    StateIDStandardGame,
    StateIDHighScores,
    StateIDLoading,
    StateIDPause,
    StateIDVictory,
    StateIDCredits,
    StateIDTest
} StateID;

#endif
