/**
 * @filename HHSpriteNode.m
 * @author Morgan Wall
 * @date 28-9-2013
 *
 * @brief The implementation of the HHSpriteNode class.
 */

#import "HHSpriteNode.h"
#import "SKNode+TreeTraversal.h"

#pragma mark - Interface

@interface HHSpriteNode ()

/**
 * @brief Indicates whether the node has been flagged for removal (true) or 
 * not (false).
 */
@property BOOL destroyed;

@end

#pragma mark - Implementation

@implementation HHSpriteNode

- (id)init {
    if (self = [super init]) {
        self.destroyed = false;
    }
    return self;
}

- (id)initWithTexture:(SKTexture *)texture {
    if (self = [super initWithTexture:texture]) {
        self.destroyed = false;
    }
    return self;
}

#pragma mark HHActionHandler

- (void)onAction:(HHAction*)action {
    if (action.category == [self getActionCategory]) {
        [self runAction:action.action];
    }
    
    NSEnumerator *enumerator = [self.children objectEnumerator];
    id child;
    
    while (child = [enumerator nextObject]) {
        if (![child conformsToProtocol:@protocol(HHActionHandler)]) {
            [[NSException
              exceptionWithName:@"ProtocolNotImplementedException"
              reason:@"The object does not implement the HHActionHandler protocol"
              userInfo:nil] raise];
        }
        
        [child onAction:action];
    }
}

- (ActionCategory)getActionCategory {
    return ActionCategoryNone;
}

#pragma mark HHEventHandler

- (BOOL)handleEvent:(UIEvent*)event touch:(UITouch *)touch {
    BOOL eventHandled = NO;
    CGPoint touchLocation = [touch locationInNode:[self parent]];
    
    if ([self containsPoint:touchLocation]) {
        [self destroy];
        eventHandled = YES;
    }
    return eventHandled;
}

#pragma mark HHNodeRemovalHandler

- (BOOL)isDestroyed {
    return self.destroyed;
}

- (void)destroy {
    self.destroyed = true;
}

- (void)executeRemovalRequests {
    BOOL (^removalRequest)(SKNode*) = ^(SKNode* node) {
        if ([node conformsToProtocol:@protocol(HHNodeRemovalHandler)]) {
            if ([(id)node isDestroyed]) {
                [(id)node removeAllChildren];
                [(id)node removeFromParent];
            }
        } else {
            [[NSException
              exceptionWithName:@"ProtocolNotImplementedException"
              reason:@"The object does not implement the HHNodeRemovalHandler protocol"
              userInfo:nil] raise];
        }
        return NO;
    };
    
    [self traversePostOrder:removalRequest];
}

#pragma mark - Properties

@synthesize destroyed;

@end
