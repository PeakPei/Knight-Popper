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
#import <SpriteStackKit/SSKTextureManager.h>
#import <SpriteStackKit/SSKMusicManager.h>
#import <SpriteStackKit/SSKSoundActionManager.h>
#import "KPMainMenuState.h"
#import "KPLoadingState.h"
#import "KPCreditsState.h"
#import "KPVictoryState.h"
#import "KPPauseState.h"
#import "KPStateStack.h"
#import "KPState.h"

#pragma mark - Interface

@interface KPApplicationViewController ()

/**
 * @brief The state stack used to describe the scene.
 */
@property KPStateStack* stateStack;

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
//    self.stateView = (SKView*)self.view;
    
//    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 640, 1136)];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.stateView = (SKView*)self.view;
    
    // Load textures
    self.textures = [[SSKTextureManager alloc] initWithTextureCount:20];
    
    [self.textures loadTexture:@"background-568h@2x.png"
                    identifier:TextureIDBackground];
    [self.textures loadTexture:@"GrassTuft_Left@2x.png"
                    identifier:TextureIDGrassTuftLeft];
    [self.textures loadTexture:@"GrassTuft_Right@2x.png"
                    identifier:TextureIDGrassTuftRight];
    [self.textures loadTexture:@"blue_monkey_HUD@2x.png"
                    identifier:TextureIDBlueMonkeyHUD];
    [self.textures loadTexture:@"pink_monkey_HUD@2x.png"
                    identifier:TextureIDPinkMonkeyHUD];
    [self.textures loadTexture:@"pink_monkey_target@2x.png"
                    identifier:TextureIDPinkMonkeyTarget];
    [self.textures loadTexture:@"blue_monkey_target@2x.png"
                    identifier:TextureIDBlueMonkeyTarget];
    [self.textures loadTexture:@"gold_monkey_target@2x.png"
                    identifier:TextureIDGoldMonkeyTarget];
    [self.textures loadTexture:@"blue_pop@2x.png"
                    identifier:TextureIDBluePop];
    [self.textures loadTexture:@"pink_pop@2x.png"
                    identifier:TextureIDPinkPop];
    [self.textures loadTexture:@"gold_pop@2x.png"
                    identifier:TextureIDGoldPop];
    [self.textures loadTexture:@"countdown@2x.png"
                    identifier:TextureIDCountdown];
    [self.textures loadTexture:@"gold_twinkle@2x.png"
                    identifier:TextureIDGoldTwinkle];
    [self.textures loadTexture:@"lollipop_left_projectile@2x.png"
                    identifier:TextureIDLollipopLeftProjectile];
    [self.textures loadTexture:@"lollipop_right_projectile@2x.png"
                    identifier:TextureIDLollipopRightProjectile];
    [self.textures loadTexture:@"menu_lollipop@2x.png"
                    identifier:TextureIDMenuLollipop];
    [self.textures loadTexture:@"player_one_attack@2x.png"
                    identifier:TextureIDPlayerOneAttack];
    [self.textures loadTexture:@"player_one_idle@2x.png"
                    identifier:TextureIDPlayerOneIdle];
    [self.textures loadTexture:@"player_two_attack@2x.png"
                    identifier:TextureIDPlayerTwoAttack];
    [self.textures loadTexture:@"player_two_idle@2x.png"
                    identifier:TextureIDPlayerTwoIdle];
    [self.textures loadTexture:@"times_up@2x.png"
                    identifier:TextureIDTimeUp];
    [self.textures loadTexture:@"game_timer@2x.png"
                    identifier:TextureIDTimer];
    [self.textures loadTexture:@"about_button@2x.png"
                    identifier:TextureIDAboutButton];
    [self.textures loadTexture:@"about_button_hover@2x.png"
                    identifier:TextureIDAboutButtonHover];
    [self.textures loadTexture:@"play_button@2x.png"
                    identifier:TextureIDPlayButton];
    [self.textures loadTexture:@"play_button_hover@2x.png"
                    identifier:TextureIDPlayButtonHover];
    [self.textures loadTexture:@"menu_button@2x.png"
                    identifier:TextureIDMenuButton];
    [self.textures loadTexture:@"menu_button_hover@2x.png"
                    identifier:TextureIDMenuButtonHover];
    [self.textures loadTexture:@"retry_button@2x.png"
                    identifier:TextureIDRetryButton];
    [self.textures loadTexture:@"retry_button_hover@2x.png"
                    identifier:TextureIDRetryButtonHover];
    [self.textures loadTexture:@"back_button@2x.png"
                    identifier:TextureIDBackButton];
    [self.textures loadTexture:@"back_button_hover@2x.png"
                    identifier:TextureIDBackButtonHover];
    [self.textures loadTexture:@"menu_bg-568h@2x.png"
                    identifier:TextureIDMainMenuBackground];
    [self.textures loadTexture:@"title@2x.png"
                    identifier:TextureIDMainMenuTitle];
    [self.textures loadTexture:@"lollipop_base@2x.png"
                    identifier:TextureIDLollipopBase];
    [self.textures loadTexture:@"lollipop_top@2x.png"
                    identifier:TextureIDLollipopShadow];
    [self.textures loadTexture:@"victory_bg@2x.png"
                    identifier:TextureIDVictoryBackground];
    [self.textures loadTexture:@"points_blue@2x.png"
                    identifier:TextureIDPointsBlue];
    [self.textures loadTexture:@"points_pink@2x.png"
                    identifier:TextureIDPointsPink];
    [self.textures loadTexture:@"points_gold@2x.png"
                    identifier:TextureIDPointsGold];
    [self.textures loadTexture:@"credits@2x.png"
                    identifier:TextureIDCredits];
    [self.textures loadTexture:@"winner_player1@2x.png"
                    identifier:TextureIDPlayerOneHeadWinner];
    [self.textures loadTexture:@"winner_player2@2x.png"
                    identifier:TextureIDPlayerTwoHeadWinner];
    [self.textures loadTexture:@"loser_player1@2x.png"
                    identifier:TextureIDPlayerOneHeadLoser];
    [self.textures loadTexture:@"loser_player2@2x.png"
                    identifier:TextureIDPlayerTwoHeadLoser];
    [self.textures loadTexture:@"pauseButton@2x.png"
                    identifier:TextureIDPauseButton];
    [self.textures loadTexture:@"pauseButton_hover@2x.png"
                    identifier:TextureIDPauseButtonHover];
    [self.textures loadTexture:@"pause_BG@2x.png"
                    identifier:TextureIDPauseBackground];
    [self.textures loadTexture:@"resume@2x.png"
                    identifier:TextureIDResumeButton];
    [self.textures loadTexture:@"resume_hover@2x.png"
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
    landscapeSize = CGSizeMake(1136, 640);
    self.stateStack = [[KPStateStack alloc] initWithTextureManager:self.textures
                                                      musicManager:self.musicManager
                                                      soundManager:self.soundManager
                                                              size:landscapeSize];
    [self.stateStack registerState:[KPStandardGameState class] stateID:StateIDStandardGame];
    [self.stateStack registerState:[KPMainMenuState class] stateID:StateIDMenu];
    [self.stateStack registerState:[KPLoadingState class] stateID:StateIDLoading];
    [self.stateStack registerState:[KPCreditsState class] stateID:StateIDCredits];
    [self.stateStack registerState:[KPVictoryState class] stateID:StateIDVictory];
    [self.stateStack registerState:[KPPauseState class] stateID:StateIDPause];
    self.stateStack.physicsWorld.contactDelegate = self.stateStack;
    
    // Configure the scene
    self.stateStack.spriteView = self.stateView;
    [self.stateStack pushState:StateIDMenu data:NULL];
    [(id)self.stateView presentScene:self.stateStack];
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
