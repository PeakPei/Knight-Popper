/**
 * @filename HHApplicationViewController.m
 * @author Morgan Wall
 * @date 28-9-2013
 *
 * @brief The implementation of the primary view controller responsible for 
 * managing the entire game.
 */

#import "KPApplicationViewController.h"
#import "UIApplication+AppDimensions.h"
#import "KPStandardGameState.h"
#import "TextureIDs.h"
#import "StateIDs.h"
#import <SpriteStackKit/SSKStateStack.h>
#import <SpriteStackKit/SSKTextureManager.h>

#pragma mark - Interface

@interface KPApplicationViewController ()

/**
 * @brief The state stack used to describe the scene.
 */
@property SSKStateStack* stateStack;

/**
 * @brief The view associated with the view controller that is used to describe
 * the visual state of the scene.
 */
@property SKView* stateView;

/**
 * @brief The texture manager containing the textures used by the states in
 * the state stack.
 */
@property SSKTextureManager* textures;

@end

#pragma mark - Implementation

@implementation KPApplicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Configure the view
    self.stateView = (SKView*)self.view;
    
    // Load textures
    self.textures = [[SSKTextureManager alloc] initWithTextureCount:2];
    [self.textures loadTexture:@"background.png"
                    identifier:TextureIDBackground];
    [self.textures loadTexture:@"GrassTuft_Left.png"
                    identifier:TextureIDGrassTuftLeft];
    [self.textures loadTexture:@"GrassTuft_Right.png"
                    identifier:TextureIDGrassTuftRight];
    [self.textures loadTexture:@"blue_monkey_HUD.png"
                    identifier:TextureIDBlueMonkeyHUD];
    [self.textures loadTexture:@"pink_monkey_HUD.png"
                    identifier:TextureIDPinkMonkeyHUD];
    [self.textures loadTexture:@"blue_monkey_target.png"
                    identifier:TextureIDBlueMonkeyTarget];
    [self.textures loadTexture:@"pink_monkey_target.png"
                    identifier:TextureIDPinkMonkeyTarget];
    
    // Register states
    CGSize landscapeSize =
        [UIApplication sizeInOrientation:UIInterfaceOrientationLandscapeLeft];
    self.stateStack = [[SSKStateStack alloc] initWithTextureManager:self.textures
                                                              size:landscapeSize];
    [self.stateStack registerState:[KPStandardGameState class] stateID:StateIDExample];
    
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
