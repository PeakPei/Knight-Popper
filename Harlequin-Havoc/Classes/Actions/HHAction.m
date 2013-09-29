/**
 * @filename HHAction.h
 * @author Morgan Wall
 * @date 28-9-2013
 *
 * @brief The implemementation of the HHAction class.
 */

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
