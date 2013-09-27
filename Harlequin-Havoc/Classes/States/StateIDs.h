/**
 * @filename StateIDs.h
 * @author Morgan Wall
 * @date 26-9-2013
 *
 * @brief The unique identifiers used for states that constitute the game.
 */

#ifndef Harlequin_Havoc_StateIDs_h
#define Harlequin_Havoc_StateIDs_h

typedef enum States {
    StateIDNone,
    StateIDTitle,
    StateIDMenu,
    StateIDGame,
    StateIDHighScores,
    StateIDLoading,
    StateIDPause,
    StateIDGameOver,
    StateIDCredits,
    StateIDExample
} StateID;

#endif
