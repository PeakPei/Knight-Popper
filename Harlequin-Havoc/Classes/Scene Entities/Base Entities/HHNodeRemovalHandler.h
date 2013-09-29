//
//  HHNodeRemovalHandler.h
//  Harlequin-Havoc
//
//  Created by Morgan on 29/09/13.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HHNodeRemovalHandler <NSObject>

- (BOOL)isDestroyed;

- (void)destroy;

- (void)executeRemovalRequests;

@end
