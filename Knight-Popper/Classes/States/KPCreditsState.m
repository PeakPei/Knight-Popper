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
           audioDelegate:(id<SSKAudioManagerDelegate>)delegate {
    unsigned int const LAYER_COUNT = 4;
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
         state:NULL];
    background.position = CGPointZero;
    [self addNodeToLayer:LayerIDBackground node:background];
    
    // Initialise credits info layer
    SSKSpriteNode* creditsInfo =
        [[SSKSpriteNode alloc]
         initWithTexture:[self.textures getTexture:TextureIDCredits]
         state:NULL];
    creditsInfo.position = CGPointZero;
    [self addNodeToLayer:LayerIDCreditsInfo node:creditsInfo];
    
    // Initialise HUD layer
    CGFloat const BACK_REL_X = -0.390625;
    CGFloat const BACK_REL_Y = -0.390625;
    
    SSKButtonNode* backButton =
        [[SSKButtonNode alloc]
         initWithTexture:[self.textures getTexture:TextureIDBackButton]
         state:self clickEventBlock:^(SSKButtonNode* node) {
             [node.audioDelegate playSound:SoundIDBackPress];
             [node.state requestStackPop];
         }];
    backButton.audioDelegate = self.audioDelegate;
    backButton.position = CGPointMake(self.scene.frame.size.width * BACK_REL_X,
                                      self.scene.frame.size.height * BACK_REL_Y);
    [self addNodeToLayer:LayerIDHUD node:backButton];
}

#pragma mark - Properties

@synthesize actionQueue;

@end
