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
           actionBlock:(void(^)(SKNode*, CGFloat))actionBlock
          timeInterval:(NSTimeInterval)timeInterval {
    if (self = [super init]) {
        _category = category;
        _action = [SKAction customActionWithDuration:timeInterval
                                         actionBlock:actionBlock];
    }
    return self;
}

#pragma mark - Properties

@synthesize category = _category;
@synthesize action = _action;

@end
