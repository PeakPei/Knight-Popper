/**
 * @filename KPStandardGameState.m
 * @author Morgan Wall
 * @date 5-10-2013
 */

#import "KPStandardGameState.h"
#import "KPTargetNode.h"
#import "KPActionCategories.h"
#import "TextureIDs.h"
#import "SoundIDs.h"
#import "KPSpriteNode.h"
#import <SpriteStackKit/SSKAction.h>
#import <SpriteStackKit/SSKActionQueue.h>
#import <SpriteStackKit/SSKSpriteAnimationNode.h>
#import <SpriteStackKit/SSKButtonNode.h>

#pragma mark - Interface

@interface KPStandardGameState ()

typedef enum layers {
    LayerIDBackground = 0,
    LayerIDHUD,
    LayerIDPlayers,
    LayerIDScenery,
    LayerIDTargets,
    LayerIDProjectiles
} LayerID;

@property SSKActionQueue* actionQueue;

@end

#pragma mark - Implementation

@implementation KPStandardGameState

- (id)initWithStateStack:(SSKStateStack *)stateStack
          textureManager:(SSKTextureManager *)textureManager
           audioDelegate:(id<SSKAudioManagerDelegate>)delegate{
    unsigned int layerCount = 6;
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
        [self onAction:[self.actionQueue pop]];
    }
}

- (void)buildState {
    // Initialise background layer
    KPSpriteNode* background =
    [[KPSpriteNode alloc] initWithTexture:[self.textures getTexture:TextureIDBackground]
                                    state:NULL
                             audioDelegate:self.audioDelegate];
    background.position = CGPointZero;
    [self addNodeToLayer:LayerIDBackground node:background];
    
    // Initialise demo layer
    void(^pinkBalloonClick)(SSKButtonNode*) = ^(SSKButtonNode* node) {
        [node.audioDelegate playSound:SoundIDBalloonPop];
    };
    
    void(^blueBalloonClick)(SSKButtonNode*) = ^(SSKButtonNode* node) {
        [node.audioDelegate playSound:SoundIDBalloonPop];
    };
    
    void(^goldBalloonClick)(SSKButtonNode*) = ^(SSKButtonNode* node) {
        [node.audioDelegate playSound:SoundIDGoldenPop];
    };
    
    void(^throwClick)(SSKButtonNode*) = ^(SSKButtonNode* node) {
        [node.audioDelegate playSound:SoundIDLollipopThrow];
    };
    
    void(^reloadClick)(SSKButtonNode*) = ^(SSKButtonNode* node) {
        [node.audioDelegate playSound:SoundIDLollipopReload];
    };
    
    void(^oneTimerClick)(SSKButtonNode*) = ^(SSKButtonNode* node) {
        [node.audioDelegate playSound:SoundIDCountdownOne];
    };
    
    void(^twoTimerClick)(SSKButtonNode*) = ^(SSKButtonNode* node) {
        [node.audioDelegate playSound:SoundIDCountdownTwo];
    };
    
    void(^threeTimerClick)(SSKButtonNode*) = ^(SSKButtonNode* node) {
        [node.audioDelegate playSound:SoundIDCountdownThree];
    };
    
    void(^goClick)(SSKButtonNode*) = ^(SSKButtonNode* node) {
        [node.audioDelegate playSound:SoundIDCountdownGo];
    };
    
    SSKButtonNode *pinkBalloon =
    [[SSKButtonNode alloc]
     initWithTexture:[SKTexture textureWithRect:CGRectMake(0, 0, 1.0/8.0, 1.0/3.0)
                                      inTexture:[self.textures getTexture:TextureIDPinkMonkeyTarget]]
     state:NULL audioDelegate:self.audioDelegate clickEventBlock:pinkBalloonClick];
    pinkBalloon.position = CGPointMake(-450, -300);
    [self addNodeToLayer:LayerIDHUD node:pinkBalloon];
    
    SSKButtonNode *blueBalloon =
    [[SSKButtonNode alloc]
     initWithTexture:[SKTexture textureWithRect:CGRectMake(0, 0, 1.0/8.0, 1.0/3.0)
                                      inTexture:[self.textures getTexture:TextureIDBlueMonkeyTarget]]
     state:NULL audioDelegate:self.audioDelegate clickEventBlock:blueBalloonClick];
    blueBalloon.position = CGPointMake(-300, -300);
    [self addNodeToLayer:LayerIDHUD node:blueBalloon];
    
    SSKButtonNode *goldBalloon =
    [[SSKButtonNode alloc]
     initWithTexture:[SKTexture textureWithRect:CGRectMake(0, 0, 1.0/8.0, 1.0/3.0)
                                      inTexture:[self.textures getTexture:TextureIDGoldMonkeyTarget]]
     state:NULL audioDelegate:self.audioDelegate clickEventBlock:goldBalloonClick];
    goldBalloon.position = CGPointMake(-150, -300);
    [self addNodeToLayer:LayerIDHUD node:goldBalloon];

    SSKButtonNode *playerOne =
    [[SSKButtonNode alloc]
     initWithTexture:[SKTexture textureWithRect:CGRectMake(0, 0, 1.0/7.0, 1.0/3.0)
                                      inTexture:[self.textures getTexture:TextureIDPlayerOneIdle]]
     state:NULL audioDelegate:self.audioDelegate clickEventBlock:throwClick];
    playerOne.position = CGPointMake(-400, 0);
    [self addNodeToLayer:LayerIDHUD node:playerOne];
    
    SSKButtonNode *playerTwo =
    [[SSKButtonNode alloc]
     initWithTexture:[SKTexture textureWithRect:CGRectMake(0, 0, 1.0/7.0, 1.0/2.0)
                                      inTexture:[self.textures getTexture:TextureIDPlayerTwoAttack]]
     state:NULL audioDelegate:self.audioDelegate clickEventBlock:reloadClick];
    playerTwo.position = CGPointMake(400, 0);
    [self addNodeToLayer:LayerIDHUD node:playerTwo];
    
    SSKButtonNode *one =
    [[SSKButtonNode alloc]
     initWithTexture:[SKTexture textureWithRect:CGRectMake(0, 0, 0.5, 0.5)
                                      inTexture:[self.textures getTexture:TextureIDCountdown]]
     state:NULL audioDelegate:self.audioDelegate clickEventBlock:oneTimerClick];
    one.position = CGPointMake(-450, 300);
    [self addNodeToLayer:LayerIDHUD node:one];
    
    SSKButtonNode *two =
    [[SSKButtonNode alloc]
     initWithTexture:[SKTexture textureWithRect:CGRectMake(0.5, 0.5, 0.5, 0.5)
                                      inTexture:[self.textures getTexture:TextureIDCountdown]]
     state:NULL audioDelegate:self.audioDelegate clickEventBlock:twoTimerClick];
    two.position = CGPointMake(-350, 300);
    [self addNodeToLayer:LayerIDHUD node:two];
    
    SSKButtonNode *three =
    [[SSKButtonNode alloc]
     initWithTexture:[SKTexture textureWithRect:CGRectMake(0, 0.5, 0.5, 0.5)
                                      inTexture:[self.textures getTexture:TextureIDCountdown]]
     state:NULL audioDelegate:self.audioDelegate clickEventBlock:threeTimerClick];
    three.position = CGPointMake(-250, 300);
    [self addNodeToLayer:LayerIDHUD node:three];
    
    SSKButtonNode *go =
    [[SSKButtonNode alloc]
     initWithTexture:[SKTexture textureWithRect:CGRectMake(0.5, 0, 0.5, 0.5)
                                      inTexture:[self.textures getTexture:TextureIDCountdown]]
     state:NULL audioDelegate:self.audioDelegate clickEventBlock:goClick];
    go.position = CGPointMake(150, 300);
    [self addNodeToLayer:LayerIDHUD node:go];
    
    [self.musicManager playSound:SoundIDInGameMusic loopCount:-1 instanceId:1];
}

#pragma mark - Properties

@synthesize actionQueue;

@end
