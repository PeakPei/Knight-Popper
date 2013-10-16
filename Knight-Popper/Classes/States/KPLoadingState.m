/**
 * @filename KPState.m
 * @author Morgan Wall
 * @date 16-10-2013
 */

#import "KPLoadingState.h"
#import "KPActionCategories.h"
#import "TextureIDs.h"
#import "StateIDs.h"
#import "SoundIDs.h"
#import <SpriteStackKit/SSKAction.h>
#import <SpriteStackKit/SSKActionQueue.h>
#import <SpriteStackKit/SSKSpriteAnimationNode.h>
#import <SpriteStackKit/SSKButtonNode.h>
#import "KPSpriteNode.h"
#import <SpriteStackKit/SSKLabelNode.h>

#pragma mark - Interface

@interface KPLoadingState ()

typedef enum layers {
    LayerIDBackground = 0,
    LayerIDProjectiles,
    LayerIDHUD
} LayerID;

@property SSKActionQueue* actionQueue;

@end

#pragma mark - Implementation

@implementation KPLoadingState

- (id)initWithStateStack:(SSKStateStack *)stateStack
          textureManager:(SSKTextureManager *)textureManager
           audioDelegate:(id<SSKAudioManagerDelegate>)delegate {
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
        [self onAction:[self.actionQueue pop]];
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
    KPSpriteNode* lollipopBase =
    [[KPSpriteNode alloc]
     initWithTexture:[self.textures getTexture:TextureIDLollipopBase]
     state:NULL audioDelegate:self.audioDelegate];
    lollipopBase.position = CGPointMake(0, 75);
    [self addNodeToLayer:LayerIDBackground node:lollipopBase];
    
    KPSpriteNode* lollipopShadow =
    [[KPSpriteNode alloc]
     initWithTexture:[self.textures getTexture:TextureIDLollipopShadow]
     state:NULL audioDelegate:self.audioDelegate];
    lollipopShadow.position = lollipopBase.position;
    [self addNodeToLayer:LayerIDHUD node:lollipopShadow];
    
    SSKLabelNode* message =
        [[SSKLabelNode alloc] initWithFontNamed:@"Arial"
                                  audioDelegate:self.audioDelegate];
    message.text = @"Collecting springs...";
    message.fontSize = 40;
    message.position = CGPointMake(0, -250);
    [self addNodeToLayer:LayerIDHUD node:message];
    
    SKAction* rotate =
        [SKAction repeatActionForever:[SKAction rotateByAngle:6.2831 duration:1]];
    [lollipopBase runAction:rotate];
}

#pragma mark - Properties

@synthesize actionQueue;

@end
