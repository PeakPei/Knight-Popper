/**
 * @filename HHActionQueue.m
 * @author Morgan Wall
 * @date 28-9-2013
 *
 * @brief The implementation of the HHActionQueue class.
 */

#import "HHActionQueue.h"
#import "NSMutableArray+QueueAdditions.h"

#pragma mark - Interface

@interface HHActionQueue ()

@property NSMutableArray* queue;

@end

#pragma mark - Implementation

@implementation HHActionQueue

- (id)init {
    if (self = [super init]) {
        self.queue = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)push:(HHAction*)action {
    [self.queue enqueue:action];
}

- (HHAction*)pop {
    HHAction* action = NULL;
    
    if (![self isEmpty]) {
        action = [self.queue dequeue];
    }
    
    return action;
}

- (BOOL)isEmpty {
    return [self.queue empty];
}

#pragma mark - Properties

@synthesize queue;

@end
