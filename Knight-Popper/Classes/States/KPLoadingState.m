/**
 * @filename KPLoadingState.m
 * @author Morgan Wall
 * @date 16-10-2013
 */

#import "KPLoadingState.h"
#import "KPActionCategories.h"
#import "TextureIDs.h"
#import "StateIDs.h"
#import "SoundIDs.h"
#import "SoundInstanceIDs.h"
#import <SpriteStackKit/SSKAction.h>
#import <SpriteStackKit/SSKActionQueue.h>
#import <SpriteStackKit/SSKSpriteAnimationNode.h>
#import <SpriteStackKit/SSKButtonNode.h>
#import <SpriteStackKit/SSKSpriteNode.h>
#import <SpriteStackKit/SSKLabelNode.h>

#define START_TIME_DEFAULT -1
#define LOADING_TIME_IN_SECS 2

#pragma mark - Interface

@interface KPLoadingState ()

typedef enum layers {
    LayerIDBackground = 0,
    LayerIDProjectiles,
    LayerIDHUD
} LayerID;

@property SSKActionQueue* actionQueue;

@property double startTime;

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
        self.startTime = START_TIME_DEFAULT;
    }
    return self;
}

#pragma mark SSKState

- (void)update:(CFTimeInterval)deltaTime {
    if (self.startTime == START_TIME_DEFAULT) {
        self.startTime = deltaTime;
    } else if (deltaTime - self.startTime >= LOADING_TIME_IN_SECS) {
        [self.audioDelegate stopSound:SoundInstanceIDMenuMusic];
        [self.audioDelegate playSound:SoundIDInGameMusic
                            loopCount:-1
                           instanceId:SoundInstanceIDMenuMusic];
        [self requestStackClear];
        [self requestStackPush:StateIDStandardGame];
    }
    
    while (![self.actionQueue isEmpty]) {
        [self onAction:[self.actionQueue pop] deltaTime:deltaTime];
    }
}

- (void)buildState {
    // Initialise background layer
    SSKSpriteNode* background =
        [[SSKSpriteNode alloc]
         initWithTexture:[self.textures getTexture:TextureIDMainMenuBackground]];
    background.position = CGPointZero;
    [self addNodeToLayer:LayerIDBackground node:background];
    
    // Initialise HUD layer
    CGFloat const LOLLIPOP_REL_X = 0;
    CGFloat const LOLLIPOP_REL_Y = 0.09765625;
    
    SSKSpriteNode* lollipopBase =
        [[SSKSpriteNode alloc]
         initWithTexture:[self.textures getTexture:TextureIDLollipopBase]];
    lollipopBase.position =
        CGPointMake(self.scene.frame.size.width * LOLLIPOP_REL_X,
                    self.scene.frame.size.height * LOLLIPOP_REL_Y);
    [self addNodeToLayer:LayerIDBackground node:lollipopBase];
    
    SSKSpriteNode* lollipopShadow =
        [[SSKSpriteNode alloc]
         initWithTexture:[self.textures getTexture:TextureIDLollipopShadow]];
    lollipopShadow.position = lollipopBase.position;
    [self addNodeToLayer:LayerIDHUD node:lollipopShadow];
    
    CGFloat const MESSAGE_REL_X = 0;
    CGFloat const MESSAGE_REL_Y = -0.3255208333;
    
    SSKLabelNode* message =
        [[SSKLabelNode alloc] initWithFontNamed:@"Arial"];
    message.text = @"Loading...";
    message.fontSize = 40;
    message.position =
        CGPointMake(self.scene.frame.size.width * MESSAGE_REL_X,
                    self.scene.frame.size.height * MESSAGE_REL_Y);
    [self addNodeToLayer:LayerIDHUD node:message];
    
    SKAction* rotate =
        [SKAction repeatActionForever:[SKAction rotateByAngle:6.2831 duration:1]];
    [lollipopBase runAction:rotate];
}

#pragma mark - Properties

@synthesize actionQueue;
@synthesize startTime;

@end
