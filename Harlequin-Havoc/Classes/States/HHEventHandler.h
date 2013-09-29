//
//  HHTouchEventHandler.h
//  Harlequin-Havoc
//
//  Created by Morgan on 29/09/13.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HHEventHandler <NSObject>

- (BOOL)handleEvent:(UIEvent*)event touch:(UITouch*)touch;

@end
