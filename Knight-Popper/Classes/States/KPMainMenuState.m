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
#import "KPSpriteNode.h"
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

#pragma mark HHState

- (void)update:(CFTimeInterval)deltaTime {
    // stub
    while (![self.actionQueue isEmpty]) {
        [self onAction:[self.actionQueue pop] deltaTime:deltaTime];
    }
}

- (void)buildState {
    // Initialise background layer
    KPSpriteNode* background =
    [[KPSpriteNode alloc]
     initWithTexture:[self.textures getTexture:TextureIDMainMenuBackground]
     state:NULL audioDelegate:self.audioDelegate];
    background.position = CGPointZero;
    [self addNodeToLayer:LayerIDBackground node:background];
    
    // Initialise HUD layer
    KPSpriteNode* title =
    [[KPSpriteNode alloc]
     initWithTexture:[self.textures getTexture:TextureIDMainMenuTitle]
     state:NULL audioDelegate:self.audioDelegate];
    title.position = CGPointMake(0, 100);
    [self addNodeToLayer:LayerIDBackground node:title];
    
    void(^playButtonPress)(SSKButtonNode*) = ^(SSKButtonNode* node) {
        [self.audioDelegate playSound:SoundIDForwardPress];
        [node.state requestStackClear];
        [node.state requestStackPush:StateIDLoading];
    };
    
    SSKButtonNode* playButton =
    [[SSKButtonNode alloc]
     initWithTexture:[self.textures getTexture:TextureIDPlayButton]
     state:self audioDelegate:self.audioDelegate clickEventBlock:playButtonPress];
    playButton.position = CGPointMake(0, -250);
    [self addNodeToLayer:LayerIDBackground node:playButton];
    
    KPSpriteNode* aboutButton =
    [[KPSpriteNode alloc]
     initWithTexture:[self.textures getTexture:TextureIDAboutButton]
     state:NULL audioDelegate:self.audioDelegate];
    aboutButton.position = CGPointMake(-370, -270);
    [self addNodeToLayer:LayerIDBackground node:aboutButton];
    
    [self.audioDelegate playSound:SoundIDMenuMusic loopCount:-1 instanceId:0];
}

#pragma mark - Properties

@synthesize actionQueue;

@end
