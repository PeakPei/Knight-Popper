/**
 * @filename KPActionCategories.h
 * @author Morgan Wall
 * @date 24-9-13
 */

#import "KPActionCategories.h"

#pragma mark - Implementation

@implementation KPActionCategories

+ (NSString*)nodeNameForCategory:(unsigned int)category {
    return [NSString stringWithFormat:@"%d", category];
}

@end
