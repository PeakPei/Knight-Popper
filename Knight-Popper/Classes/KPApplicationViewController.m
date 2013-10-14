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
#import "SoundIDs.h"
#import <SpriteStackKit/SSKStateStack.h>
#import <SpriteStackKit/SSKTextureManager.h>
#import <SpriteStackKit/SSKSoundManager.h>

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

/**
 * @brief The sound manager for sounds used by the states in the state stack.
 */
@property SSKSoundManager* soundManager;

@end

#pragma mark - Implementation

@implementation KPApplicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Configure the view
    self.stateView = (SKView*)self.view;
    
    // Load textures
    self.textures = [[SSKTextureManager alloc] initWithTextureCount:20];
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
    [self.textures loadTexture:@"blue_pop.png"
                    identifier:TextureIDBluePop];
    [self.textures loadTexture:@"pink_pop.png"
                    identifier:TextureIDPinkPop];
    [self.textures loadTexture:@"gold_pop.png"
                    identifier:TextureIDGoldPop];
    [self.textures loadTexture:@"countdown.png"
                    identifier:TextureIDCountdown];
    [self.textures loadTexture:@"gold_twinkle.png"
                    identifier:TextureIDGoldTwinkle];
    [self.textures loadTexture:@"lollipop_left_projectile.png"
                    identifier:TextureIDLollipopLeftProjectile];
    [self.textures loadTexture:@"lollipop_right_projectile.png"
                    identifier:TextureIDLollipopRightProjectile];
    [self.textures loadTexture:@"menu_lollipop.png"
                    identifier:TextureIDMenuLollipop];
    [self.textures loadTexture:@"player_one_attack.png"
                    identifier:TextureIDPlayerOneAttack];
    [self.textures loadTexture:@"player_one_idle.png"
                    identifier:TextureIDPlayerOneIdle];
    [self.textures loadTexture:@"player_two_attack.png"
                    identifier:TextureIDPlayerTwoAttack];
    [self.textures loadTexture:@"player_two_idle.png"
                    identifier:TextureIDPlayerTwoIdle];
    [self.textures loadTexture:@"times_up.png"
                    identifier:TextureIDTimeUp];
    [self.textures loadTexture:@"game_timer.png"
                    identifier:TextureIDTimer];
    
    // Load sounds
    self.soundManager = [[SSKSoundManager alloc] initWithSoundCount:15];
    [self.soundManager
        loadSound:@"back_press" soundType:@"wav" identifier:SoundIDBackPress];
    [self.soundManager
        loadSound:@"balloon_pop" soundType:@"wav" identifier:SoundIDBalloonPop];
    [self.soundManager
        loadSound:@"countdown_1" soundType:@"wav" identifier:SoundIDCountdownOne];
    [self.soundManager
        loadSound:@"countdown_2" soundType:@"wav" identifier:SoundIDCountdownTwo];
    [self.soundManager
        loadSound:@"countdown_3" soundType:@"wav" identifier:SoundIDCountdownThree];
    [self.soundManager
        loadSound:@"countdown_go" soundType:@"wav" identifier:SoundIDCountdownGo];
    [self.soundManager
        loadSound:@"forward_press" soundType:@"wav" identifier:SoundIDForwardPress];
    [self.soundManager
        loadSound:@"golden_pop" soundType:@"wav" identifier:SoundIDGoldenPop];
    [self.soundManager
        loadSound:@"in_game_music" soundType:@"wav" identifier:SoundIDInGameMusic];
    [self.soundManager
        loadSound:@"lollipop_lick" soundType:@"wav" identifier:SoundIDLollipopLick];
    [self.soundManager
        loadSound:@"lollipop_reload" soundType:@"wav" identifier:SoundIDLollipopReload];
    [self.soundManager
        loadSound:@"lollipop_throw" soundType:@"wav" identifier:SoundIDLollipopThrow];
    [self.soundManager
        loadSound:@"menu_music" soundType:@"wav" identifier:SoundIDMenuMusic];
    [self.soundManager
        loadSound:@"victory" soundType:@"wav" identifier:SoundIDVictory];
    
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
@synthesize soundManager;

@end
