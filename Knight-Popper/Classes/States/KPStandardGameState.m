/**
 * @filename KPStandardGameState.m
 * @author Morgan Wall
 * @date 5-10-2013
 */

#import "KPStandardGameState.h"
#import "KPActionCategories.h"
#import "TextureIDs.h"
#import "SoundIDs.h"
#import "StateIDs.h"
#import "SoundInstanceIDs.h"
#import "Random.h"
#import "KPPlayerScore.h"
#import "KPPlayerStats.h"
#import "StateDataKeys.h"
#import "ColliderTypes.h"
#import "KPTargetNode.h"
#import "KPProjectileNode.h"
#import "KPPlayerNode.h"
#import "KPBalloonPopNode.h"
#import <SpriteStackKit/SSKSpriteNode.h>
#import <SpriteStackKit/SSKAction.h>
#import <SpriteStackKit/SSKActionQueue.h>
#import <SpriteStackKit/SSKSpriteAnimationNode.h>
#import <SpriteStackKit/SSKButtonNode.h>
#import <SpriteStackKit/SSKResourcePool.h>
#import <SpriteStackKit/SSKResourcePoolManager.h>
#import <SpriteStackKit/SSKLabelNode.h>
#import <SpriteStackKit/SSKButtonNode.h>
#import "KPStateStack.h"

#pragma mark - Interface

@interface KPStandardGameState ()

typedef enum layers {
    LayerIDBackground = 0,
    LayerIDTargets,
    LayerIDPlayers,
    LayerIDScenery,
    LayerIDPoppedTargets,
    LayerIDProjectiles,
    LayerIDHUD
} LayerID;

typedef enum resourcePools {
    ResourcePoolIDBlueTarget = 0,
    ResourcePoolIDPinkTarget,
    ResourcePoolIDGoldTarget,
    ResourcePoolIDLeftProjectile,
    ResourcePoolIDRightProjectile
} ResourcePoolID;

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

@property KPPlayerScore* playerOneScore;

@property SSKLabelNode* playerOneScoreLabel;

@property KPPlayerScore* playerTwoScore;

@property SSKLabelNode* playerTwoScoreLabel;

@property KPPlayerStats* playerOneStats;

@property KPPlayerStats* playerTwoStats;

@property KPPlayerNode* leftPlayer;

@property KPPlayerNode* rightPlayer;

@property double durationRemaining;

@end

#pragma mark - Implementation

@implementation KPStandardGameState

- (id)initWithStateStack:(SSKStateStack *)stateStack
          textureManager:(SSKTextureManager *)textureManager
           audioDelegate:(id<SSKAudioManagerDelegate>)delegate
                    data:(NSDictionary*)data {
    unsigned int layerCount = 7;
    if (self = [super initWithStateStack:stateStack
                          textureManager:textureManager
                           audioDelegate:delegate
                                    data:data
                              layerCount:layerCount]) {
        self.actionQueue = [[SSKActionQueue alloc] init];
        self.poolManager = [[SSKResourcePoolManager alloc] initWithCapacity:5];
        self.initialTime = -1;
        self.timeLastGeneration = 0;
        self.countdownTimer = NULL;
        self.timeUp = NULL;
        self.gameTime = NULL;
        self.gameEnded = NO;
        self.playerOneScore = [[KPPlayerScore alloc] init];
        [self.playerOneScore addObserver:self
                              forKeyPath:@"score"
                                 options:NSKeyValueObservingOptionNew
                                 context:NULL];
        self.playerTwoScore = [[KPPlayerScore alloc] init];
        [self.playerTwoScore addObserver:self
                              forKeyPath:@"score"
                                 options:NSKeyValueObservingOptionNew
                                 context:NULL];
        self.playerOneStats = [[KPPlayerStats alloc] init];
        self.playerTwoStats = [[KPPlayerStats alloc] init];
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
                [self.gameTime animateReverse];
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
                NSDictionary* data = @{
                    [NSNumber numberWithInt:StateDataKeyPlayerOneScore]: self.playerOneScore,
                    [NSNumber numberWithInt:StateDataKeyPlayerTwoScore]: self.playerTwoScore,
                    [NSNumber numberWithInt:StateDataKeyPlayerOneStats]: self.playerOneStats,
                    [NSNumber numberWithInt:StateDataKeyPlayerTwoStats]: self.playerTwoStats};
                [self requestStackClear];
                [self requestStackPush:StateIDVictory data:data];
            }]]];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"score"]) {
        if ([object isEqual:self.playerOneScore]) {
            self.playerOneScoreLabel.text =
                [NSString stringWithFormat:@"%d", self.playerOneScore.score];
        } else if ([object isEqual:self.playerTwoScore]) {
            self.playerTwoScoreLabel.text =
                [NSString stringWithFormat:@"%d", self.playerTwoScore.score];
        }
    } else if ([keyPath isEqualToString:@"isAnimating"]) {
        [object destroy];
        [object removeObserver:self forKeyPath:@"isAnimating"];
    }
}

- (void)dealloc {
    [self.playerOneScore removeObserver:self forKeyPath:@"score"];
    [self.playerTwoScore removeObserver:self forKeyPath:@"score"];
}

#pragma mark SSKState

- (void)update:(CFTimeInterval)deltaTime {
    if (self.initialTime == -1) {
        self.initialTime = deltaTime;
        [self startCountdownTimer];
    }
    
    if (self.timeLastGeneration >= 60 && !self.gameEnded && self.gameStarted) {
        self.timeLastGeneration = 0;
        
        [self.poolManager retrieveFromPool:ResourcePoolIDBlueTarget];
        [self.poolManager retrieveFromPool:ResourcePoolIDPinkTarget];
        [self.poolManager retrieveFromPool:ResourcePoolIDGoldTarget];
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
        [resource removeFromParent];
        resource.physicsBody.resting = YES;
    };
    
    void (^targetGet)(id) = ^(id node) {
        SSKSpriteAnimationNode* resource = (SSKSpriteAnimationNode*)node;
        [self setRandomSpawnLocation:resource];
        
        // WEIRD FIX
        [resource removeFromParent];
        
        
        [self addNodeToLayer:LayerIDTargets node:resource];
        [resource.physicsBody
         applyForce:CGVectorMake([Random generateDouble:-self.scene.frame.size.height * 0.1302083333 upperBound:-self.scene.frame.size.height * 0.1302083333],
                                 [Random generateDouble:self.scene.frame.size.height * 1.953125 upperBound:self.scene.frame.size.height * 2.6041666667])];
        resource.physicsBody.angularVelocity =
            [Random generateDouble:-0.2 upperBound:0.2];
        resource.physicsBody.angularDamping =
            [Random generateDouble:0.05 upperBound:0.4];
        resource.physicsBody.linearDamping = 0.0;
    };
    
    void (^targetGetRightProj)(id) = ^(id node) {
        SSKSpriteAnimationNode* resource = (SSKSpriteAnimationNode*)node;
        resource.position = self.rightPlayer.position;
        [resource removeFromParent];
        [self addNodeToLayer:LayerIDProjectiles node:resource];
        resource.physicsBody.angularVelocity =
        [Random generateDouble:0.2 upperBound:0.4];
        resource.physicsBody.angularDamping =
        [Random generateDouble:0.05 upperBound:0.4];
        resource.physicsBody.linearDamping = 0.0;
    };
    
    void (^targetGetLeftProj)(id) = ^(id node) {
        SSKSpriteAnimationNode* resource = (SSKSpriteAnimationNode*)node;
        
        
        // WEIRD FIX
        [resource removeFromParent];
        
        
        resource.position = self.leftPlayer.position;
        [self addNodeToLayer:LayerIDProjectiles node:resource];
        resource.physicsBody.angularVelocity =
        [Random generateDouble:-0.4 upperBound:0.2];
        resource.physicsBody.angularDamping =
        [Random generateDouble:0.05 upperBound:0.4];
        resource.physicsBody.linearDamping = 0.0;
    };
    
    // Initialise blue target pool
    [self.poolManager addResourcePool:30
                         resourceType:[KPTargetNode class]
                            addAction:targetAdd
                            getAction:targetGet
                       poolIdentifier:ResourcePoolIDBlueTarget];
    
    for (int i = 0; i < 30; i++) {
        KPTargetNode* node =
            [[KPTargetNode alloc] initWithType:TargetTypeBlueMonkey textures:self.textures];
        [self.poolManager addToPool:ResourcePoolIDBlueTarget resource:node];
    }
    
    // Initialise pink target pool
    [self.poolManager addResourcePool:30
                         resourceType:[KPTargetNode class]
                            addAction:targetAdd
                            getAction:targetGet
                       poolIdentifier:ResourcePoolIDPinkTarget];

    for (int i = 0; i < 30; i++) {
        KPTargetNode* node =
            [[KPTargetNode alloc] initWithType:TargetTypePinkMonkey textures:self.textures];
        [self.poolManager addToPool:ResourcePoolIDPinkTarget resource:node];
    }
    
    // Initialise gold target pool
    [self.poolManager addResourcePool:30
                         resourceType:[KPTargetNode class]
                            addAction:targetAdd
                            getAction:targetGet
                       poolIdentifier:ResourcePoolIDGoldTarget];
    
    for (int i = 0; i < 30; i++) {
        KPTargetNode* node =
        [[KPTargetNode alloc] initWithType:TargetTypeGoldMonkey textures:self.textures];
        [self.poolManager addToPool:ResourcePoolIDGoldTarget resource:node];
    }
    
    // Initialise left projectile pool
    [self.poolManager addResourcePool:10
                         resourceType:[KPProjectileNode class]
                            addAction:targetAdd
                            getAction:targetGetLeftProj
                       poolIdentifier:ResourcePoolIDLeftProjectile];
    
    for (int i = 0; i < 10; i++) {
        KPProjectileNode* node =
            [[KPProjectileNode alloc] initWithType:ProjectileTypeLeft
            textures:self.textures];
        [self.poolManager addToPool:ResourcePoolIDLeftProjectile resource:node];
    }
    
    // Initialise right projectile pool
    [self.poolManager addResourcePool:10
                         resourceType:[KPProjectileNode class]
                            addAction:targetAdd
                            getAction:targetGetRightProj
                       poolIdentifier:ResourcePoolIDRightProjectile];
    
    for (int i = 0; i < 10; i++) {
        KPProjectileNode* node =
            [[KPProjectileNode alloc] initWithType:ProjectileTypeRight
            textures:self.textures];
        [self.poolManager addToPool:ResourcePoolIDRightProjectile resource:node];
    }
    
    // Initialise background layer
    SSKSpriteNode* background =
        [[SSKSpriteNode alloc]
         initWithTexture:[self.textures getTexture:TextureIDBackground]];
    background.position = CGPointZero;
    [self addNodeToLayer:LayerIDBackground node:background];
    
    // Initialise HUD layer
    CGFloat const PINK_MONKEY_HUD_REL_X = -0.4040625;
    CGFloat const PINK_MONKEY_HUD_REL_Y = 0.390625;
    
    SSKSpriteNode* pinkMonkeyHUD =
        [[SSKSpriteNode alloc]
         initWithTexture:[self.textures getTexture:TextureIDPinkMonkeyHUD]];
    pinkMonkeyHUD.position =
        CGPointMake(self.scene.frame.size.width * PINK_MONKEY_HUD_REL_X,
                    self.scene.frame.size.height * PINK_MONKEY_HUD_REL_Y);
    [self addNodeToLayer:LayerIDHUD node:pinkMonkeyHUD];
    
    CGFloat const BLUE_MONKEY_HUD_REL_X = 0.4040625;
    CGFloat const BLUE_MONKEY_HUD_REL_Y = 0.390625;
    
    SSKSpriteNode* blueMonkeyHUD = [[SSKSpriteNode alloc] initWithTexture:
                                   [self.textures getTexture:TextureIDBlueMonkeyHUD]];
    blueMonkeyHUD.position =
        CGPointMake(self.scene.frame.size.width * BLUE_MONKEY_HUD_REL_X,
                    self.scene.frame.size.height * BLUE_MONKEY_HUD_REL_Y);
    [self addNodeToLayer:LayerIDHUD node:blueMonkeyHUD];
    
    CGFloat const LEFT_PAUSE_REL_X = -0.4040625;
    CGFloat const LEFT_PAUSE_REL_Y = 0.240625;
    
    SSKButtonNode* leftPauseButton =
    [[SSKButtonNode alloc] initWithTexture:[self.textures getTexture:TextureIDPauseButton]
                           clickEventBlock:^(SSKButtonNode* node) {
                               [self requestStackPush:StateIDPause data:NULL];
                           }];
    
    leftPauseButton.position = CGPointMake(self.scene.frame.size.width * LEFT_PAUSE_REL_X,
                                           self.scene.frame.size.height * LEFT_PAUSE_REL_Y);
    [self addNodeToLayer:LayerIDHUD node:leftPauseButton];
    
    CGFloat const RIGHT_PAUSE_REL_X = 0.4040625;
    CGFloat const RIGHT_PAUSE_REL_Y = 0.240625;
    
    SSKButtonNode* rightPauseButton =
    [[SSKButtonNode alloc] initWithTexture:[self.textures getTexture:TextureIDPauseButton]
                           clickEventBlock:^(SSKButtonNode* node) {
                               [self requestStackPush:StateIDPause data:NULL];
                           }];
    rightPauseButton.position = CGPointMake(self.scene.frame.size.width * RIGHT_PAUSE_REL_X,
                                            self.scene.frame.size.height * RIGHT_PAUSE_REL_Y);
    [self addNodeToLayer:LayerIDHUD node:rightPauseButton];
    
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
    CGFloat const Game_TIMER_REL_Y = 0.39;
    
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
    
    CGFloat const PLAYER_ONE_SCORE_REL_X = -0.3;
    CGFloat const PLAYER_ONE_SCORE_REL_Y = 0.370625;
    
    self.playerOneScoreLabel = [[SSKLabelNode alloc] initWithFontNamed:@"gameFont"];
    self.playerOneScoreLabel.text = [NSString stringWithFormat:@"%d", self.playerOneScore.score];
    self.playerOneScoreLabel.fontSize = self.scene.frame.size.height * 0.06510416667;
    self.playerOneScoreLabel.position =
    CGPointMake(self.scene.frame.size.width * PLAYER_ONE_SCORE_REL_X,
                self.scene.frame.size.height * PLAYER_ONE_SCORE_REL_Y);
    [self addNodeToLayer:LayerIDHUD node:self.playerOneScoreLabel];
    
    CGFloat const PLAYER_TWO_SCORE_REL_X = 0.3;
    CGFloat const PLAYER_TWO_SCORE_REL_Y = 0.370625;
    
    self.playerTwoScoreLabel = [[SSKLabelNode alloc] initWithFontNamed:@"gameFont"];
    self.playerTwoScoreLabel.text = [NSString stringWithFormat:@"%d", self.playerTwoScore.score];
    self.playerTwoScoreLabel.fontSize = self.scene.frame.size.height * 0.06510416667;
    self.playerTwoScoreLabel.position =
    CGPointMake(self.scene.frame.size.width * PLAYER_TWO_SCORE_REL_X,
                self.scene.frame.size.height * PLAYER_TWO_SCORE_REL_Y);
    [self addNodeToLayer:LayerIDHUD node:self.playerTwoScoreLabel];
    
    // Initialise players layer
    CGFloat const LEFT_PLAYER_REL_X = -0.30796875;
    CGFloat const LEFT_PLAYER_REL_Y = -0.1878645833;
    
    self.leftPlayer = [[KPPlayerNode alloc] initWithType:PlayerTypeLeft
                                                         textures:self.textures
                                                     timePerFrame:1.0/14.0];
    self.leftPlayer.audioDelegate = self.audioDelegate;
    self.leftPlayer.delegate = (id<KPPlayerSwipeHandler>)self;
    self.leftPlayer.position =
        CGPointMake(self.scene.frame.size.width * LEFT_PLAYER_REL_X,
                    self.scene.frame.size.height * LEFT_PLAYER_REL_Y);
    [self.leftPlayer animate];
    [self addNodeToLayer:LayerIDPlayers node:self.leftPlayer];
    
    CGFloat const RIGHT_PLAYER_REL_X = 0.30796875;
    CGFloat const RIGHT_PLAYER_REL_Y = -0.1878645833;
    
    self.rightPlayer = [[KPPlayerNode alloc] initWithType:PlayerTypeRight
                                                          textures:self.textures
                                                      timePerFrame:1.0/14.0];
    self.rightPlayer.audioDelegate = self.audioDelegate;
    self.rightPlayer.delegate = (id<KPPlayerSwipeHandler>)self;
    self.rightPlayer.position =
        CGPointMake(self.scene.frame.size.width * RIGHT_PLAYER_REL_X,
                    self.scene.frame.size.height * RIGHT_PLAYER_REL_Y);
    [self.rightPlayer animate];
    [self addNodeToLayer:LayerIDPlayers node:self.rightPlayer];
    
    // Initialise scenery layer
    CGFloat const LEFT_GRASS_REL_X = -0.2973125;
    CGFloat const LEFT_GRASS_REL_Y = -0.3870833333;
    
    SSKSpriteNode* leftGrassTuft =
        [[SSKSpriteNode alloc]
         initWithTexture:[self.textures getTexture:TextureIDGrassTuftLeft]];
    leftGrassTuft.position =
        CGPointMake(self.scene.frame.size.width * LEFT_GRASS_REL_X,
                    self.scene.frame.size.height * LEFT_GRASS_REL_Y);
    [self addNodeToLayer:LayerIDScenery node:leftGrassTuft];
    
    CGFloat const RIGHT_GRASS_REL_X = 0.3043125;
    CGFloat const RIGHT_GRASS_REL_Y = -0.3870833333;
    
    SSKSpriteNode* rightGrassTuft =
        [[SSKSpriteNode alloc]
         initWithTexture:[self.textures getTexture:TextureIDGrassTuftRight]];
    rightGrassTuft.position =
        CGPointMake(self.scene.frame.size.width * RIGHT_GRASS_REL_X,
                    self.scene.frame.size.height * RIGHT_GRASS_REL_Y);
    [self addNodeToLayer:LayerIDScenery node:rightGrassTuft];
}

#pragma mark SKPhysicsContactDelegate

- (void)didBeginContact:(SKPhysicsContact *)contact {
    uint32_t bodyACategory = contact.bodyA.categoryBitMask;
    uint32_t bodyBCategory = contact.bodyB.categoryBitMask;
    
    if ((bodyACategory == ColliderTypeProjectile
                && bodyBCategory == ColliderTypeTarget)
        || (bodyACategory == ColliderTypeTarget
                && bodyBCategory == ColliderTypeProjectile)) {
            
            id target;
            KPProjectileNode* projectile;
            ProjectileType projType;
            if (bodyACategory == ColliderTypeTarget) {
                target = contact.bodyA.node;
                projectile = (KPProjectileNode*)contact.bodyB.node;
                
                projType = projectile.type;
                if (projType == ProjectileTypeLeft) {
                    [self.poolManager addToPool:ResourcePoolIDLeftProjectile resource:projectile];
                } else {
                    [self.poolManager addToPool:ResourcePoolIDRightProjectile resource:projectile];
                }
                
            } else {
                target = contact.bodyB.node;
                projectile = (KPProjectileNode*)contact.bodyA.node;
                
                projType = projectile.type;
                if (projType == ProjectileTypeLeft) {
                    [self.poolManager addToPool:ResourcePoolIDLeftProjectile resource:projectile];
                } else {
                    [self.poolManager addToPool:ResourcePoolIDRightProjectile resource:projectile];
                }
            }
            
            if ([target isKindOfClass:[KPTargetNode class]]) {
                KPTargetNode* node = (KPTargetNode*)target;
                CGPoint targetPosition = node.position;
                PopType popType;
                
                switch (node.type) {
                    case TargetTypeBlueMonkey: {
                        [self.poolManager addToPool:ResourcePoolIDBlueTarget resource:node];
                        [self.audioDelegate playSound:SoundIDBalloonPop];
                        [self.playerTwoScore modifyScore:10];
                        popType = PopTypeBlue;
                        
                        if (projType == ProjectileTypeLeft) {
                            [self.playerOneStats incrementBlueTargetHitCounter];
                        } else {
                            [self.playerTwoStats incrementBlueTargetHitCounter];
                        }
                    }
                    break;
                        
                    case TargetTypePinkMonkey: {
                        [self.poolManager addToPool:ResourcePoolIDPinkTarget resource:node];
                        [self.audioDelegate playSound:SoundIDBalloonPop];
                        [self.playerOneScore modifyScore:10];
                        popType = PopTypePink;
                        
                        if (projType == ProjectileTypeLeft) {
                            [self.playerOneStats incrementPinkTargetHitCounter];
                        } else {
                            [self.playerTwoStats incrementPinkTargetHitCounter];
                        }
                    }
                    break;
                        
                    case TargetTypeGoldMonkey: {
                        [self.poolManager addToPool:ResourcePoolIDGoldTarget resource:node];
                        [self.audioDelegate playSound:SoundIDGoldenPop];
                        popType = PopTypeGold;
                        
                        if (projType == ProjectileTypeLeft) {
                            [self.playerOneScore modifyScore:30];
                            [self.playerOneStats incrementGoldTargetHitCounter];
                        } else {
                            [self.playerTwoScore modifyScore:30];
                            [self.playerTwoStats incrementGoldTargetHitCounter];
                        }
                    }
                    break;
                }
                
                KPBalloonPopNode* pop =
                    [[KPBalloonPopNode alloc] initWithType:popType
                    textures:self.textures timePerFrame:1.0/14.0];
                pop.position = targetPosition;
                [self addNodeToLayer:LayerIDPoppedTargets node:pop];
                [pop animateOnce];
                [pop addObserver:self
                      forKeyPath:@"isAnimating"
                         options:NSKeyValueObservingOptionNew
                         context:NULL];
            }
    }
}

- (void)didEndContact:(SKPhysicsContact *)contact {
    // stub
}

#pragma mark KPPlayerSwipeHandler

- (void)handleThrow:(CGVector)vector player:(unsigned int)player {
    ResourcePoolID poolID = player ? ResourcePoolIDRightProjectile : ResourcePoolIDLeftProjectile;
    KPProjectileNode* projectile = [self.poolManager retrieveFromPool:poolID];
    [projectile.physicsBody applyForce:CGVectorMake(vector.dx * 25, vector.dy * 25)];
    [self.audioDelegate playSound:SoundIDLollipopThrow];
}

#pragma mark Helper Methods

- (void)addRemoveTargetActionToQueue {
    void (^checkOffScreen)(SKNode*, CFTimeInterval) =
    ^(SKNode* node, CFTimeInterval elapsedTime) {
        CGFloat maxX = self.scene.frame.size.width/2.0 + node.frame.size.width/2.0;
        CGFloat minX = -maxX;
        CGFloat maxY = self.scene.frame.size.height/2.0 + node.frame.size.height/2.0;
        CGFloat minY = -maxY - 300;
        if (node.position.x > maxX || node.position.x < minX ||
            node.position.y > maxY || node.position.y < minY) {
            
            if ([node isKindOfClass:[KPTargetNode class]]) {
                if ([(KPTargetNode*)node type] == TargetTypeBlueMonkey) {
                    [self.poolManager addToPool:ResourcePoolIDBlueTarget resource:node];
                } else if ([(KPTargetNode*)node type] == TargetTypePinkMonkey) {
                    [self.poolManager addToPool:ResourcePoolIDPinkTarget resource:node];
                } else if ([(KPTargetNode*)node type] == TargetTypeGoldMonkey){
                    [self.poolManager addToPool:ResourcePoolIDGoldTarget resource:node];
                }
            } else if ([node isKindOfClass:[KPProjectileNode class]]) {
                if ([(KPProjectileNode*)node type] == ProjectileTypeLeft) {
                    [self.poolManager addToPool:ResourcePoolIDLeftProjectile resource:node];
                } else if ([(KPProjectileNode*)node type] == ProjectileTypeRight) {
                    [self.poolManager addToPool:ResourcePoolIDRightProjectile resource:node];
                }
            }
        }
    };
    
    SSKAction *action =
        [[SSKAction alloc] initWithCategory:ActionCategoryProjectile | ActionCategoryTarget
                                     action:checkOffScreen];
    [self.actionQueue push:action];
}

- (void)startCountdownTimer {
    [self runAction:self.countdownSoundAction];
    [self.countdownTimer animate];
}

- (void)setRandomSpawnLocation:(SKNode*)target {
    double const X_LOWER_BOUND_REL = -0.33 * self.scene.frame.size.width;
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
@synthesize playerOneScore;
@synthesize playerOneScoreLabel;
@synthesize playerOneStats;
@synthesize playerTwoScore;
@synthesize playerTwoScoreLabel;
@synthesize playerTwoStats;
@synthesize leftPlayer;
@synthesize rightPlayer;
@synthesize durationRemaining;

@end
