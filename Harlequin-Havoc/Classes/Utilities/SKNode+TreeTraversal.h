//
//  SKNode+TreeTraversal.h
//  Harlequin-Havoc
//
//  Created by Morgan on 29/09/13.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKNode (TreeTraversal)

- (BOOL)traversePreOrder:(BOOL (^)(SKNode*))action;

- (BOOL)traversePostOrder:(BOOL (^)(SKNode*))action;

@end
