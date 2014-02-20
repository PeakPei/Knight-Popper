/**
 * @filename Coordinates.h
 * @author Morgan Wall
 * @date 17-2-2014
 */

#import "Coordinates.h"

#define R4_SCALING_FACTOR_X (568.0/480.0)

#define IPAD_SCALING_FACTOR_X (1024.0/480.0)
#define IPAD_SCALING_FACTOR_Y (768.0/320.0)

#pragma mark - Implementation

@implementation Coordinates

+ (CGFloat)convertXFromiPhone:(CGFloat)x scalesForWidescreen:(BOOL)scales {
    if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            && IS_WIDESCREEN && scales) {
        x *= R4_SCALING_FACTOR_X;
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        x *= IPAD_SCALING_FACTOR_X;
    }
    
    return x;
}

+ (CGFloat)convertYFromiPhone:(CGFloat)y {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        y *= IPAD_SCALING_FACTOR_Y;
    }
    
    return y;
}

@end
