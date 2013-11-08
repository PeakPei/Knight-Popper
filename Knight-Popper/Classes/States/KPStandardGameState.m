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
#import <SpriteStackKit/SSKResourcePool.h>
#import <SpriteStackKit/SSKResourcePoolManager.h>

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

- (void)addRemoveTargetActionToQueue;

@property SSKActionQueue* actionQueue;

@property SSKResourcePoolManager* poolManager;

@property CFTimeInterval initialTime;

@property CFTimeInterval timeLastGeneration;

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
        self.poolManager = [[SSKResourcePoolManager alloc] initWithCapacity:5];
        self.initialTime = -1;
        self.timeLastGeneration = 0;
    }
    return self;
}

#pragma mark SSKState

- (void)update:(CFTimeInterval)deltaTime {
    NSLog(@"%d", [self.poolManager poolResourceCount:1]);
    
    if (self.initialTime == -1) {
        self.initialTime = deltaTime;
        [self.poolManager retrieveFromPool:1];
        NSLog(@"CREATE CREATE CREATE CREATE CREATE CREATE CREATE CREATE");
        NSLog(@"CREATE CREATE CREATE CREATE CREATE CREATE CREATE CREATE");
        NSLog(@"CREATE CREATE CREATE CREATE CREATE CREATE CREATE CREATE");
    }
    
    if (self.timeLastGeneration >= 60) {
        if ([self.poolManager retrieveFromPool:1]) {
            self.timeLastGeneration = 0;
            NSLog(@"CREATE CREATE CREATE CREATE CREATE CREATE CREATE CREATE");
            NSLog(@"CREATE CREATE CREATE CREATE CREATE CREATE CREATE CREATE");
            NSLog(@"CREATE CREATE CREATE CREATE CREATE CREATE CREATE CREATE");
        } else {
            NSLog(@"WAIT WAIT WAIT WAIT WAIT WAIT WAIT WAIT");
            NSLog(@"WAIT WAIT WAIT WAIT WAIT WAIT WAIT WAIT");
            NSLog(@"WAIT WAIT WAIT WAIT WAIT WAIT WAIT WAIT");
        }
    } else {
        self.timeLastGeneration++;
    }
    
    [self addRemoveTargetActionToQueue];
    
    while (![self.actionQueue isEmpty]) {
        [self onAction:[self.actionQueue pop] deltaTime:deltaTime];
    }
}

- (void)buildState {
    // Initialise resource pools
    void (^pinkTargetAdd)(id) = ^(id node) {
        SSKSpriteAnimationNode* resource = (SSKSpriteAnimationNode*)node;
        [resource removeAllActions];
        resource.position = CGPointMake(0.0, -0.7 * self.scene.frame.size.height);
        [resource removeFromParent];
        [resource stopAnimating];
    };
    
    void (^pinkTargetGet)(id) = ^(id node) {
        SSKSpriteAnimationNode* resource = (SSKSpriteAnimationNode*)node;
        resource.position = CGPointMake(0.0, -0.7 * self.scene.frame.size.height);
        [resource runAction:
         [SKAction moveTo:CGPointMake(resource.position.x, -resource.position.y) duration:5]];
        [self addNodeToLayer:LayerIDTargets node:resource];
        [resource animate];
    };
    
    [self.poolManager addResourcePool:2
                         resourceType:[SSKSpriteAnimationNode class]
                            addAction:pinkTargetAdd
                            getAction:pinkTargetGet
                       poolIdentifier:1];
    
    for (int i = 0; i < 2; i++) {
        SSKSpriteAnimationNode* node =
        [[SSKSpriteAnimationNode alloc]
         initWithSpriteSheet:[self.textures getTexture:TextureIDPinkMonkeyTarget]
         columns:8 rows:3 numFrames:20 horizontalOrder:YES timePerFrame:1.0/14.0];
        [self.poolManager addToPool:1 resource:node];
    }
    
    // Initialise background layer
    SSKSpriteNode* background =
        [[SSKSpriteNode alloc]
         initWithTexture:[self.textures getTexture:TextureIDBackground]];
    background.position = CGPointZero;
    [self addNodeToLayer:LayerIDBackground node:background];
    
    // Initialise HUD layer
    CGFloat const PINK_MONKEY_HUD_REL_X = 0.4040625;
    CGFloat const PINK_MONKEY_HUD_REL_Y = 0.390625;
    
    SSKSpriteNode* pinkMonkeyHUD =
        [[SSKSpriteNode alloc]
         initWithTexture:[self.textures getTexture:TextureIDPinkMonkeyHUD]];
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
         columns:7 rows:3 numFrames:20 horizontalOrder:YES timePerFrame:1.0/14.0];
    leftPlayer.audioDelegate = self.audioDelegate;
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
         columns:7 rows:3 numFrames:20 horizontalOrder:YES timePerFrame:1.0/14.0];
    rightPlayer.audioDelegate = self.audioDelegate;
    rightPlayer.position =
        CGPointMake(self.scene.frame.size.width * RIGHT_PLAYER_REL_X,
                    self.scene.frame.size.height * RIGHT_PLAYER_REL_Y);
    [rightPlayer animate];
    [self addNodeToLayer:LayerIDPlayers node:rightPlayer];
    
    // Initialise scenery layer
    CGFloat const LEFT_GRASS_REL_X = -0.33203125;
    CGFloat const LEFT_GRASS_REL_Y = -0.4270833333;
    
    SSKSpriteNode* leftGrassTuft =
        [[SSKSpriteNode alloc]
         initWithTexture:[self.textures getTexture:TextureIDGrassTuftLeft]];
    leftGrassTuft.position =
        CGPointMake(self.scene.frame.size.width * LEFT_GRASS_REL_X,
                    self.scene.frame.size.height * LEFT_GRASS_REL_Y);
    [self addNodeToLayer:LayerIDScenery node:leftGrassTuft];
    
    CGFloat const RIGHT_GRASS_REL_X = 0.33203125;
    CGFloat const RIGHT_GRASS_REL_Y = -0.4270833333;
    
    SSKSpriteNode* rightGrassTuft =
        [[SSKSpriteNode alloc]
         initWithTexture:[self.textures getTexture:TextureIDGrassTuftRight]];
    rightGrassTuft.position =
        CGPointMake(self.scene.frame.size.width * RIGHT_GRASS_REL_X,
                    self.scene.frame.size.height * RIGHT_GRASS_REL_Y);
    [self addNodeToLayer:LayerIDScenery node:rightGrassTuft];
}

#pragma mark Helper Methods

- (void)addRemoveTargetActionToQueue {
    void (^checkOffScreen)(SKNode*, CFTimeInterval) =
    ^(SKNode* node, CFTimeInterval elapsedTime) {
        CGFloat maxX = self.scene.frame.size.width/2.0 + node.frame.size.width/2.0;
        CGFloat minX = -maxX;
        CGFloat maxY = self.scene.frame.size.height/2.0 + node.frame.size.height/2.0;
//        CGFloat minY = -maxY;
        if (node.position.x > maxX || node.position.x < minX ||
            node.position.y > maxY) {
            [self.poolManager addToPool:1 resource:node];
            NSLog(@"DELETE DELETE DELETE DELETE DELETE DELETE DELETE DELETE");
            NSLog(@"DELETE DELETE DELETE DELETE DELETE DELETE DELETE DELETE");
            NSLog(@"DELETE DELETE DELETE DELETE DELETE DELETE DELETE DELETE");
        }
    };
    
    SSKAction *action = [[SSKAction alloc] initWithCategory:[SSKAction defaultActionCategory]
                                                     action:checkOffScreen];
    [self.actionQueue push:action];
}

#pragma mark - Properties

@synthesize actionQueue;
@synthesize poolManager;
@synthesize initialTime;
@synthesize timeLastGeneration;

@end
