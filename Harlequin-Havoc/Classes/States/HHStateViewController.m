//
//  KPStateViewController.m
//  Harlequin-Havoc
//
//  Created by Morgan on 23/09/13.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import "HHStateViewController.h"

#pragma mark - Implementation

@implementation HHStateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Configure the view and the scene graph
    self.stateView = (SKView*)self.view;
    self.scene = NULL;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

#pragma mark - Properties

@synthesize stateView;
@synthesize scene;

@end
