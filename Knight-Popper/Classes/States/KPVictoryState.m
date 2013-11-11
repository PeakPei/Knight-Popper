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

- (void)update:(CFTimeInterval)deltaTime {
    while (![self.actionQueue isEmpty]) {
        [self onAction:[self.actionQueue pop] deltaTime:deltaTime];
    }
}

- (void)buildState {
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
    // TODO: include more elaborate measures to settle ties
    SKTexture* winnerTexture;
    SKTexture* loserTexture;
    
    if (self.playerOneWon) {
        winnerTexture = [self.textures getTexture:TextureIDPlayerOneHeadWinner];
        loserTexture = [self.textures getTexture:TextureIDPlayerTwoHeadLoser];
    } else {
        winnerTexture = [self.textures getTexture:TextureIDPlayerTwoHeadWinner];
        loserTexture = [self.textures getTexture:TextureIDPlayerOneHeadLoser];
    }
    
    CGFloat const WINNER_HEAD_REL_X = -0.245;
    CGFloat const WINNER_HEAD_REL_Y = 0.09;
    CGFloat const LOSER_HEAD_REL_X = 0.19;
    CGFloat const LOSER_HEAD_REL_Y = 0.1425;
    
    SSKSpriteNode* winnerHead =
        [[SSKSpriteNode alloc] initWithTexture:winnerTexture];
    winnerHead.position =
        CGPointMake(self.scene.frame.size.width * WINNER_HEAD_REL_X,
                    self.scene.frame.size.height * WINNER_HEAD_REL_Y);
    [self addNodeToLayer:LayerIDVictoryInfo node:winnerHead];
    
    SSKSpriteNode* loserHead =
        [[SSKSpriteNode alloc] initWithTexture:loserTexture];
    loserHead.position =
        CGPointMake(self.scene.frame.size.width * LOSER_HEAD_REL_X,
                    self.scene.frame.size.height * LOSER_HEAD_REL_Y);
    [self addNodeToLayer:LayerIDVictoryInfo node:loserHead];
    
    // Initialise score labels
    CGFloat const WINNER_POINTS_REL_X = -0.245;
    CGFloat const WINNER_POINTS_REL_Y = -0.08;
    
    SSKLabelNode* winnerPoints = [[SSKLabelNode alloc] initWithFontNamed:@"gameFont"];
    winnerPoints.text = [NSString stringWithFormat:@"%d", self.winnerScore.score];
    winnerPoints.fontSize = self.scene.frame.size.height * 0.06510416667;
    winnerPoints.position =
        CGPointMake(self.scene.frame.size.width * WINNER_POINTS_REL_X,
                    self.scene.frame.size.height * WINNER_POINTS_REL_Y);
    [self addNodeToLayer:LayerIDVictoryInfo node:winnerPoints];
    
    CGFloat const LOSER_POINTS_REL_X = 0.29;
    CGFloat const LOSER_POINTS_REL_Y = 0.15;
    
    SSKLabelNode* loserPoints = [[SSKLabelNode alloc] initWithFontNamed:@"gameFont"];
    loserPoints.text = [NSString stringWithFormat:@"%d", self.loserScore.score];
    loserPoints.fontSize = self.scene.frame.size.height * 0.05208333333;
    loserPoints.position =
        CGPointMake(self.scene.frame.size.width * LOSER_POINTS_REL_X,
                    self.scene.frame.size.height * LOSER_POINTS_REL_Y);
    [self addNodeToLayer:LayerIDVictoryInfo node:loserPoints];
    
    // Initialise stats labels
    CGFloat const WINNER_PINK_REL_X = 0.0;
    CGFloat const WINNER_PINK_REL_Y = 0.1;
    
    SSKLabelNode* winnerPinkCount = [[SSKLabelNode alloc] initWithFontNamed:@"gameFont"];
    winnerPinkCount.text = [NSString stringWithFormat:@"%d", self.winnerStats.pinkTargetsHit];
    winnerPinkCount.fontSize = self.scene.frame.size.height * 0.05208333333;
    winnerPinkCount.position =
        CGPointMake(self.scene.frame.size.width * WINNER_PINK_REL_X,
                    self.scene.frame.size.height * WINNER_PINK_REL_Y);
    [self addNodeToLayer:LayerIDVictoryInfo node:winnerPinkCount];
    
    CGFloat const WINNER_BLUE_REL_X = 0.0;
    CGFloat const WINNER_BLUE_REL_Y = -0.0;
    
    SSKLabelNode* winnerBlueCount = [[SSKLabelNode alloc] initWithFontNamed:@"gameFont"];
    winnerBlueCount.text = [NSString stringWithFormat:@"%d", self.winnerStats.blueTargetsHit];
    winnerBlueCount.fontSize = self.scene.frame.size.height * 0.05208333333;
    winnerBlueCount.position =
        CGPointMake(self.scene.frame.size.width * WINNER_BLUE_REL_X,
                    self.scene.frame.size.height * WINNER_BLUE_REL_Y);
    [self addNodeToLayer:LayerIDVictoryInfo node:winnerBlueCount];
    
    CGFloat const WINNER_GOLD_REL_X = 0.0;
    CGFloat const WINNER_GOLD_REL_Y = -0.1;
    
    SSKLabelNode* winnerGoldCount = [[SSKLabelNode alloc] initWithFontNamed:@"gameFont"];
    winnerGoldCount.text = [NSString stringWithFormat:@"%d", self.winnerStats.goldTargetsHit];
    winnerGoldCount.fontSize = self.scene.frame.size.height * 0.05208333333;
    winnerGoldCount.position =
        CGPointMake(self.scene.frame.size.width * WINNER_GOLD_REL_X,
                    self.scene.frame.size.height * WINNER_GOLD_REL_Y);
    [self addNodeToLayer:LayerIDVictoryInfo node:winnerGoldCount];
    
    CGFloat const LOSER_PINK_REL_X = 0.29;
    CGFloat const LOSER_PINK_REL_Y = -0.03;
    
    SSKLabelNode* loserPinkCount = [[SSKLabelNode alloc] initWithFontNamed:@"gameFont"];
    loserPinkCount.text = [NSString stringWithFormat:@"%d", self.loserStats.pinkTargetsHit];
    loserPinkCount.fontSize = self.scene.frame.size.height * 0.05208333333;
    loserPinkCount.position =
        CGPointMake(self.scene.frame.size.width * LOSER_PINK_REL_X,
                    self.scene.frame.size.height * LOSER_PINK_REL_Y);
    [self addNodeToLayer:LayerIDVictoryInfo node:loserPinkCount];
    
    CGFloat const LOSER_BLUE_REL_X = 0.29;
    CGFloat const LOSER_BLUE_REL_Y = -0.15;
    
    SSKLabelNode* loserBlueCount = [[SSKLabelNode alloc] initWithFontNamed:@"gameFont"];
    loserBlueCount.text = [NSString stringWithFormat:@"%d", self.loserStats.blueTargetsHit];
    loserBlueCount.fontSize = self.scene.frame.size.height * 0.05208333333;
    loserBlueCount.position =
        CGPointMake(self.scene.frame.size.width * LOSER_BLUE_REL_X,
                    self.scene.frame.size.height * LOSER_BLUE_REL_Y);
    [self addNodeToLayer:LayerIDVictoryInfo node:loserBlueCount];
    
    CGFloat const LOSER_GOLD_REL_X = 0.29;
    CGFloat const LOSER_GOLD_REL_Y = -0.25;
    
    SSKLabelNode* loserGoldCount = [[SSKLabelNode alloc] initWithFontNamed:@"gameFont"];
    loserGoldCount.text = [NSString stringWithFormat:@"%d", self.loserStats.goldTargetsHit];
    loserGoldCount.fontSize = self.scene.frame.size.height * 0.05208333333;
    loserGoldCount.position =
        CGPointMake(self.scene.frame.size.width * LOSER_GOLD_REL_X,
                    self.scene.frame.size.height * LOSER_GOLD_REL_Y);
    [self addNodeToLayer:LayerIDVictoryInfo node:loserGoldCount];
    
    // Initialise HUD layer
    CGFloat const RETRY_REL_X = -0.212421875;
    CGFloat const RETRY_REL_Y = -0.2899479167;
    
    SSKButtonNode* retryButton =
        [[SSKButtonNode alloc]
         initWithTexture:[self.textures getTexture:TextureIDRetryButton]
         clickEventBlock:^(SSKButtonNode* node) {
             [node.audioDelegate playSound:SoundIDForwardPress];
             
             if ([node.audioDelegate soundExists:SoundInstanceIDVictorySound]) {
                 [node.audioDelegate stopSound:SoundInstanceIDVictorySound];
             }
             
             [node.state requestStackClear];
             [node.state requestStackPush:StateIDStandardGame data:NULL];
         }];
    retryButton.audioDelegate = self.audioDelegate;
    retryButton.position =
        CGPointMake(self.scene.frame.size.width * RETRY_REL_X,
                    self.scene.frame.size.height * RETRY_REL_Y);
    [self addNodeToLayer:LayerIDHUD node:retryButton];
    
    CGFloat const MENU_REL_X = -0.0530078125;
    CGFloat const MENU_REL_Y = -0.2899479167;
    
    SSKButtonNode* menuButton =
        [[SSKButtonNode alloc]
         initWithTexture:[self.textures getTexture:TextureIDMenuButton]
         clickEventBlock:^(SSKButtonNode* node) {
             [node.audioDelegate playSound:SoundIDBackPress];
             [node.audioDelegate stopSound:SoundInstanceIDInGameMusic];
             
             if ([node.audioDelegate soundExists:SoundInstanceIDVictorySound]) {
                 [node.audioDelegate stopSound:SoundInstanceIDVictorySound];
             }
             
             [node.state requestStackClear];
             [node.state requestStackPush:StateIDMenu data:NULL];
         }];
    menuButton.audioDelegate = self.audioDelegate;
    menuButton.position =
        CGPointMake(self.scene.frame.size.width * MENU_REL_X,
                    self.scene.frame.size.height * MENU_REL_Y);
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
