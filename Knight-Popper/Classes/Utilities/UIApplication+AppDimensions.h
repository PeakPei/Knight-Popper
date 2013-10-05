/**
 * @filename UIApplication+AppDimensions.h
 * @date 26-10-2011
 *
 * @brief A category on UIApplication providing methods to obtain the screen
 * dimensions suitably during viewDidLoad.
 *
 * @note Sourced from: http://stackoverflow.com/questions/7905432/how-to-get-orientation-dependent-height-and-width-of-the-screen
 */

#import <UIKit/UIKit.h>

@interface UIApplication (AppDimensions)

+ (CGSize)currentSize;

+ (CGSize)sizeInOrientation:(UIInterfaceOrientation)orientation;

@end
