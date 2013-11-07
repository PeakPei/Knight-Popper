/**
 * @filename KPApplicationViewController.m
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
#import "KPLoadingState.h"
#import "KPCreditsState.h"
#import "KPVictoryState.h"
#import "KPTestState.h"
#import "KPPauseState.h"

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
    [self.textures loadTexture:@"about_button_hover.png"
                    identifier:TextureIDAboutButtonHover];
    [self.textures loadTexture:@"play_button.png"
                    identifier:TextureIDPlayButton];
    [self.textures loadTexture:@"play_button_hover.png"
                    identifier:TextureIDPlayButtonHover];
    [self.textures loadTexture:@"menu_button.png"
                    identifier:TextureIDMenuButton];
    [self.textures loadTexture:@"menu_button_hover.png"
                    identifier:TextureIDMenuButtonHover];
    [self.textures loadTexture:@"retry_button.png"
                    identifier:TextureIDRetryButton];
    [self.textures loadTexture:@"retry_button_hover.png"
                    identifier:TextureIDRetryButtonHover];
    [self.textures loadTexture:@"back_button.png"
                    identifier:TextureIDBackButton];
    [self.textures loadTexture:@"back_button_hover.png"
                    identifier:TextureIDBackButtonHover];
    [self.textures loadTexture:@"menu_bg.png"
                    identifier:TextureIDMainMenuBackground];
    [self.textures loadTexture:@"title.png"
                    identifier:TextureIDMainMenuTitle];
    [self.textures loadTexture:@"lollipop_base.png"
                    identifier:TextureIDLollipopBase];
    [self.textures loadTexture:@"lollipop_top.png"
                    identifier:TextureIDLollipopShadow];
    [self.textures loadTexture:@"victory_bg.png"
                    identifier:TextureIDVictoryBackground];
    [self.textures loadTexture:@"points_blue.png"
                    identifier:TextureIDPointsBlue];
    [self.textures loadTexture:@"points_pink.png"
                    identifier:TextureIDPointsPink];
    [self.textures loadTexture:@"points_gold.png"
                    identifier:TextureIDPointsGold];
    [self.textures loadTexture:@"credits.png"
                    identifier:TextureIDCredits];
    [self.textures loadTexture:@"player1.png"
                    identifier:TextureIDPlayerOneHead];
    [self.textures loadTexture:@"player2.png"
                    identifier:TextureIDPlayerTwoHead];
    [self.textures loadTexture:@"giant_lollipop.png"
                    identifier:TextureIDGiantLollipop];
    [self.textures loadTexture:@"pause_BG.png"
                    identifier:TextureIDPauseBackground];
    [self.textures loadTexture:@"resume.png"
                    identifier:TextureIDResumeButton];
    [self.textures loadTexture:@"resume_hover.png"
                    identifier:TextureIDResumeButtonHover];
    
    // Load music
    self.musicManager = [[SSKMusicManager alloc] initWithSoundCount:3];
    [self.musicManager
        loadSound:@"in_game_music" soundType:@"wav" identifier:SoundIDInGameMusic];
    [self.musicManager
        loadSound:@"menu_music" soundType:@"wav" identifier:SoundIDMenuMusic];
    [self.musicManager
        loadSound:@"victory" soundType:@"wav" identifier:SoundIDVictory];
    [self.musicManager
        loadSound:@"back_press" soundType:@"wav" identifier:SoundIDBackPress];
    [self.musicManager
        loadSound:@"balloon_pop" soundType:@"wav" identifier:SoundIDBalloonPop];
    [self.musicManager
        loadSound:@"countdown_1" soundType:@"wav" identifier:SoundIDCountdownOne];
    [self.musicManager
        loadSound:@"countdown_2" soundType:@"wav" identifier:SoundIDCountdownTwo];
    [self.musicManager
        loadSound:@"countdown_3" soundType:@"wav" identifier:SoundIDCountdownThree];
    [self.musicManager
        loadSound:@"countdown_go" soundType:@"wav" identifier:SoundIDCountdownGo];
    [self.musicManager
        loadSound:@"forward_press" soundType:@"wav" identifier:SoundIDForwardPress];
    [self.musicManager
        loadSound:@"golden_pop" soundType:@"wav" identifier:SoundIDGoldenPop];
    [self.musicManager
        loadSound:@"lollipop_lick" soundType:@"wav" identifier:SoundIDLollipopLick];
    [self.musicManager
        loadSound:@"lollipop_reload" soundType:@"wav" identifier:SoundIDLollipopReload];
    [self.musicManager
        loadSound:@"lollipop_throw" soundType:@"wav" identifier:SoundIDLollipopThrow];
    
    
    // load sound effects
    self.soundManager = [[SSKSoundActionManager alloc] initWithSoundCount:0];
    
    // Register states
    CGSize landscapeSize =
        [UIApplication sizeInOrientation:UIInterfaceOrientationLandscapeLeft];
    self.stateStack = [[SSKStateStack alloc] initWithTextureManager:self.textures
                                                       musicManager:self.musicManager
                                                       soundManager:self.soundManager
                                                              size:landscapeSize];
    [self.stateStack registerState:[KPStandardGameState class] stateID:StateIDStandardGame];
    [self.stateStack registerState:[KPMainMenuState class] stateID:StateIDMenu];
    [self.stateStack registerState:[KPLoadingState class] stateID:StateIDLoading];
    [self.stateStack registerState:[KPCreditsState class] stateID:StateIDCredits];
    [self.stateStack registerState:[KPVictoryState class] stateID:StateIDVictory];
    [self.stateStack registerState:[KPTestState class] stateID:StateIDTest];
    [self.stateStack registerState:[KPPauseState class] stateID:StateIDPause];
    
    // Configure the scene
    [self.stateStack pushState:StateIDStandardGame];
    [self.stateStack pushState:StateIDPause];
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
