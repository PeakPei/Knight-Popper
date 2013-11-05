/**
 * @filename KPMainMenuState.m
 * @author Morgan Wall
 * @date 16-10-2013
 */

#import "KPMainMenuState.h"
#import "KPTargetNode.h"
#import "KPActionCategories.h"
#import "TextureIDs.h"
#import "StateIDs.h"
#import "SoundIDs.h"
#import "SoundInstanceIDs.h"
#import <SpriteStackKit/SSKSpriteNode.h>
#import <SpriteStackKit/SSKAction.h>
#import <SpriteStackKit/SSKActionQueue.h>
#import <SpriteStackKit/SSKSpriteAnimationNode.h>
#import <SpriteStackKit/SSKButtonNode.h>

#pragma mark - Interface

@interface KPMainMenuState ()

typedef enum layers {
    LayerIDBackground = 0,
    LayerIDProjectiles,
    LayerIDHUD
} LayerID;

@property SSKActionQueue* actionQueue;

@end

#pragma mark - Implementation

@implementation KPMainMenuState

- (id)initWithStateStack:(SSKStateStack *)stateStack
          textureManager:(SSKTextureManager *)textureManager
           audioDelegate:(id<SSKAudioManagerDelegate>)delegate{
    unsigned int layerCount = 3;
    if (self = [super initWithStateStack:stateStack
                          textureManager:textureManager
                           audioDelegate:delegate
                              layerCount:layerCount]) {
        self.actionQueue = [[SSKActionQueue alloc] init];
    }
    return self;
}

#pragma mark SSKState

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
    
    // Initialise HUD layer
    SSKSpriteNode* title =
        [[SSKSpriteNode alloc]
         initWithTexture:[self.textures getTexture:TextureIDMainMenuTitle]
         state:NULL audioDelegate:self.audioDelegate];
    title.position = CGPointMake(0, 100);
    [self addNodeToLayer:LayerIDBackground node:title];
    
    SSKButtonNode* playButton =
        [[SSKButtonNode alloc]
         initWithTexture:[self.textures getTexture:TextureIDPlayButton]
         state:self audioDelegate:self.audioDelegate
         clickEventBlock:^(SSKButtonNode* node) {
             [node.audioDelegate playSound:SoundIDForwardPress];
             [node.state requestStackClear];
             [node.state requestStackPush:StateIDLoading];
         }];
    playButton.position = CGPointMake(0, -250);
    [self addNodeToLayer:LayerIDBackground node:playButton];
    
    SSKButtonNode* aboutButton =
        [[SSKButtonNode alloc]
         initWithTexture:[self.textures getTexture:TextureIDAboutButton]
         state:self audioDelegate:self.audioDelegate
         clickEventBlock:^(SSKButtonNode* node) {
             [node.audioDelegate playSound:SoundIDForwardPress];
             [node.state requestStackPush:StateIDCredits];
         }];
    aboutButton.position = CGPointMake(-370, -270);
    [self addNodeToLayer:LayerIDBackground node:aboutButton];
    
    [self.audioDelegate playSound:SoundIDMenuMusic
                        loopCount:-1
                       instanceId:SoundInstanceIDMenuMusic];
}

#pragma mark - Properties

@synthesize actionQueue;

@end
