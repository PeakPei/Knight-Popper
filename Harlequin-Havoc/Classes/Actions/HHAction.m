//
//  HHAction.m
//  Harlequin-Havoc
//
//  Created by Morgan on 28/09/13.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import "HHAction.h"

#pragma mark - Implementation

@implementation HHAction

- (id)initWithCategory:(ActionCategory)category
                action:(SKAction*)action {
    if (self = [super init]) {
        _category = category;
        _action = action;
    }
    return self;
}

- (id)initWithCategory:(ActionCategory)category
           actionBlock:(void(^)(void))actionBlock {
    if (self = [super init]) {
        _category = category;
        _action = [SKAction runBlock:actionBlock];
    }
    return self;
}

#pragma mark - Properties

@synthesize category = _category;
@synthesize action = _action;

@end
