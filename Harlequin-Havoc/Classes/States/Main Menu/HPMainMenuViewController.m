/**
 * @filename HPMainMenuViewController.m
 * @author Morgan Wall
 * @date 23-9-2013
 *
 * @brief The implementation of the view controller for the main menu state.
 */

#import "HPMainMenuViewController.h"
#import "HPMainMenuScene.h"
#import "HPGameScene.h"

#import "UIApplication+AppDimensions.h"

@implementation HPMainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Configure the view
    self.stateView.showsFPS = YES;
    self.stateView.showsNodeCount = YES;
    
    // Configure the scene
    CGSize landscapeSize =
        [UIApplication sizeInOrientation:UIInterfaceOrientationLandscapeLeft];
    self.scene = [HPMainMenuScene sceneWithSize:landscapeSize];
    [self.stateView presentScene:self.scene];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
