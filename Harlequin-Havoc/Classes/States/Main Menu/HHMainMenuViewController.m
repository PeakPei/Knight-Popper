/**
 * @filename HHMainMenuViewController.m
 * @author Morgan Wall
 * @date 23-9-2013
 *
 * @brief The implementation of the view controller for the main menu state.
 */

#import "HHMainMenuViewController.h"
#import "HHMainMenuScene.h"
#import "HHGameScene.h"
#import "UIApplication+AppDimensions.h"

@implementation HHMainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Configure the view
    self.stateView.showsFPS = YES;
    self.stateView.showsNodeCount = YES;
    
    // Configure the scene
    CGSize landscapeSize =
        [UIApplication sizeInOrientation:UIInterfaceOrientationLandscapeLeft];
    self.scene = [HHMainMenuScene sceneWithSize:landscapeSize];
    [self.stateView presentScene:self.scene];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
