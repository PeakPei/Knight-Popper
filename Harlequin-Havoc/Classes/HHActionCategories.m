/**
 * @filename HHActionCategories.h
 * @author Morgan Wall
 * @date 24-9-13
 */

#import "HHActionCategories.h"

#pragma mark - Implementation

@implementation HHActionCategories

+ (NSString*)nodeNameForCategory:(unsigned int)category {
    return [NSString stringWithFormat:@"%d", category];
}

@end
