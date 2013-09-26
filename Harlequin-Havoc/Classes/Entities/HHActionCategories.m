/**
 * @filename HHActionCategories.h
 * @author Morgan Wall
 * @date 24-9-13
 */

#import "HHActionCategories.h"

#pragma mark - Implementation

@implementation HHActionCategories

+ (NSString*)nodeNameForCategory:(ActionCategory)category {
    NSString* nodeName;
    
    switch (category) {
        case ActionCategoryNone:
            nodeName = @"None";
            break;
        case ActionCategoryScene:
            nodeName = @"Scene";
            break;
    }
    
    return nodeName;
}

@end
