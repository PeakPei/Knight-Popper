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
#import "StateIDs.h"
#import "SoundInstanceIDs.h"
#import <SpriteStackKit/SSKSpriteNode.h>
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

#pragma mark SSKState

- (void)update:(CFTimeInterval)deltaTime {
    while (![self.actionQueue isEmpty]) {
        [self onAction:[self.actionQueue pop] deltaTime:deltaTime];
    }
}

- (void)buildState {
    // Initialise background layer
    SSKSpriteNode* background =
    [[SSKSpriteNode alloc] initWithTexture:[self.textures getTexture:TextureIDBackground]
                                    state:NULL
                             audioDelegate:self.audioDelegate];
    background.position = CGPointZero;
    [self addNodeToLayer:LayerIDBackground node:background];
    
    // Initialise HUD layer
    CGFloat const PINK_MONKEY_HUD_REL_X = 0.4040625;
    CGFloat const PINK_MONKEY_HUD_REL_Y = 0.390625;
    
    SSKSpriteNode* pinkMonkeyHUD = [[SSKSpriteNode alloc] initWithTexture:
                                   [self.textures getTexture:TextureIDPinkMonkeyHUD]];
    pinkMonkeyHUD.position =
        CGPointMake(self.scene.frame.size.width * PINK_MONKEY_HUD_REL_X,
                    self.scene.frame.size.height * PINK_MONKEY_HUD_REL_Y);
    [self addNodeToLayer:LayerIDHUD node:pinkMonkeyHUD];
    
    CGFloat const BLUE_MONKEY_HUD_REL_X = -0.4040625;
    CGFloat const BLUE_MONKEY_HUD_REL_Y = 0.390625;
    
    SSKSpriteNode* blueMonkeyHUD = [[SSKSpriteNode alloc] initWithTexture:
                                   [self.textures getTexture:TextureIDBlueMonkeyHUD]];
    blueMonkeyHUD.position =
        CGPointMake(self.scene.frame.size.width * BLUE_MONKEY_HUD_REL_X,
                    self.scene.frame.size.height * BLUE_MONKEY_HUD_REL_Y);
    [self addNodeToLayer:LayerIDHUD node:blueMonkeyHUD];
    
    // Initialise players layer
    CGFloat const LEFT_PLAYER_REL_X = -0.341796875;
    CGFloat const LEFT_PLAYER_REL_Y = -0.2278645833;
    
    SSKSpriteAnimationNode* leftPlayer =
        [[SSKSpriteAnimationNode alloc]
         initWithSpriteSheet:[self.textures getTexture:TextureIDPlayerOneIdle]
         state:NULL audioDelegate:self.audioDelegate
         columns:7 rows:3 numFrames:20 horizontalOrder:YES timePerFrame:1.0/14.0];
    leftPlayer.position =
        CGPointMake(self.scene.frame.size.width * LEFT_PLAYER_REL_X,
                    self.scene.frame.size.height * LEFT_PLAYER_REL_Y);
    [leftPlayer animate];
    [self addNodeToLayer:LayerIDPlayers node:leftPlayer];
    
    CGFloat const RIGHT_PLAYER_REL_X = 0.341796875;
    CGFloat const RIGHT_PLAYER_REL_Y = -0.2278645833;
    
    SSKSpriteAnimationNode* rightPlayer =
        [[SSKSpriteAnimationNode alloc]
         initWithSpriteSheet:[self.textures getTexture:TextureIDPlayerTwoIdle]
         state:NULL audioDelegate:self.audioDelegate
         columns:7 rows:3 numFrames:20 horizontalOrder:YES timePerFrame:1.0/14.0];
    rightPlayer.position =
        CGPointMake(self.scene.frame.size.width * RIGHT_PLAYER_REL_X,
                    self.scene.frame.size.height * RIGHT_PLAYER_REL_Y);
    [rightPlayer animate];
    [self addNodeToLayer:LayerIDPlayers node:rightPlayer];
    
    // Initialise scenery layer
    CGFloat const LEFT_GRASS_REL_X = -0.33203125;
    CGFloat const LEFT_GRASS_REL_Y = -0.4270833333;
    
    SSKSpriteNode* leftGrassTuft = [[SSKSpriteNode alloc] initWithTexture:
                                    [self.textures getTexture:TextureIDGrassTuftLeft]];
    leftGrassTuft.position =
        CGPointMake(self.scene.frame.size.width * LEFT_GRASS_REL_X,
                    self.scene.frame.size.height * LEFT_GRASS_REL_Y);
    [self addNodeToLayer:LayerIDScenery node:leftGrassTuft];
    
    CGFloat const RIGHT_GRASS_REL_X = 0.33203125;
    CGFloat const RIGHT_GRASS_REL_Y = -0.4270833333;
    
    SSKSpriteNode* rightGrassTuft = [[SSKSpriteNode alloc] initWithTexture:
                                     [self.textures getTexture:TextureIDGrassTuftRight]];
    rightGrassTuft.position =
        CGPointMake(self.scene.frame.size.width * RIGHT_GRASS_REL_X,
                    self.scene.frame.size.height * RIGHT_GRASS_REL_Y);
    [self addNodeToLayer:LayerIDScenery node:rightGrassTuft];
}

#pragma mark - Properties

@synthesize actionQueue;

@end
