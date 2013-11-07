/**
 * @filename KPPauseState.m
 * @author Morgan Wall
 * @date 7-11-2013
 */

#import "KPPauseState.h"
#import <SpriteStackKit/SSKSpriteNode.h>
#import <SpriteStackKit/SSKButtonNode.h>
#import "TextureIDs.h"
#import "SoundIDs.h"

#pragma mark - Interface

@interface KPPauseState()

typedef enum layers {
    LayerIDBackground = 0,
    LayerIDPauseBackground,
    LayerIDHUD
} LayerID;

@end

#pragma mark - Implementation

@implementation KPPauseState

- (id)initWithStateStack:(SSKStateStack *)stateStack
          textureManager:(SSKTextureManager *)textureManager
           audioDelegate:(id<SSKAudioManagerDelegate>)delegate {
    unsigned int const LAYER_COUNT = 3;
    if (self = [super initWithStateStack:stateStack
                          textureManager:textureManager
                           audioDelegate:delegate
                              layerCount:LAYER_COUNT]) {
        // stub
    }
    return self;
}

- (void)update:(CFTimeInterval)deltaTime {
    // stub
}

- (void)buildState {
    // Initialise background layer
    UIColor* backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0/3.0];
    SSKSpriteNode* background =
        [[SSKSpriteNode alloc]
         initWithColor:backgroundColor size:self.scene.frame.size state:self];
    background.position = CGPointZero;
    [self addNodeToLayer:LayerIDBackground node:background];
    
    // Initialise pause background layer
    SSKSpriteNode* pauseBackground =
        [[SSKSpriteNode alloc]
         initWithTexture:[self.textures getTexture:TextureIDPauseBackground]
         state:self];
    pauseBackground.position = CGPointZero;
    [self addNodeToLayer:LayerIDPauseBackground node:pauseBackground];
    
    // Initialise HUD layer
    CGFloat const RESUME_REL_X = -0.212421875;
    CGFloat const RESUME_REL_Y = -0.2899479167;
    
    SSKButtonNode* resumeButton =
        [[SSKButtonNode alloc]
         initWithTexture:[self.textures getTexture:TextureIDResumeButton]
         state:self clickEventBlock:^(SSKButtonNode* node) {
             [node.audioDelegate playSound:SoundIDBackPress];
             [node.state requestStackPop];
     }];
    resumeButton.audioDelegate = self.audioDelegate;
    resumeButton.position =
        CGPointMake(self.scene.frame.size.width * RESUME_REL_X,
                    self.scene.frame.size.height * RESUME_REL_Y);
    [self addNodeToLayer:LayerIDHUD node:resumeButton];
}

@end
