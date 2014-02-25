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
#import "Coordinates.h"

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
           audioDelegate:(id<SSKAudioManagerDelegate>)delegate
                    data:(NSDictionary *)data{
    unsigned int layerCount = 3;
    if (self = [super initWithStateStack:stateStack
                          textureManager:textureManager
                           audioDelegate:delegate
                                    data:data
                              layerCount:layerCount]) {
        self.actionQueue = [[SSKActionQueue alloc] init];
    }
    return self;
}

#pragma mark SSKState

- (void)updateState:(CFTimeInterval)deltaTime {
    if (self.isActive) {
        while (![self.actionQueue isEmpty]) {
            [self onAction:[self.actionQueue pop] deltaTime:deltaTime];
        }
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
    CGFloat const TITLE_REL_X = 0;
    CGFloat const TITLE_REL_Y = 0.1302083333;
    
    SSKSpriteNode* title =
        [[SSKSpriteNode alloc]
         initWithTexture:[self.textures getTexture:TextureIDMainMenuTitle]];
    title.position = CGPointMake(
        [Coordinates convertXFromiPhone:IPHONE_LANDSCAPE_WIDTH_PTS * TITLE_REL_X
                    scalesForWidescreen:YES],
        [Coordinates convertYFromiPhone:IPHONE_LANDSCAPE_HEIGHT_PTS * TITLE_REL_Y]);
    [self addNodeToLayer:LayerIDBackground node:title];
    
    CGFloat const PLAY_REL_X = 0;
    CGFloat const PLAY_REL_Y = -0.3255208333;
    
    SSKButtonNode* playButton =
        [[SSKButtonNode alloc]
         initWithDefaultTexture:[self.textures getTexture:TextureIDPlayButton]
         pressedTexture:[self.textures getTexture:TextureIDPlayButtonHover]
         beginPressBlock:NULL
         endPressBlock:^(SSKButtonNode* node) {
             [node.audioDelegate playSound:SoundIDForwardPress];
             [node.state requestStackClear];
             [node.state requestStackPush:StateIDLoading data:NULL];
         }];
    playButton.audioDelegate = self.audioDelegate;
    playButton.position = CGPointMake(
        [Coordinates convertXFromiPhone:IPHONE_LANDSCAPE_WIDTH_PTS * PLAY_REL_X
                    scalesForWidescreen:YES],
        [Coordinates convertYFromiPhone:IPHONE_LANDSCAPE_HEIGHT_PTS * PLAY_REL_Y]);
    [self addNodeToLayer:LayerIDBackground node:playButton];
    
    CGFloat const ABOUT_REL_X = -0.406494;
    CGFloat const ABOUT_REL_Y = -0.3515625;
    
    SSKButtonNode* aboutButton =
        [[SSKButtonNode alloc]
         initWithDefaultTexture:[self.textures getTexture:TextureIDAboutButton]
         pressedTexture:[self.textures getTexture:TextureIDAboutButtonHover]
         beginPressBlock:NULL
         endPressBlock:^(SSKButtonNode* node) {
             self.isActive = NO;
             [node.audioDelegate playSound:SoundIDForwardPress];
             [node.state requestStackPush:StateIDCredits data:NULL];
         }];
    aboutButton.audioDelegate = self.audioDelegate;
    aboutButton.position = CGPointMake(
        [Coordinates convertXFromiPhone:IPHONE_LANDSCAPE_WIDTH_PTS * ABOUT_REL_X
                    scalesForWidescreen:YES],
        [Coordinates convertYFromiPhone:IPHONE_LANDSCAPE_HEIGHT_PTS * ABOUT_REL_Y]);
    [self addNodeToLayer:LayerIDBackground node:aboutButton];
    
    [self.audioDelegate playSound:SoundIDMenuMusic
                        loopCount:-1
                       instanceId:SoundInstanceIDMenuMusic];
}

#pragma mark - Properties

@synthesize actionQueue;

@end
