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

@end

#pragma mark - Implementation

@implementation KPVictoryState

- (id)initWithStateStack:(SSKStateStack *)stateStack
          textureManager:(SSKTextureManager *)textureManager
           audioDelegate:(id<SSKAudioManagerDelegate>)delegate {
    unsigned int const LAYER_COUNT = 5;
    if (self = [super initWithStateStack:stateStack
                          textureManager:textureManager
                           audioDelegate:delegate
                              layerCount:LAYER_COUNT]) {
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
         initWithTexture:[self.textures getTexture:TextureIDBackground]
         state:NULL audioDelegate:self.audioDelegate];
    background.position = CGPointZero;
    [self addNodeToLayer:LayerIDBackground node:background];
    
    // Initialise victory background layer
    SSKSpriteNode* victoryBackground =
        [[SSKSpriteNode alloc]
         initWithTexture:[self.textures getTexture:TextureIDVictoryBackground]
         state:NULL audioDelegate:self.audioDelegate];
    victoryBackground.position = CGPointZero;
    [self addNodeToLayer:LayerIDVictoryBackground node:victoryBackground];
    
    // Initialise HUD layer
    CGFloat const RETRY_REL_X = -0.212421875;
    CGFloat const RETRY_REL_Y = -0.2899479167;
    
    SSKButtonNode* retryButton =
        [[SSKButtonNode alloc]
         initWithTexture:[self.textures getTexture:TextureIDRetryButton]
         state:self audioDelegate:self.audioDelegate
         clickEventBlock:^(SSKButtonNode* node) {
             [node.audioDelegate playSound:SoundIDForwardPress];
             
             if ([node.audioDelegate soundExists:SoundInstanceIDVictorySound]) {
                 [node.audioDelegate stopSound:SoundInstanceIDVictorySound];
             }
             
             [node.state requestStackClear];
             [node.state requestStackPush:StateIDStandardGame];
         }];
    retryButton.position =
        CGPointMake(self.scene.frame.size.width * RETRY_REL_X,
                    self.scene.frame.size.height * RETRY_REL_Y);
    [self addNodeToLayer:LayerIDHUD node:retryButton];
    
    CGFloat const MENU_REL_X = -0.0530078125;
    CGFloat const MENU_REL_Y = -0.2899479167;
    
    SSKButtonNode* menuButton =
        [[SSKButtonNode alloc]
         initWithTexture:[self.textures getTexture:TextureIDMenuButton]
         state:self audioDelegate:self.audioDelegate
         clickEventBlock:^(SSKButtonNode* node) {
             [node.audioDelegate playSound:SoundIDBackPress];
             [node.audioDelegate stopSound:SoundInstanceIDInGameMusic];
             
             if ([node.audioDelegate soundExists:SoundInstanceIDVictorySound]) {
                 [node.audioDelegate stopSound:SoundInstanceIDVictorySound];
             }
             
             [node.state requestStackClear];
             [node.state requestStackPush:StateIDMenu];
         }];
    menuButton.position =
        CGPointMake(self.scene.frame.size.width * MENU_REL_X,
                    self.scene.frame.size.height * MENU_REL_Y);
    [self addNodeToLayer:LayerIDHUD node:menuButton];
}

#pragma mark - Properties

@synthesize actionQueue;

@end
