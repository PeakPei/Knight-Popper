/**
 * @filename KPCreditsState.m
 * @author Morgan Wall
 * @date 6-11-2013
 */

#import "KPCreditsState.h"
#import <SpriteStackKit/SSKActionQueue.h>
#import <SpriteStackKit/SSKSpriteNode.h>
#import <SpriteStackKit/SSKButtonNode.h>
#import "TextureIDs.h"
#import "StateIDs.h"
#import "SoundIDs.h"
#import "Coordinates.h"

#pragma mark - Interface

@interface KPCreditsState()

typedef enum layers {
    LayerIDBackground = 0,
    LayerIDProjectiles,
    LayerIDCreditsInfo,
    LayerIDHUD
} LayerID;

@property SSKActionQueue* actionQueue;

@end

#pragma mark - Implementation

@implementation KPCreditsState

#pragma mark KPState

- (id)initWithStateStack:(SSKStateStack *)stateStack
          textureManager:(SSKTextureManager *)textureManager
           audioDelegate:(id<SSKAudioManagerDelegate>)delegate
                    data:(NSDictionary*)data {
    unsigned int const LAYER_COUNT = 4;
    if (self = [super initWithStateStack:stateStack
                          textureManager:textureManager
                           audioDelegate:delegate
                                    data:data
                              layerCount:LAYER_COUNT]) {
        self.actionQueue = [[SSKActionQueue alloc] init];
    }
    return self;
}

- (BOOL)update:(CFTimeInterval)deltaTime {
    BOOL activeThisFrame = self.isActive;
    
    if (activeThisFrame) {
        while (![self.actionQueue isEmpty]) {
            [self onAction:[self.actionQueue pop] deltaTime:deltaTime];
        }
    }
    
    return activeThisFrame;
}

- (void)buildState {
    // Initialise background layer
    SSKSpriteNode* background =
        [[SSKSpriteNode alloc]
         initWithTexture:[self.textures getTexture:TextureIDMainMenuBackground]];
    background.position = CGPointZero;
    [self addNodeToLayer:LayerIDBackground node:background];
    
    // Initialise credits info layer
    SSKSpriteNode* creditsInfo =
        [[SSKSpriteNode alloc]
         initWithTexture:[self.textures getTexture:TextureIDCredits]];
    creditsInfo.position = CGPointZero;
    [self addNodeToLayer:LayerIDCreditsInfo node:creditsInfo];
    
    // Initialise HUD layer
    
    // initialise using relative positioning coordinates suited for iPads
    // N.B. Additional modifications are due to inconsistencies in the size of the
    // credits information texture between devices.
    CGFloat BACK_REL_X = -0.390625;
    CGFloat const BACK_REL_Y = -0.390625;
    
    // modify relative positioning coordinates for iPhones
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        BACK_REL_X = -0.350625;
    }
    
    SSKButtonNode* backButton =
        [[SSKButtonNode alloc]
         initWithDefaultTexture:[self.textures getTexture:TextureIDBackButton]
         pressedTexture:[self.textures getTexture:TextureIDBackButtonHover]
         beginPressBlock:NULL
         endPressBlock:^(SSKButtonNode* node) {
             [node.audioDelegate playSound:SoundIDBackPress];
             [node.state requestStackPop];
         }];
    backButton.audioDelegate = self.audioDelegate;
    backButton.position = CGPointMake(
        [Coordinates convertXFromiPhone:IPHONE_LANDSCAPE_WIDTH_PTS * BACK_REL_X
                    scalesForWidescreen:NO],
        [Coordinates convertYFromiPhone:IPHONE_LANDSCAPE_HEIGHT_PTS * BACK_REL_Y]);
    [self addNodeToLayer:LayerIDHUD node:backButton];
}

#pragma mark - Properties

@synthesize actionQueue;

@end
