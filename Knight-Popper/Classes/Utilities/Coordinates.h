/**
 * @filename Coordinates.h
 * @author Morgan Wall
 * @date 17-2-2014
 *
 * @brief A utility class containing methods for converting coordinate values
 * between devices.
 */

#import <Foundation/Foundation.h>

@interface Coordinates : NSObject

/**
 * @brief Convert an x-coordinate from a 3.5-inch iPhone to another device such
 * that the relative position on the screen is maintained. This method assumes
 * that the device is using landscape coordinates.
 *
 * @param x
 * The x-coordinate in the iPhone coordinate system (in points).
 *
 * @param scales
 * Indicates whether the additional screen real estate for a 4-inch iPhone 
 * should be ignored (false) or considered (true). When the additional screen
 * real estate is ignored, no conversion is necessary.
 *
 * @returns The converted x-coordinate for the current device (in landscape).
 */
+ (CGFloat)convertXFromiPhone:(CGFloat)x scalesForWidescreen:(BOOL)scales;

/**
 * @brief Convert an y-coordinate from a 3.5-inch iPhone to another device such 
 * that the relative position on the screen is maintained. This method assumes 
 * that the device is using landscape coordinates.
 *
 * @param y
 * The y-coordinate in the iPhone coordinate system (in points).
 *
 * @returns The converted y-coordinate for the current device (in landscape).
 */
+ (CGFloat)convertYFromiPhone:(CGFloat)y;

@end
