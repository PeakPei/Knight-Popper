/**
 * @filename UIApplication+AppDimensions.h
 * @date 26-10-2011
 *
 * @note Sourced from: http://stackoverflow.com/questions/7905432/how-to-get-orientation-dependent-height-and-width-of-the-screen
 */

#import "UIApplication+AppDimensions.h"

@implementation UIApplication (AppDimensions)

+ (CGSize)currentSize {
    return [UIApplication sizeInOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

+ (CGSize)sizeInOrientation:(UIInterfaceOrientation)orientation {
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIApplication *application = [UIApplication sharedApplication];
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        size = CGSizeMake(size.height, size.width);
    }
    
    if (application.statusBarHidden == NO) {
        size.height -= MIN(application.statusBarFrame.size.width,
                           application.statusBarFrame.size.height);
    }
    
    return size;
}

@end