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
#import "Random.h"
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

- (void)startCountdownTimer;

- (void)setRandomSpawnLocation:(SKNode*)target;

@property SSKActionQueue* actionQueue;

@property SSKResourcePoolManager* poolManager;

@property CFTimeInterval initialTime;

@property CFTimeInterval timeLastGeneration;

@property SSKSpriteAnimationNode* countdownTimer;

@property SKAction* countdownSoundAction;

@property SSKSpriteAnimationNode* gameTime;

@property SSKSpriteNode* timeUp;

@property BOOL gameStarted;

@property BOOL gameEnded;

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
        self.countdownTimer = NULL;
        self.timeUp = NULL;
        self.gameTime = NULL;
        self.gameEnded = NO;
        self.countdownSoundAction =
            [SKAction sequence:@[
            [SKAction runBlock:^{[self.audioDelegate playSound:SoundIDCountdownThree];}],
            [SKAction waitForDuration:1],
            [SKAction runBlock:^{[self.audioDelegate playSound:SoundIDCountdownTwo];}],
            [SKAction waitForDuration:1],
            [SKAction runBlock:^{[self.audioDelegate playSound:SoundIDCountdownOne];}],
            [SKAction waitForDuration:1],
            [SKAction runBlock:^{[self.audioDelegate playSound:SoundIDCountdownGo];}],
            [SKAction waitForDuration:0.95],
            [SKAction runBlock:^{
                [self.countdownTimer removeFromParent];
                [self addNodeToLayer:LayerIDHUD node:self.gameTime];
                [self.gameTime animate];
                self.gameStarted = YES;
            }],
            [SKAction waitForDuration:30],
            [SKAction runBlock:^{
                self.gameEnded = YES;
                [self.gameTime removeFromParent];
                [self addNodeToLayer:LayerIDHUD node:self.timeUp];
            }],
            [SKAction waitForDuration:3.1],
            [SKAction runBlock:^{
                [self requestStackClear];
                [self requestStackPush:StateIDVictory];
            }]]];
    }
    return self;
}

#pragma mark SSKState

- (void)update:(CFTimeInterval)deltaTime {
    if (self.initialTime == -1) {
        self.initialTime = deltaTime;
        [self startCountdownTimer];
    }
    
    if (self.timeLastGeneration >= 60 && !self.gameEnded && self.gameStarted) {
        self.timeLastGeneration = 0;
        
        [self.poolManager retrieveFromPool:1];
        [self.poolManager retrieveFromPool:2];
        [self.poolManager retrieveFromPool:3];
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
    void (^targetAdd)(id) = ^(id node) {
        SSKSpriteAnimationNode* resource = (SSKSpriteAnimationNode*)node;
        [resource removeAllActions];
        [resource removeFromParent];
        [resource stopAnimating];
    };
    
    void (^targetGet)(id) = ^(id node) {
        SSKSpriteAnimationNode* resource = (SSKSpriteAnimationNode*)node;
        [self setRandomSpawnLocation:resource];
        [resource runAction:
         [SKAction moveTo:CGPointMake(resource.position.x, -resource.position.y)
                 duration:[Random generateDouble:3.0 upperBound:6.0]]];
        [self addNodeToLayer:LayerIDTargets node:resource];
        [resource animate];
    };
    
    // Initialise resources in pools
    [self.poolManager addResourcePool:30
                         resourceType:[SSKSpriteAnimationNode class]
                            addAction:targetAdd
                            getAction:targetGet
                       poolIdentifier:1];
    
    for (int i = 0; i < 30; i++) {
        SSKSpriteAnimationNode* node =
        [[SSKSpriteAnimationNode alloc]
         initWithSpriteSheet:[self.textures getTexture:TextureIDPinkMonkeyTarget]
         columns:8 rows:3 numFrames:20 horizontalOrder:YES timePerFrame:1.0/14.0];
        [self.poolManager addToPool:1 resource:node];
    }
    
    [self.poolManager addResourcePool:30
                         resourceType:[SSKSpriteAnimationNode class]
                            addAction:targetAdd
                            getAction:targetGet
                       poolIdentifier:2];
    
    for (int i = 0; i < 30; i++) {
        SSKSpriteAnimationNode* node =
        [[SSKSpriteAnimationNode alloc]
         initWithSpriteSheet:[self.textures getTexture:TextureIDBlueMonkeyTarget]
         columns:8 rows:3 numFrames:20 horizontalOrder:YES timePerFrame:1.0/14.0];
        [self.poolManager addToPool:2 resource:node];
    }
    
    [self.poolManager addResourcePool:2
                         resourceType:[SSKSpriteAnimationNode class]
                            addAction:targetAdd
                            getAction:targetGet
                       poolIdentifier:3];
    
    for (int i = 0; i < 2; i++) {
        SSKSpriteAnimationNode* node =
        [[SSKSpriteAnimationNode alloc]
         initWithSpriteSheet:[self.textures getTexture:TextureIDGoldMonkeyTarget]
         columns:8 rows:3 numFrames:20 horizontalOrder:YES timePerFrame:1.0/14.0];
        [self.poolManager addToPool:3 resource:node];
    }
    
    [self.poolManager addResourcePool:10
                         resourceType:[SSKSpriteAnimationNode class]
                            addAction:targetAdd
                            getAction:targetGet
                       poolIdentifier:4];
    
    for (int i = 0; i < 10; i++) {
        SSKSpriteAnimationNode* node =
        [[SSKSpriteAnimationNode alloc]
         initWithSpriteSheet:[self.textures getTexture:TextureIDLollipopLeftProjectile]
         columns:3 rows:3 numFrames:8 horizontalOrder:YES timePerFrame:1.0/14.0];
        [self.poolManager addToPool:4 resource:node];
    }
    
    [self.poolManager addResourcePool:10
                         resourceType:[SSKSpriteAnimationNode class]
                            addAction:targetAdd
                            getAction:targetGet
                       poolIdentifier:5];
    
    for (int i = 0; i < 10; i++) {
        SSKSpriteAnimationNode* node =
        [[SSKSpriteAnimationNode alloc]
         initWithSpriteSheet:[self.textures getTexture:TextureIDLollipopRightProjectile]
         columns:3 rows:3 numFrames:8 horizontalOrder:YES timePerFrame:1.0/14.0];
        [self.poolManager addToPool:5 resource:node];
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
    
    CGFloat const TIMER_REL_X = 0.0;
    CGFloat const TIMER_REL_Y = 0.0;
    
    self.countdownTimer =
        [[SSKSpriteAnimationNode alloc]
         initWithSpriteSheet:[self.textures getTexture:TextureIDCountdown]
         columns:2 rows:2 numFrames:4 horizontalOrder:YES timePerFrame:1];
    self.countdownTimer.position =
        CGPointMake(self.scene.frame.size.width * TIMER_REL_X,
                    self.scene.frame.size.height * TIMER_REL_Y);
    [self addNodeToLayer:LayerIDHUD node:self.countdownTimer];
    
    CGFloat const GAME_TIMER_REL_X = 0.0;
    CGFloat const Game_TIMER_REL_Y = 0.4;
    
    self.gameTime =
        [[SSKSpriteAnimationNode alloc]
         initWithSpriteSheet:[self.textures getTexture:TextureIDTimer] columns:5
         rows:6 numFrames:30 horizontalOrder:YES timePerFrame:1];
    self.gameTime.position =
        CGPointMake(self.scene.size.width * GAME_TIMER_REL_X,
                    self.scene.size.height * Game_TIMER_REL_Y);
    
    self.timeUp =
        [[SSKSpriteNode alloc] initWithTexture:[self.textures getTexture:TextureIDTimeUp]];
    self.timeUp.position = CGPointZero;
    
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

#pragma mark SSKEventHandler

- (BOOL)handleEvent:(UIEvent*)event touch:(UITouch *)touch {
    if ([Random generateBool:0.5]) {
        [self.poolManager retrieveFromPool:4];
    } else {
        [self.poolManager retrieveFromPool:5];
    }
    return YES;
}

#pragma mark Helper Methods

- (void)addRemoveTargetActionToQueue {
    void (^checkOffScreen)(SKNode*, CFTimeInterval) =
    ^(SKNode* node, CFTimeInterval elapsedTime) {
        CGFloat maxX = self.scene.frame.size.width/2.0 + node.frame.size.width/2.0;
        CGFloat minX = -maxX;
        CGFloat maxY = self.scene.frame.size.height/2.0 + node.frame.size.height/2.0;
        if (node.position.x > maxX || node.position.x < minX ||
            node.position.y > maxY) {
            // TODO: Add to appropriate pool!
//            [self.poolManager addToPool:1 resource:node];
        }
    };
    
    SSKAction *action =
        [[SSKAction alloc] initWithCategory:[SSKAction defaultActionCategory]
                                     action:checkOffScreen];
    [self.actionQueue push:action];
}

- (void)startCountdownTimer {
    [self runAction:self.countdownSoundAction];
    [self.countdownTimer animate];
}

- (void)setRandomSpawnLocation:(SKNode*)target {
    double const X_LOWER_BOUND_REL = -0.25 * self.scene.frame.size.width;
    double const X_UPPER_BOUND_REL = -X_LOWER_BOUND_REL;
    
    CGFloat yLocation = -self.scene.frame.size.height / 2.0
                            - target.frame.size.height;
    CGFloat xLocation =
        [Random generateDouble:X_LOWER_BOUND_REL upperBound:X_UPPER_BOUND_REL];
    
    target.position = CGPointMake(xLocation, yLocation);
}

#pragma mark - Properties

@synthesize actionQueue;
@synthesize poolManager;
@synthesize initialTime;
@synthesize timeLastGeneration;
@synthesize countdownTimer;
@synthesize countdownSoundAction;
@synthesize gameTime;
@synthesize timeUp;
@synthesize gameStarted;

@end
