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
#import "KPStateStack.h"
#import "StateIDs.h"
#import "Coordinates.h"

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
           audioDelegate:(id<SSKAudioManagerDelegate>)delegate
                    data:(NSDictionary *)data {
    unsigned int const LAYER_COUNT = 3;
    if (self = [super initWithStateStack:stateStack
                          textureManager:textureManager
                           audioDelegate:delegate
                                    data:data
                              layerCount:LAYER_COUNT]) {
        // stub
    }
    return self;
}

- (void)buildState {
    // Initialise background layer
    UIColor* backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0/3.0];
    SSKSpriteNode* background =
        [[SSKSpriteNode alloc]
         initWithColor:backgroundColor size:self.scene.frame.size];
    background.position = CGPointZero;
    [self addNodeToLayer:LayerIDBackground node:background];
    
    // Initialise pause background layer
    SSKSpriteNode* pauseBackground =
        [[SSKSpriteNode alloc]
         initWithTexture:[self.textures getTexture:TextureIDPauseBackground]];
    pauseBackground.position = CGPointZero;
    [self addNodeToLayer:LayerIDPauseBackground node:pauseBackground];
    
    // Initialise HUD layer
    CGFloat const RESUME_REL_X = 0.0;
    CGFloat const RESUME_REL_Y = 0.009;
    
    SSKButtonNode* resumeButton =
        [[SSKButtonNode alloc]
         initWithDefaultTexture:[self.textures getTexture:TextureIDResumeButton]
         pressedTexture:[self.textures getTexture:TextureIDResumeButtonHover]
         beginPressBlock:NULL
         endPressBlock:^(SSKButtonNode* node) {
             [node.audioDelegate playSound:SoundIDBackPress];
             [node.state requestStackPop];
         }];
    resumeButton.audioDelegate = self.audioDelegate;
    resumeButton.position = CGPointMake(
        [Coordinates convertXFromiPhone:IPHONE_LANDSCAPE_WIDTH_PTS * RESUME_REL_X
                    scalesForWidescreen:NO],
        [Coordinates convertYFromiPhone:IPHONE_LANDSCAPE_HEIGHT_PTS * RESUME_REL_Y]);
    [self addNodeToLayer:LayerIDHUD node:resumeButton];

    CGFloat const MENU_REL_X = 0.005625;
    CGFloat const MENU_REL_Y = -0.2;
    
    SSKButtonNode* menuButton =
        [[SSKButtonNode alloc]
         initWithDefaultTexture:[self.textures getTexture:TextureIDMenuButton]
         pressedTexture:[self.textures getTexture:TextureIDMenuButtonHover]
         beginPressBlock:NULL
         endPressBlock:^(SSKButtonNode* node) {
             [(KPStateStack*)self.scene spriteView].paused = NO;
             [node.audioDelegate playSound:SoundIDBackPress];
             [node.state requestStackClear];
             [node.state requestStackPush:StateIDMenu data:NULL];
             
             // N.B. Ensure the physics simulations are returned to normal.
             self.scene.physicsWorld.speed = 1.0f;
         }];
    menuButton.audioDelegate = self.audioDelegate;
    menuButton.position = CGPointMake(
        [Coordinates convertXFromiPhone:IPHONE_LANDSCAPE_WIDTH_PTS * MENU_REL_X
                    scalesForWidescreen:NO],
        [Coordinates convertYFromiPhone:IPHONE_LANDSCAPE_HEIGHT_PTS * MENU_REL_Y]);
    [self addNodeToLayer:LayerIDHUD node:menuButton];
}

#pragma mark SSKEventProtocol

- (BOOL)handleBeginEvent:(UIEvent*)event touch:(UITouch*)touch {
    [super handleBeginEvent:event touch:touch];
    
    // N.B. The pause screen "handles" all events to prevent other states
    // from handling them.
    return YES;
}

- (BOOL)handleEndEvent:(UIEvent*)event touch:(UITouch*)touch {
    [super handleEndEvent:event touch:touch];
    
    // N.B. The pause screen "handles" all events to prevent other states
    // from handling them.
    return YES;
}

@end
