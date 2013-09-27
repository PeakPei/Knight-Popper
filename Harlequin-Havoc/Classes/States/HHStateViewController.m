/**
 * @filename HHStateViewController.m
 * @author Morgan Wall
 * @date 23-9-2013
 *
 * @brief The implementation of the HHStateViewController class.
 */

#import "HHStateViewController.h"
#import "HHTextureManager.h"

#pragma mark - Implementation

@implementation HHStateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Configure the view and the scene graph
    self.stateView = (SKView*)self.view;
    self.stateStack = NULL;
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
@synthesize stateStack;

@end
