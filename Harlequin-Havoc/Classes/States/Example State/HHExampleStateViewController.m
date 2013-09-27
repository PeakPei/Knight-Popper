//
//  HHExampleStateViewController.m
//  Harlequin-Havoc
//
//  Created by Morgan on 28/09/13.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import "HHExampleStateViewController.h"
#import "UIApplication+AppDimensions.h"
#import "HHExampleState.h"

@implementation HHExampleStateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Configure the view
    self.stateView.showsFPS = YES;
    self.stateView.showsNodeCount = YES;
    
    HHTextureManager* textures = [[HHTextureManager alloc] initWithTextureCount:1];
//    [textures loadTexture:@"background.png" identifier:TextureIDBackground];
    
    self.stateStack = [[HHStateStack alloc] initWithTextureManager:textures];
    
    [self.stateStack registerState:[HHExampleState class] stateID:StateIDExample];
    
    // Configure the scene
    CGSize landscapeSize =
    [UIApplication sizeInOrientation:UIInterfaceOrientationLandscapeLeft];
    [self.stateStack setSize:landscapeSize];
    
    SKSpriteNode* background = [[SKSpriteNode alloc] initWithImageNamed:@"background.png"];
    background.position = CGPointMake(CGRectGetMidX(self.stateStack.frame),CGRectGetMidY(self.stateStack.frame));
    [background setSize:CGSizeMake(1024, 768)];
    
    [self.stateStack addChild:background];
    
    [self.stateStack pushState:StateIDExample];
    [self.stateStack applyPendingStackChanges];
    
    [self.stateView presentScene:self.stateStack];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
