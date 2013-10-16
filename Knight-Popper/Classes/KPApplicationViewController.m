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
#import <SpriteStackKit/SSKMusicManager.h>
#import <SpriteStackKit/SSKSoundActionManager.h>
#import "KPMainMenuState.h"

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
@property SSKMusicManager* musicManager;

/**
 * @brief The sound manager for sound actions runnable on nodes in the scene graph.
 */
@property SSKSoundActionManager* soundManager;

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
    [self.textures loadTexture:@"pink_monkey_target.png"
                    identifier:TextureIDPinkMonkeyTarget];
    [self.textures loadTexture:@"blue_monkey_target.png"
                    identifier:TextureIDBlueMonkeyTarget];
    [self.textures loadTexture:@"gold_monkey_target.png"
                    identifier:TextureIDGoldMonkeyTarget];
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
    [self.textures loadTexture:@"about_button.png"
                    identifier:TextureIDAboutButton];
    [self.textures loadTexture:@"play_button.png"
                    identifier:TextureIDPlayButton];
    [self.textures loadTexture:@"menu_bg.png"
                    identifier:TextureIDMainMenuBackground];
    [self.textures loadTexture:@"title.png"
                    identifier:TextureIDMainMenuTitle];
    
    // Load music
    self.musicManager = [[SSKMusicManager alloc] initWithSoundCount:3];
    [self.musicManager
        loadSound:@"in_game_music" soundType:@"wav" identifier:SoundIDInGameMusic];
    [self.musicManager
        loadSound:@"menu_music" soundType:@"wav" identifier:SoundIDMenuMusic];
    [self.musicManager
        loadSound:@"victory" soundType:@"wav" identifier:SoundIDVictory];
    
    // load sound effects
    self.soundManager = [[SSKSoundActionManager alloc] initWithSoundCount:12];
    [self.soundManager
        loadSound:@"back_press.wav" identifier:SoundIDBackPress];
    [self.soundManager
        loadSound:@"balloon_pop.wav" identifier:SoundIDBalloonPop];
    [self.soundManager
        loadSound:@"countdown_1.wav" identifier:SoundIDCountdownOne];
    [self.soundManager
        loadSound:@"countdown_2.wav" identifier:SoundIDCountdownTwo];
    [self.soundManager
        loadSound:@"countdown_3.wav" identifier:SoundIDCountdownThree];
    [self.soundManager
        loadSound:@"countdown_go.wav" identifier:SoundIDCountdownGo];
    [self.soundManager
        loadSound:@"forward_press.wav" identifier:SoundIDForwardPress];
    [self.soundManager
        loadSound:@"golden_pop.wav" identifier:SoundIDGoldenPop];
    [self.soundManager
        loadSound:@"lollipop_lick.wav" identifier:SoundIDLollipopLick];
    [self.soundManager
        loadSound:@"lollipop_reload.wav" identifier:SoundIDLollipopReload];
    [self.soundManager
        loadSound:@"lollipop_throw.wav" identifier:SoundIDLollipopThrow];
    
    // Register states
    CGSize landscapeSize =
        [UIApplication sizeInOrientation:UIInterfaceOrientationLandscapeLeft];
    self.stateStack = [[SSKStateStack alloc] initWithTextureManager:self.textures
                                                       musicManager:self.musicManager
                                                       soundManager:self.soundManager
                                                              size:landscapeSize];
    [self.stateStack registerState:[KPStandardGameState class] stateID:StateIDExample];
    [self.stateStack registerState:[KPMainMenuState class] stateID:StateIDMenu];
    
    // Configure the scene
    [self.stateStack pushState:StateIDMenu];
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
@synthesize musicManager;
@synthesize soundManager;

@end
