//
//  KPStateViewController.m
//  Knight Popper
//
//  Created by Morgan on 23/09/13.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import "HPStateViewController.h"

#pragma mark - Implementation

@implementation HPStateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Configure the view and the scene graph
    self.stateView = (SKView*)self.view;
    [self.stateView setBackgroundColor:[UIColor redColor]];
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
