/**
 * @filename HHApplicationViewController.m
 * @author Morgan Wall
 * @date 28-9-2013
 *
 * @brief The implementation of the primary view controller responsible for 
 * managing the entire game.
 */

#import "HHApplicationViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "HHStateStack.h"
#import "HHTextureManager.h"
#import "UIApplication+AppDimensions.h"
#import "HHExampleState.h"

#pragma mark - Interface

@interface HHApplicationViewController ()

/**
 * @brief The state stack used to describe the scene.
 */
@property HHStateStack* stateStack;

/**
 * @brief The view associated with the view controller that is used to describe
 * the visual state of the scene.
 */
@property SKView* stateView;

/**
 * @brief The texture manager containing the textures used by the states in
 * the state stack.
 */
@property HHTextureManager* textures;

@end

#pragma mark - Implementation

@implementation HHApplicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    // Configure the view
    self.stateView = (SKView*)self.view;
    
    // Load textures
    self.textures = [[HHTextureManager alloc] initWithTextureCount:2];
    [self.textures loadTexture:@"background.png" identifier:TextureIDBackground];
    [self.textures loadTexture:@"blue_monkey_target.png" identifier:TextureIDTarget];
    
    // Register states
    CGSize landscapeSize =
        [UIApplication sizeInOrientation:UIInterfaceOrientationLandscapeLeft];
    self.stateStack = [[HHStateStack alloc] initWithTextureManager:self.textures
                                                              size:landscapeSize];
    [self.stateStack registerState:[HHExampleState class] stateID:StateIDExample];
    
    // Configure the scene
    [self.stateStack pushState:StateIDExample];
    [self.stateView presentScene:self.stateStack];
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
    // Dispose of any resources that can be recreated.
}

#pragma mark - Properties

@synthesize stateStack;
@synthesize stateView;
@synthesize textures;

@end
