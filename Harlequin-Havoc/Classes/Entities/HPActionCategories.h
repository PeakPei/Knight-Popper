//
//  HPActionCategories.h
//  Knight Popper
//
//  Created by Morgan on 24/09/13.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPActionCategories : NSObject

typedef enum Category {
    ActionCategoryNone = 0
} ActionCategory;

+ (NSString*)nodeNameForCategory:(ActionCategory)category;

@end
