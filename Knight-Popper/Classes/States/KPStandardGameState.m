/**
 * @filename KPStandardGameState.m
 * @author Morgan Wall
 * @date 5-10-2013
 */

#import "KPStandardGameState.h"
#import "KPTargetNode.h"
#import "KPActionCategories.h"
#import "TextureIDs.h"
#import "KPSpriteNode.h"
#import <SpriteStackKit/SSKAction.h>
#import <SpriteStackKit/SSKActionQueue.h>
#import <SpriteStackKit/SSKSpriteAnimationNode.h>

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
            soundManager:(SSKSoundManager *)sounds {
    unsigned int layerCount = 6;
    if (self = [super initWithStateStack:stateStack
                          textureManager:textureManager soundManager:sounds
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
    KPSpriteNode* background = [[KPSpriteNode alloc] initWithTexture:
                                 [self.textures getTexture:TextureIDBackground]];
    background.position = CGPointZero;
    [self addNodeToLayer:LayerIDBackground node:background];
    
    // Initialise HUD layer
    KPSpriteNode* pinkMonkeyHUD = [[KPSpriteNode alloc] initWithTexture:
                                   [self.textures getTexture:TextureIDPinkMonkeyHUD]];
    pinkMonkeyHUD.position = CGPointMake(300, 300);
    [self addNodeToLayer:LayerIDHUD node:pinkMonkeyHUD];
    
    KPSpriteNode* blueMonkeyHUD = [[KPSpriteNode alloc] initWithTexture:
                                   [self.textures getTexture:TextureIDBlueMonkeyHUD]];
    blueMonkeyHUD.position = CGPointMake(-300, 300);
    [self addNodeToLayer:LayerIDHUD node:blueMonkeyHUD];

    SSKSpriteAnimationNode* timer =
    [[SSKSpriteAnimationNode alloc]
     initWithSpriteSheet:[self.textures getTexture:TextureIDTimer]
     columns:5 rows:6 numFrames:30 horizontalOrder:YES timePerFrame:1];
    timer.position = CGPointMake(0, 300);
    [timer animate];
    [self addNodeToLayer:LayerIDHUD node:timer];
    
//    SSKSpriteAnimationNode* countdown =
//    [[SSKSpriteAnimationNode alloc]
//     initWithSpriteSheet:[self.textures getTexture:TextureIDCountdown]
//     columns:2 rows:2 numFrames:4 horizontalOrder:YES timePerFrame:1];
//    countdown.position = CGPointMake(0, 300);
//    [countdown animate];
//    [self addNodeToLayer:LayerIDHUD node:countdown];
    
    // Initialise Players layer
//    SSKSpriteAnimationNode* leftPlayer =
//    [[SSKSpriteAnimationNode alloc]
//     initWithSpriteSheet:[self.textures getTexture:TextureIDPlayerOneIdle]
//     columns:7 rows:3 numFrames:20 horizontalOrder:YES timePerFrame:1.0/14.0];
//    leftPlayer.position = CGPointMake(-350, -175);
//    [leftPlayer animate];
//    [self addNodeToLayer:LayerIDPlayers node:leftPlayer];

    SSKSpriteAnimationNode* leftPlayerThrowTest =
    [[SSKSpriteAnimationNode alloc]
     initWithSpriteSheet:[self.textures getTexture:TextureIDPlayerOneAttack]
     columns:7 rows:2 numFrames:12 horizontalOrder:YES timePerFrame:1.0/14.0];
    leftPlayerThrowTest.position = CGPointMake(-350, -175);
    [leftPlayerThrowTest animate];
    [self addNodeToLayer:LayerIDPlayers node:leftPlayerThrowTest];
    
    SSKSpriteAnimationNode* rightPlayer =
    [[SSKSpriteAnimationNode alloc]
     initWithSpriteSheet:[self.textures getTexture:TextureIDPlayerTwoIdle]
     columns:7 rows:3 numFrames:20 horizontalOrder:YES timePerFrame:1.0/14.0];
    rightPlayer.position = CGPointMake(350, -175);
    [rightPlayer animate];
    [self addNodeToLayer:LayerIDPlayers node:rightPlayer];
    
    // Initialise Scenery layer
    KPSpriteNode* leftGrassTuft = [[KPSpriteNode alloc] initWithTexture:
                                    [self.textures getTexture:TextureIDGrassTuftLeft]];
    leftGrassTuft.position = CGPointMake(-340, -328);
    [self addNodeToLayer:LayerIDScenery node:leftGrassTuft];
    
    KPSpriteNode* rightGrassTuft = [[KPSpriteNode alloc] initWithTexture:
                                     [self.textures getTexture:TextureIDGrassTuftRight]];
    rightGrassTuft.position = CGPointMake(340, -328);
    [self addNodeToLayer:LayerIDScenery node:rightGrassTuft];
    
    // Initialise Targets layer
    SSKSpriteAnimationNode* blueTestTarget =
    [[SSKSpriteAnimationNode alloc]
     initWithSpriteSheet:[self.textures getTexture:TextureIDBlueMonkeyTarget]
     columns:8 rows:3 numFrames:20 horizontalOrder:YES timePerFrame:1.0/14.0];
    blueTestTarget.position = CGPointMake(50, 80);
    [blueTestTarget animate];
    [self addNodeToLayer:LayerIDTargets node:blueTestTarget];
    
    SSKSpriteAnimationNode* pinkTestTarget =
    [[SSKSpriteAnimationNode alloc]
     initWithSpriteSheet:[self.textures getTexture:TextureIDPinkMonkeyTarget]
     columns:8 rows:3 numFrames:20 horizontalOrder:YES timePerFrame:1.0/14.0];
    pinkTestTarget.position = CGPointMake(-50, -120);
    [pinkTestTarget animate];
    [self addNodeToLayer:LayerIDTargets node:pinkTestTarget];
    
    // Initialise Projectiles layer
    SSKSpriteAnimationNode* projectileTest =
    [[SSKSpriteAnimationNode alloc]
     initWithSpriteSheet:[self.textures getTexture:TextureIDLollipopLeftProjectile]
     columns:3 rows:3 numFrames:8 horizontalOrder:YES timePerFrame:1.0/14.0];
    projectileTest.position = CGPointMake(300, 150);
    [projectileTest animate];
    [self addNodeToLayer:LayerIDProjectiles node:projectileTest];
}

#pragma mark - Properties

@synthesize actionQueue;

@end
