//
//  HPActionCategories.m
//  Harlequin-Havoc
//
//  Created by Morgan on 24/09/13.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import "HHActionCategories.h"

#pragma mark - Implementation

@implementation HHActionCategories

+ (NSString*)nodeNameForCategory:(ActionCategory)category {
    NSString* nodeName;
    
    switch (category) {
        case ActionCategoryNone:
            nodeName = @"None";
            break;
    }
    
    return nodeName;
}

@end
