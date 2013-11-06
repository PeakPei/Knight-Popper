/**
 * @file Random.h
 * @authors Morgan Wall
 * @date 23-9-2013
 *
 * @brief A class for generating pseudo-random numbers of various types.
 *
 * @note This class uses the arc4random c-function (<stdlib.h>).
 */

@interface Random : NSObject

/**
 * Generate a pseudo-random integer in a specified range.
 *
 * @param lowerBound
 * The lower boundary on the range of possible integers generated.
 *
 * @param upperBound
 * The upper boundary on the range of the possible integers generated.
 *
 * @return An integer between lowerBound and upperBound, inclusive.
 */
+ (int)generateInteger:(int)lowerBound upperBound:(int)upperBound;

/**
 * Generate a pseudo-random real number in a specified range.
 *
 * @param lowerBound
 * The lower boundary on the range of possible real numbers generated.
 *
 * @param upperBound
 * The upper boundary on the range of the possible real numbers generated.
 *
 * @return A real number between lowerBound and upperBound, inclusive.
 */
+ (long double)generateDouble:(double)lowerBound
                   upperBound:(double)upperBound;

/**
 * Generate a pseudo-random boolean value given a specific probability of
 * being true.
 *
 * @param probability
 * The probability that the boolean value generated is true.
 *
 * @return A boolean value.
 *
 * @note This method assumes a uniform distribution of probabilities that
 * a specific number will be returned from the rand function given a
 * pseudo-random seed.
 */
+ (BOOL)generateBool:(double)probability;

@end
