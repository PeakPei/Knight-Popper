//
//  HHActionHandler.h
//  Harlequin-Havoc
//
//  Created by Morgan on 28/09/13.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHAction.h"
#import "HHActionCategories.h"

@protocol HHActionHandler <NSObject>

@required

- (void)onAction:(HHAction*)action;

- (ActionCategory)getActionCategory;

@end
