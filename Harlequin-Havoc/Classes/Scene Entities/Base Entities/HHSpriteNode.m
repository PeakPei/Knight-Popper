//
//  HHSpriteNode.m
//  Harlequin-Havoc
//
//  Created by Morgan on 28/09/13.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import "HHSpriteNode.h"

@implementation HHSpriteNode

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

@end
