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
         initWithTexture:[self.textures getTexture:TextureIDMainMenuBackground]
         state:NULL audioDelegate:self.audioDelegate];
    background.position = CGPointZero;
    [self addNodeToLayer:LayerIDBackground node:background];
    
    // Initialise credits info layer
    SSKSpriteNode* victoryBackground =
        [[SSKSpriteNode alloc]
         initWithTexture:[self.textures getTexture:TextureIDVictoryBackground]
         state:NULL audioDelegate:self.audioDelegate];
    victoryBackground.position = CGPointZero;
    [self addNodeToLayer:LayerIDVictoryBackground node:victoryBackground];
    
    // Initialise HUD layer
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
             [node.state requestStackPush:StateIDExample];
         }];
    retryButton.position = CGPointMake(-370, -270);
    [self addNodeToLayer:LayerIDHUD node:retryButton];
    
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
    menuButton.position = CGPointMake(370, -270);
    [self addNodeToLayer:LayerIDHUD node:menuButton];
}

#pragma mark - Properties

@synthesize actionQueue;

@end
