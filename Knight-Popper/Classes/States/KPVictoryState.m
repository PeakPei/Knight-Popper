/**
 * @filename KPVictoryState.m
 * @author Morgan Wall
 * @date 6-11-2013
 */

#import "KPVictoryState.h"
#import <SpriteStackKit/SSKActionQueue.h>
#import <SpriteStackKit/SSKSpriteNode.h>
#import <SpriteStackKit/SSKButtonNode.h>
#import "TextureIDs.h"
#import "StateIDs.h"
#import "SoundIDs.h"
#import "SoundInstanceIDs.h"
#import "KPPlayerScore.h"
#import "KPPlayerStats.h"
#import "StateDataKeys.h"
#import <SpriteStackKit/SSKLabelNode.h>
#import "Coordinates.h"

#pragma mark - Interface

@interface KPVictoryState()

typedef enum layers {
    LayerIDBackground = 0,
    LayerIDProjectiles,
    LayerIDVictoryBackground,
    LayerIDVictoryInfo,
    LayerIDHUD
} LayerID;

@property SSKActionQueue* actionQueue;

@property BOOL playerOneWon;

@property KPPlayerScore* winnerScore;

@property KPPlayerStats* winnerStats;

@property KPPlayerScore* loserScore;

@property KPPlayerStats* loserStats;

@end

#pragma mark - Implementation

@implementation KPVictoryState

- (id)initWithStateStack:(SSKStateStack *)stateStack
          textureManager:(SSKTextureManager *)textureManager
           audioDelegate:(id<SSKAudioManagerDelegate>)delegate
                    data:(NSDictionary *)data {
    unsigned int const LAYER_COUNT = 5;
    if (self = [super initWithStateStack:stateStack
                          textureManager:textureManager
                           audioDelegate:delegate
                                    data:data
                              layerCount:LAYER_COUNT]) {
        KPPlayerScore* playerOneScore =
            [data objectForKey:[NSNumber numberWithInt:StateDataKeyPlayerOneScore]];
        KPPlayerScore* playerTwoScore =
            [data objectForKey:[NSNumber numberWithInt:StateDataKeyPlayerTwoScore]];
        KPPlayerStats* playerOneStats =
            [data objectForKey:[NSNumber numberWithInt:StateDataKeyPlayerOneStats]];
        KPPlayerStats* playerTwoStats =
            [data objectForKey:[NSNumber numberWithInt:StateDataKeyPlayerTwoStats]];
        
        if (playerOneScore.score >= playerTwoScore.score) {
            self.playerOneWon = YES;
            self.winnerScore = playerOneScore;
            self.winnerStats = playerOneStats;
            self.loserScore = playerTwoScore;
            self.loserStats = playerTwoStats;
        } else {
            self.playerOneWon = NO;
            self.winnerScore = playerTwoScore;
            self.winnerStats = playerTwoStats;
            self.loserScore = playerOneScore;
            self.loserStats = playerOneStats;
        }
        
        self.actionQueue = [[SSKActionQueue alloc] init];
    }
    return self;
}

- (BOOL)update:(CFTimeInterval)deltaTime {
    BOOL activeThisFrame = self.isActive;
    
    if (activeThisFrame) {
        while (![self.actionQueue isEmpty]) {
            [self onAction:[self.actionQueue pop] deltaTime:deltaTime];
        }
    }
    
    return activeThisFrame;
}

- (void)buildState {
    // determine element positioning based on device type
    // N.B. The credits pages background texture has a different aspect ratio
    // between iPad and iPhone. As such, an element cannot be given a general
    // relative positioning which can be scaled between devices (as done for
    // other KPStates).
    
    // initialise using relative positioning coordinates suited for iPads
    // N.B. For consistency, all position variables are specified relative to an
    // iPhone screen (in points) and later translated for the appropriate device
    // (e.g. iPads and R4 iPhones).

    // TODO: clean up this code by avoiding translating from iPhone in all cases.
    // This has not been done due to time constraints.
    CGFloat WINNER_HEAD_REL_X = -0.240;
    CGFloat WINNER_HEAD_REL_Y = 0.082;
    CGFloat LOSER_HEAD_REL_X = 0.1935;
    CGFloat LOSER_HEAD_REL_Y = 0.1425;
    CGFloat WINNER_POINTS_REL_X = -0.239625;
    CGFloat WINNER_POINTS_REL_Y = -0.08;
    CGFloat LOSER_POINTS_REL_X = 0.284625;
    CGFloat LOSER_POINTS_REL_Y = 0.14;
    CGFloat WINNER_PINK_REL_X = 0.03375;
    CGFloat WINNER_PINK_REL_Y = 0.095;
    CGFloat WINNER_BLUE_REL_X = 0.03825;
    CGFloat WINNER_BLUE_REL_Y = -0.015;
    CGFloat WINNER_GOLD_REL_X = 0.0405;
    CGFloat WINNER_GOLD_REL_Y = -0.128;
    CGFloat LOSER_PINK_REL_X = 0.3105;
    CGFloat LOSER_PINK_REL_Y = -0.0165;
    CGFloat LOSER_BLUE_REL_X = 0.31275;
    CGFloat LOSER_BLUE_REL_Y = -0.128;
    CGFloat LOSER_GOLD_REL_X = 0.316125;
    CGFloat LOSER_GOLD_REL_Y = -0.241;
    CGFloat RETRY_REL_X = -0.216475;
    CGFloat RETRY_REL_Y = -0.2899479167;
    CGFloat MENU_REL_X = -0.037134;
    CGFloat MENU_REL_Y = -0.2849479167;
    
    // modify relative positioning coordinates for iPhones
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        WINNER_HEAD_REL_X = -0.217;
        WINNER_HEAD_REL_Y = 0.082;
        LOSER_HEAD_REL_X = 0.168;
        LOSER_HEAD_REL_Y = 0.1425;
        WINNER_POINTS_REL_X = -0.212925;
        WINNER_POINTS_REL_Y = -0.08;
        LOSER_POINTS_REL_X = 0.2525;
        LOSER_POINTS_REL_Y = 0.14;
        WINNER_PINK_REL_X = 0.03075;
        WINNER_PINK_REL_Y = 0.095;
        WINNER_BLUE_REL_X = 0.03525;
        WINNER_BLUE_REL_Y = -0.015;
        WINNER_GOLD_REL_X = 0.0375;
        WINNER_GOLD_REL_Y = -0.128;
        LOSER_PINK_REL_X = 0.275;
        LOSER_PINK_REL_Y = -0.0165;
        LOSER_BLUE_REL_X = 0.279;
        LOSER_BLUE_REL_Y = -0.128;
        LOSER_GOLD_REL_X = 0.282375;
        LOSER_GOLD_REL_Y = -0.241;
        RETRY_REL_X = -0.19475;
        RETRY_REL_Y = -0.2899479167;
        MENU_REL_X = -0.037134;
        MENU_REL_Y = -0.2849479167;
    }
    
    // Initialise background layer
    SSKSpriteNode* background =
        [[SSKSpriteNode alloc]
         initWithTexture:[self.textures getTexture:TextureIDBackground]];
    background.position = CGPointZero;
    [self addNodeToLayer:LayerIDBackground node:background];
    
    // Initialise victory background layer
    SSKSpriteNode* victoryBackground =
        [[SSKSpriteNode alloc]
         initWithTexture:[self.textures getTexture:TextureIDVictoryBackground]];
    victoryBackground.position = CGPointZero;
    [self addNodeToLayer:LayerIDVictoryBackground node:victoryBackground];
    
    // Initialise the victory info layer
    UIColor* textColour =
        [UIColor colorWithRed:9.0/255.0 green:108.0/255.0 blue:172.0/255.0 alpha:1.0];
    
    SKTexture* winnerTexture;
    SKTexture* loserTexture;
    
    if (self.playerOneWon) {
        winnerTexture = [self.textures getTexture:TextureIDPlayerOneHeadWinner];
        loserTexture = [self.textures getTexture:TextureIDPlayerTwoHeadLoser];
    } else {
        winnerTexture = [self.textures getTexture:TextureIDPlayerTwoHeadWinner];
        loserTexture = [self.textures getTexture:TextureIDPlayerOneHeadLoser];
    }
    
    SSKSpriteNode* winnerHead =
        [[SSKSpriteNode alloc] initWithTexture:winnerTexture];
    winnerHead.position = CGPointMake(
        [Coordinates convertXFromiPhone:IPHONE_LANDSCAPE_WIDTH_PTS * WINNER_HEAD_REL_X
                    scalesForWidescreen:NO],
        [Coordinates convertYFromiPhone:IPHONE_LANDSCAPE_HEIGHT_PTS * WINNER_HEAD_REL_Y]);
    [self addNodeToLayer:LayerIDVictoryInfo node:winnerHead];
    
    SSKSpriteNode* loserHead =
        [[SSKSpriteNode alloc] initWithTexture:loserTexture];
    loserHead.position = CGPointMake(
        [Coordinates convertXFromiPhone:IPHONE_LANDSCAPE_WIDTH_PTS * LOSER_HEAD_REL_X
                    scalesForWidescreen:NO],
        [Coordinates convertYFromiPhone:IPHONE_LANDSCAPE_HEIGHT_PTS * LOSER_HEAD_REL_Y]);
    [self addNodeToLayer:LayerIDVictoryInfo node:loserHead];
    
    // Initialise score labels
    SSKLabelNode* winnerPoints = [SSKLabelNode labelNodeWithFontNamed:@"CurseCasualJVE"];
    winnerPoints.text = [NSString stringWithFormat:@"%d", self.winnerScore.score];
    winnerPoints.fontColor = textColour;
    winnerPoints.fontSize = self.scene.frame.size.height * 0.1;
    winnerPoints.position = CGPointMake(
        [Coordinates convertXFromiPhone:IPHONE_LANDSCAPE_WIDTH_PTS * WINNER_POINTS_REL_X
                    scalesForWidescreen:NO],
        [Coordinates convertYFromiPhone:IPHONE_LANDSCAPE_HEIGHT_PTS * WINNER_POINTS_REL_Y]);
    [self addNodeToLayer:LayerIDVictoryInfo node:winnerPoints];
    
    SSKLabelNode* loserPoints = [SSKLabelNode labelNodeWithFontNamed:@"CurseCasualJVE"];
    loserPoints.text = [NSString stringWithFormat:@"%d", self.loserScore.score];
    loserPoints.fontColor = textColour;
    loserPoints.fontSize = self.scene.frame.size.height * 0.075;
    loserPoints.position = CGPointMake(
        [Coordinates convertXFromiPhone:IPHONE_LANDSCAPE_WIDTH_PTS * LOSER_POINTS_REL_X
                    scalesForWidescreen:NO],
        [Coordinates convertYFromiPhone:IPHONE_LANDSCAPE_HEIGHT_PTS * LOSER_POINTS_REL_Y]);
    [self addNodeToLayer:LayerIDVictoryInfo node:loserPoints];
    
    // Initialise stats labels
    SSKLabelNode* winnerPinkCount = [SSKLabelNode labelNodeWithFontNamed:@"CurseCasualJVE"];
    winnerPinkCount.text = [NSString stringWithFormat:@"x%d", self.winnerStats.pinkTargetsHit];
    winnerPinkCount.fontColor = textColour;
    winnerPinkCount.fontSize = self.scene.frame.size.height * 0.05208333333;
    winnerPinkCount.position = CGPointMake(
        [Coordinates convertXFromiPhone:IPHONE_LANDSCAPE_WIDTH_PTS * WINNER_PINK_REL_X
                    scalesForWidescreen:NO]
            - winnerPinkCount.frame.size.width/2.0f,
        [Coordinates convertYFromiPhone:IPHONE_LANDSCAPE_HEIGHT_PTS * WINNER_PINK_REL_Y]);
    [self addNodeToLayer:LayerIDVictoryInfo node:winnerPinkCount];
    
    SSKLabelNode* winnerBlueCount = [SSKLabelNode labelNodeWithFontNamed:@"CurseCasualJVE"];
    winnerBlueCount.text = [NSString stringWithFormat:@"x%d", self.winnerStats.blueTargetsHit];
    winnerBlueCount.fontColor = textColour;
    winnerBlueCount.fontSize = self.scene.frame.size.height * 0.05208333333;
    winnerBlueCount.position = CGPointMake(
        [Coordinates convertXFromiPhone:IPHONE_LANDSCAPE_WIDTH_PTS * WINNER_BLUE_REL_X
                    scalesForWidescreen:NO]
            - winnerBlueCount.frame.size.width/2.0f,
        [Coordinates convertYFromiPhone:IPHONE_LANDSCAPE_HEIGHT_PTS * WINNER_BLUE_REL_Y]);
    [self addNodeToLayer:LayerIDVictoryInfo node:winnerBlueCount];
    
    SSKLabelNode* winnerGoldCount = [SSKLabelNode labelNodeWithFontNamed:@"CurseCasualJVE"];
    winnerGoldCount.text = [NSString stringWithFormat:@"x%d", self.winnerStats.goldTargetsHit];
    winnerGoldCount.fontColor = textColour;
    winnerGoldCount.fontSize = self.scene.frame.size.height * 0.05208333333;
    winnerGoldCount.position = CGPointMake(
        [Coordinates convertXFromiPhone:IPHONE_LANDSCAPE_WIDTH_PTS * WINNER_GOLD_REL_X
                    scalesForWidescreen:NO]
            - winnerGoldCount.frame.size.width/2.0f,
        [Coordinates convertYFromiPhone:IPHONE_LANDSCAPE_HEIGHT_PTS * WINNER_GOLD_REL_Y]);
    [self addNodeToLayer:LayerIDVictoryInfo node:winnerGoldCount];
    
    SSKLabelNode* loserPinkCount = [SSKLabelNode labelNodeWithFontNamed:@"CurseCasualJVE"];
    loserPinkCount.text = [NSString stringWithFormat:@"x%d", self.loserStats.pinkTargetsHit];
    loserPinkCount.fontColor = textColour;
    loserPinkCount.fontSize = self.scene.frame.size.height * 0.05208333333;
    loserPinkCount.position = CGPointMake(
        [Coordinates convertXFromiPhone:IPHONE_LANDSCAPE_WIDTH_PTS * LOSER_PINK_REL_X
                    scalesForWidescreen:NO]
            - loserPinkCount.frame.size.width/2.0f,
        [Coordinates convertYFromiPhone:IPHONE_LANDSCAPE_HEIGHT_PTS * LOSER_PINK_REL_Y]);
    [self addNodeToLayer:LayerIDVictoryInfo node:loserPinkCount];
    
    SSKLabelNode* loserBlueCount = [SSKLabelNode labelNodeWithFontNamed:@"CurseCasualJVE"];
    loserBlueCount.text = [NSString stringWithFormat:@"x%d", self.loserStats.blueTargetsHit];
    loserBlueCount.fontColor = textColour;
    loserBlueCount.fontSize = self.scene.frame.size.height * 0.05208333333;
    loserBlueCount.position = CGPointMake(
        [Coordinates convertXFromiPhone:IPHONE_LANDSCAPE_WIDTH_PTS * LOSER_BLUE_REL_X
                    scalesForWidescreen:NO]
            - loserBlueCount.frame.size.width/2.0f,
        [Coordinates convertYFromiPhone:IPHONE_LANDSCAPE_HEIGHT_PTS * LOSER_BLUE_REL_Y]);
    [self addNodeToLayer:LayerIDVictoryInfo node:loserBlueCount];
    
    SSKLabelNode* loserGoldCount = [SSKLabelNode labelNodeWithFontNamed:@"CurseCasualJVE"];
    loserGoldCount.text = [NSString stringWithFormat:@"x%d", self.loserStats.goldTargetsHit];
    loserGoldCount.fontColor = textColour;
    loserGoldCount.fontSize = self.scene.frame.size.height * 0.05208333333;
    loserGoldCount.position = CGPointMake(
        [Coordinates convertXFromiPhone:IPHONE_LANDSCAPE_WIDTH_PTS * LOSER_GOLD_REL_X
                    scalesForWidescreen:NO]
            - loserGoldCount.frame.size.width/2.0f,
        [Coordinates convertYFromiPhone:IPHONE_LANDSCAPE_HEIGHT_PTS * LOSER_GOLD_REL_Y]);
    [self addNodeToLayer:LayerIDVictoryInfo node:loserGoldCount];
    
    // Initialise HUD layer
    SSKButtonNode* retryButton =
        [[SSKButtonNode alloc]
         initWithDefaultTexture:[self.textures getTexture:TextureIDRetryButton]
         pressedTexture:[self.textures getTexture:TextureIDRetryButtonHover]
         beginPressBlock:NULL
         endPressBlock:^(SSKButtonNode* node) {
             [node.audioDelegate playSound:SoundIDForwardPress];
             
             if ([node.audioDelegate soundExists:SoundInstanceIDVictorySound]) {
                 [node.audioDelegate stopSound:SoundInstanceIDVictorySound];
             }
             
             [node.state requestStackClear];
             [node.state requestStackPush:StateIDStandardGame data:NULL];
         }];
    retryButton.audioDelegate = self.audioDelegate;
    retryButton.position = CGPointMake(
        [Coordinates convertXFromiPhone:IPHONE_LANDSCAPE_WIDTH_PTS * RETRY_REL_X
                    scalesForWidescreen:NO],
        [Coordinates convertYFromiPhone:IPHONE_LANDSCAPE_HEIGHT_PTS * RETRY_REL_Y]);
    [self addNodeToLayer:LayerIDHUD node:retryButton];
    
    SSKButtonNode* menuButton =
        [[SSKButtonNode alloc]
         initWithDefaultTexture:[self.textures getTexture:TextureIDMenuButton]
         pressedTexture:[self.textures getTexture:TextureIDMenuButtonHover]
         beginPressBlock:NULL
         endPressBlock:^(SSKButtonNode* node) {
             [node.audioDelegate playSound:SoundIDBackPress];
             [node.audioDelegate stopSound:SoundInstanceIDInGameMusic];
             
             if ([node.audioDelegate soundExists:SoundInstanceIDVictorySound]) {
                 [node.audioDelegate stopSound:SoundInstanceIDVictorySound];
             }
             
             [node.state requestStackClear];
             [node.state requestStackPush:StateIDMenu data:NULL];
         }];
    menuButton.audioDelegate = self.audioDelegate;
    menuButton.position = CGPointMake(
        [Coordinates convertXFromiPhone:IPHONE_LANDSCAPE_WIDTH_PTS * MENU_REL_X
                    scalesForWidescreen:NO],
        [Coordinates convertYFromiPhone:IPHONE_LANDSCAPE_HEIGHT_PTS * MENU_REL_Y]);
    [self addNodeToLayer:LayerIDHUD node:menuButton];
}

#pragma mark - Properties

@synthesize actionQueue;
@synthesize winnerScore;
@synthesize loserScore;
@synthesize winnerStats;
@synthesize loserStats;
@synthesize playerOneWon;

@end
