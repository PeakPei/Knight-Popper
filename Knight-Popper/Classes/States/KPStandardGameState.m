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
#import "Coordinates.h"
#import "KPPlayerAttackNode.h"

#pragma mark - Interface

@interface KPStandardGameState ()

typedef enum layers {
    LayerIDBackground = 0,
    LayerIDPlayers,
    LayerIDScenery,
    LayerIDTargets,
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

- (void)garbageCollectNode:(SKNode*)node;

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

@property KPPlayerAttackNode* leftPlayerThrow;

@property CGVector leftPlayerThrowVector;

@property BOOL leftProjectileThrown;

@property KPPlayerNode* rightPlayer;

@property KPPlayerAttackNode* rightPlayerThrow;

@property CGVector rightPlayerThrowVector;

@property BOOL rightProjectileThrown;

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
        self.leftProjectileThrown = NO;
        self.rightProjectileThrown = NO;
        
        // initialise player score and stat tracking
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
        
        // define the general structure of the level as a series of timed-based
        // SKActions
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
    
    // handle changes in the player scores
    if ([keyPath isEqualToString:@"score"]) {
        if ([object isEqual:self.playerOneScore]) {
            self.playerOneScoreLabel.text =
                [NSString stringWithFormat:@"%d", self.playerOneScore.score];
        } else if ([object isEqual:self.playerTwoScore]) {
            self.playerTwoScoreLabel.text =
                [NSString stringWithFormat:@"%d", self.playerTwoScore.score];
        }
    
    // handle the balloon pop animation finishing
    } else if ([object isKindOfClass:[KPBalloonPopNode class]]
               && [keyPath isEqualToString:@"isAnimating"]) {
        [object removeObserver:self forKeyPath:@"isAnimating"];
        [object destroy];
    
    // respond to the throw animation being toggled for the left player
    } else if (object == self.leftPlayerThrow
               && [keyPath isEqualToString:@"isAnimating"]) {
        if (self.leftPlayerThrow.isAnimating) {
            self.leftPlayer.hidden = YES;
            self.leftPlayerThrow.hidden = NO;
            self.leftProjectileThrown = NO;
        } else {
            self.leftPlayer.hidden = NO;
            self.leftPlayerThrow.hidden = YES;
        }
    
    // respond to the throw animation being toggled for the right player
    } else if (object == self.rightPlayerThrow
               && [keyPath isEqualToString:@"isAnimating"]) {
        if (self.rightPlayerThrow.isAnimating) {
            self.rightPlayer.hidden = YES;
            self.rightPlayerThrow.hidden = NO;
            self.rightProjectileThrown = NO;
        } else {
            self.rightPlayer.hidden = NO;
            self.rightPlayerThrow.hidden = YES;
        }
        
    // handle changes in the visibility of the left player idle animation
    } else if (object == self.leftPlayer
               && [keyPath isEqualToString:@"hidden"]) {
        self.leftPlayer.isActive = !self.leftPlayer.hidden;
        
    // handle changes in the visibility of the right player idle animation
    } else if (object == self.rightPlayer
               && [keyPath isEqualToString:@"hidden"]) {
        self.rightPlayer.isActive = !self.rightPlayer.hidden;
    }
}

- (void)dealloc {
    [self.playerOneScore removeObserver:self forKeyPath:@"score"];
    [self.playerTwoScore removeObserver:self forKeyPath:@"score"];
    [self.rightPlayerThrow removeObserver:self forKeyPath:@"isAnimating"];
    [self.rightPlayerThrow removeObserver:self forKeyPath:@"isAnimating"];
    [self.leftPlayer removeObserver:self forKeyPath:@"hidden"];
    [self.rightPlayer removeObserver:self forKeyPath:@"hidden"];
}

#pragma mark SSKState

- (void)updateState:(CFTimeInterval)deltaTime {
    if (self.isActive) {
        if (self.initialTime == -1) {
            self.initialTime = deltaTime;
            [self startCountdownTimer];
        }
        
        // generate additional targets
        if (self.timeLastGeneration >= 2.5f && !self.gameEnded && self.gameStarted) {
            self.timeLastGeneration = 0;
            
            [self.poolManager retrieveFromPool:ResourcePoolIDBlueTarget];
            [self.poolManager retrieveFromPool:ResourcePoolIDPinkTarget];
            [self.poolManager retrieveFromPool:ResourcePoolIDGoldTarget];
        } else {
            self.timeLastGeneration += deltaTime;
        }
        
        // generate projectiles if necessary
        if (self.leftPlayerThrow.isAnimating && !self.leftProjectileThrown
                && [self.leftPlayerThrow showingProjectileGenerationFrame]) {
            KPProjectileNode* projectile =
            [self.poolManager retrieveFromPool:ResourcePoolIDLeftProjectile];
            [projectile.physicsBody
             applyForce:CGVectorMake(self.leftPlayerThrowVector.dx * 25,
                                     self.leftPlayerThrowVector.dy * 25)];
            [self.audioDelegate playSound:SoundIDLollipopThrow];
            self.leftProjectileThrown = YES;
        }
        
        if (self.rightPlayerThrow.isAnimating && !self.rightProjectileThrown
                && [self.rightPlayerThrow showingProjectileGenerationFrame]) {
            KPProjectileNode* projectile =
            [self.poolManager retrieveFromPool:ResourcePoolIDRightProjectile];
            [projectile.physicsBody
             applyForce:CGVectorMake(self.rightPlayerThrowVector.dx * 25,
                                     self.rightPlayerThrowVector.dy * 25)];
            [self.audioDelegate playSound:SoundIDLollipopThrow];
            self.rightProjectileThrown = YES;
        }
        
        // remove off-screen objects
        [self addRemoveTargetActionToQueue];
        
        // execute actions on the scene graph
        while (![self.actionQueue isEmpty]) {
            [self onAction:[self.actionQueue pop] deltaTime:deltaTime];
        }
    }
}

- (void)buildState {
    // Initialise resource pools
    void (^entityAdd)(id) = ^(id node) {
        SSKSpriteNode* resource = (SSKSpriteNode*)node;
        [resource removeFromParent];
        resource.physicsBody.resting = YES;
    };
    
    void (^targetGet)(id) = ^(id node) {
        KPTargetNode* resource = (KPTargetNode*)node;
        resource.collided = false;
        
        if (!resource.parent) {
            [self addNodeToLayer:LayerIDTargets node:resource];
        }
        
        [self setRandomSpawnLocation:resource];
        
        [resource.physicsBody
         applyForce:CGVectorMake([Random generateDouble:-self.scene.frame.size.height * 0.1302083333
                                             upperBound:-self.scene.frame.size.height * 0.1302083333],
                                 [Random generateDouble:self.scene.frame.size.height * 1.953125
                                             upperBound:self.scene.frame.size.height * 2.6041666667])];
        resource.physicsBody.angularVelocity =
            [Random generateDouble:-0.2 upperBound:0.2];
        resource.physicsBody.angularDamping =
            [Random generateDouble:0.05 upperBound:0.4];
        resource.physicsBody.linearDamping = 0.0;
    };
    
    CGFloat const RIGHT_PROJECTILE_OFFSET_X = -0.03;
    CGFloat const RIGHT_PROJECTILE_OFFSET_Y = 0.25;
    
    void (^targetGetRightProj)(id) = ^(id node) {
        SSKSpriteAnimationNode* resource = (SSKSpriteAnimationNode*)node;
        
        if (!resource.parent) {
            [self addNodeToLayer:LayerIDProjectiles node:resource];
        }
        
        CGPoint rightProjectilePosition =
            CGPointMake(self.rightPlayerThrow.position.x
                            + self.rightPlayerThrow.size.width * RIGHT_PROJECTILE_OFFSET_X,
                        self.rightPlayerThrow.position.y
                            + self.rightPlayerThrow.size.height * RIGHT_PROJECTILE_OFFSET_Y);
        resource.position = rightProjectilePosition;
        
        resource.physicsBody.angularVelocity =
        [Random generateDouble:0.2 upperBound:0.4];
        resource.physicsBody.angularDamping =
        [Random generateDouble:0.05 upperBound:0.4];
        resource.physicsBody.linearDamping = 0.0;
    };
    
    CGFloat const LEFT_PROJECTILE_OFFSET_X = 0.03;
    CGFloat const LEFT_PROJECTILE_OFFSET_Y = 0.25;
    
    void (^targetGetLeftProj)(id) = ^(id node) {
        SSKSpriteAnimationNode* resource = (SSKSpriteAnimationNode*)node;
        
        if (!resource.parent) {
            [self addNodeToLayer:LayerIDProjectiles node:resource];
        }
        
        CGPoint leftProjectilePosition =
        CGPointMake(self.leftPlayerThrow.position.x
                        + self.leftPlayerThrow.size.width * LEFT_PROJECTILE_OFFSET_X,
                    self.leftPlayerThrow.position.y
                        + self.leftPlayerThrow.size.height * LEFT_PROJECTILE_OFFSET_Y);
        resource.position = leftProjectilePosition;
        
        resource.physicsBody.angularVelocity =
        [Random generateDouble:-0.4 upperBound:0.2];
        resource.physicsBody.angularDamping =
        [Random generateDouble:0.05 upperBound:0.4];
        resource.physicsBody.linearDamping = 0.0;
    };
    
    // initialise resource pool properties
    int const TARGET_COUNT = 20;
    int const PROJECTILE_COUNT = 20;
    
    // Initialise blue target pool
    [self.poolManager addResourcePool:TARGET_COUNT
                         resourceType:[KPTargetNode class]
                            addAction:entityAdd
                            getAction:targetGet
                       poolIdentifier:ResourcePoolIDBlueTarget];
    
    for (int i = 0; i < TARGET_COUNT; i++) {
        KPTargetNode* node =
            [[KPTargetNode alloc] initWithType:TargetTypeBlueMonkey textures:self.textures];
        [self.poolManager addToPool:ResourcePoolIDBlueTarget resource:node];
    }
    
    // Initialise pink target pool
    [self.poolManager addResourcePool:TARGET_COUNT
                         resourceType:[KPTargetNode class]
                            addAction:entityAdd
                            getAction:targetGet
                       poolIdentifier:ResourcePoolIDPinkTarget];

    for (int i = 0; i < TARGET_COUNT; i++) {
        KPTargetNode* node =
            [[KPTargetNode alloc] initWithType:TargetTypePinkMonkey textures:self.textures];
        [self.poolManager addToPool:ResourcePoolIDPinkTarget resource:node];
    }
    
    // Initialise gold target pool
    [self.poolManager addResourcePool:TARGET_COUNT
                         resourceType:[KPTargetNode class]
                            addAction:entityAdd
                            getAction:targetGet
                       poolIdentifier:ResourcePoolIDGoldTarget];
    
    for (int i = 0; i < TARGET_COUNT; i++) {
        KPTargetNode* node =
        [[KPTargetNode alloc] initWithType:TargetTypeGoldMonkey textures:self.textures];
        [self.poolManager addToPool:ResourcePoolIDGoldTarget resource:node];
    }
    
    // Initialise left projectile pool
    [self.poolManager addResourcePool:PROJECTILE_COUNT
                         resourceType:[KPProjectileNode class]
                            addAction:entityAdd
                            getAction:targetGetLeftProj
                       poolIdentifier:ResourcePoolIDLeftProjectile];
    
    for (int i = 0; i < PROJECTILE_COUNT; i++) {
        KPProjectileNode* node =
            [[KPProjectileNode alloc] initWithType:ProjectileTypeLeft
            textures:self.textures];
        [self.poolManager addToPool:ResourcePoolIDLeftProjectile resource:node];
    }
    
    // Initialise right projectile pool
    [self.poolManager addResourcePool:PROJECTILE_COUNT
                         resourceType:[KPProjectileNode class]
                            addAction:entityAdd
                            getAction:targetGetRightProj
                       poolIdentifier:ResourcePoolIDRightProjectile];
    
    for (int i = 0; i < PROJECTILE_COUNT; i++) {
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
    pinkMonkeyHUD.position = CGPointMake(
        [Coordinates convertXFromiPhone:IPHONE_LANDSCAPE_WIDTH_PTS * PINK_MONKEY_HUD_REL_X
                    scalesForWidescreen:YES],
        [Coordinates convertYFromiPhone:IPHONE_LANDSCAPE_HEIGHT_PTS * PINK_MONKEY_HUD_REL_Y]);
    [self addNodeToLayer:LayerIDHUD node:pinkMonkeyHUD];
    
    CGFloat const BLUE_MONKEY_HUD_REL_X = 0.4040625;
    CGFloat const BLUE_MONKEY_HUD_REL_Y = 0.390625;
    
    SSKSpriteNode* blueMonkeyHUD = [[SSKSpriteNode alloc] initWithTexture:
                                   [self.textures getTexture:TextureIDBlueMonkeyHUD]];
    blueMonkeyHUD.position = CGPointMake(
        [Coordinates convertXFromiPhone:IPHONE_LANDSCAPE_WIDTH_PTS * BLUE_MONKEY_HUD_REL_X
                    scalesForWidescreen:YES],
        [Coordinates convertYFromiPhone:IPHONE_LANDSCAPE_HEIGHT_PTS * BLUE_MONKEY_HUD_REL_Y]);
    [self addNodeToLayer:LayerIDHUD node:blueMonkeyHUD];
    
    CGFloat const LEFT_PAUSE_REL_X = -0.4040625;
    CGFloat const LEFT_PAUSE_REL_Y = 0.240625;
    
    SSKButtonNode* leftPauseButton =
        [[SSKButtonNode alloc]
         initWithDefaultTexture:[self.textures getTexture:TextureIDPauseButton]
         pressedTexture:[self.textures getTexture:TextureIDPauseButtonHover]
         beginPressBlock:NULL
         endPressBlock:^(SSKButtonNode* node) {
             self.isActive = NO;
            [self requestStackPush:StateIDPause data:NULL];
        }];
    leftPauseButton.position = CGPointMake(
        [Coordinates convertXFromiPhone:IPHONE_LANDSCAPE_WIDTH_PTS * LEFT_PAUSE_REL_X
                    scalesForWidescreen:YES],
        [Coordinates convertYFromiPhone:IPHONE_LANDSCAPE_HEIGHT_PTS * LEFT_PAUSE_REL_Y]);
    [self addNodeToLayer:LayerIDHUD node:leftPauseButton];
    
    CGFloat const RIGHT_PAUSE_REL_X = 0.4040625;
    CGFloat const RIGHT_PAUSE_REL_Y = 0.240625;
    
    SSKButtonNode* rightPauseButton =
        [[SSKButtonNode alloc]
         initWithDefaultTexture:[self.textures getTexture:TextureIDPauseButton]
         pressedTexture:[self.textures getTexture:TextureIDPauseButtonHover]
         beginPressBlock:NULL
         endPressBlock:^(SSKButtonNode* node) {
             self.isActive = NO;
             [self requestStackPush:StateIDPause data:NULL];
         }];
    rightPauseButton.position = CGPointMake(
        [Coordinates convertXFromiPhone:IPHONE_LANDSCAPE_WIDTH_PTS * RIGHT_PAUSE_REL_X
                    scalesForWidescreen:YES],
        [Coordinates convertYFromiPhone:IPHONE_LANDSCAPE_HEIGHT_PTS * RIGHT_PAUSE_REL_Y]);
    [self addNodeToLayer:LayerIDHUD node:rightPauseButton];
    
    self.countdownTimer =
        [[SSKSpriteAnimationNode alloc]
         initWithSpriteSheet:[self.textures getTexture:TextureIDCountdown]
         columns:2 rows:2 numFrames:4 horizontalOrder:YES timePerFrame:1];
    self.countdownTimer.position = CGPointZero;
    [self addNodeToLayer:LayerIDHUD node:self.countdownTimer];
    
    CGFloat const GAME_TIMER_REL_X = 0.0;
    CGFloat const Game_TIMER_REL_Y = 0.4;
    
    self.gameTime =
        [[SSKSpriteAnimationNode alloc]
         initWithSpriteSheet:[self.textures getTexture:TextureIDTimer] columns:5
         rows:6 numFrames:30 horizontalOrder:YES timePerFrame:1];
    self.gameTime.position = CGPointMake(
        [Coordinates convertXFromiPhone:IPHONE_LANDSCAPE_WIDTH_PTS * GAME_TIMER_REL_X
                    scalesForWidescreen:YES],
        [Coordinates convertYFromiPhone:IPHONE_LANDSCAPE_HEIGHT_PTS * Game_TIMER_REL_Y]);
    
    self.timeUp =
        [[SSKSpriteNode alloc] initWithTexture:[self.textures getTexture:TextureIDTimeUp]];
    self.timeUp.position = CGPointZero;
    
    CGFloat const PLAYER_ONE_SCORE_REL_X = -0.33;
    CGFloat const PLAYER_ONE_SCORE_REL_Y = 0.370625;
    
    self.playerOneScoreLabel = [SSKLabelNode labelNodeWithFontNamed:@"CurseCasualJVE"];
    self.playerOneScoreLabel.text = [NSString stringWithFormat:@"%d", self.playerOneScore.score];
    self.playerOneScoreLabel.fontSize = self.scene.frame.size.height * 0.1;
    self.playerOneScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    self.playerOneScoreLabel.position = CGPointMake(
        [Coordinates convertXFromiPhone:IPHONE_LANDSCAPE_WIDTH_PTS * PLAYER_ONE_SCORE_REL_X
                    scalesForWidescreen:YES],
        [Coordinates convertYFromiPhone:IPHONE_LANDSCAPE_HEIGHT_PTS * PLAYER_ONE_SCORE_REL_Y]);
    [self addNodeToLayer:LayerIDHUD node:self.playerOneScoreLabel];
    
    CGFloat const PLAYER_TWO_SCORE_REL_X = 0.33;
    CGFloat const PLAYER_TWO_SCORE_REL_Y = 0.370625;
    
    self.playerTwoScoreLabel = [SSKLabelNode labelNodeWithFontNamed:@"CurseCasualJVE"];
    self.playerTwoScoreLabel.text = [NSString stringWithFormat:@"%d", self.playerTwoScore.score];
    self.playerTwoScoreLabel.fontSize = self.scene.frame.size.height * 0.1;
    self.playerTwoScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    self.playerTwoScoreLabel.position = CGPointMake(
        [Coordinates convertXFromiPhone:IPHONE_LANDSCAPE_WIDTH_PTS * PLAYER_TWO_SCORE_REL_X
                    scalesForWidescreen:YES],
        [Coordinates convertYFromiPhone:IPHONE_LANDSCAPE_HEIGHT_PTS * PLAYER_TWO_SCORE_REL_Y]);
    [self addNodeToLayer:LayerIDHUD node:self.playerTwoScoreLabel];
    
    // Initialise players layer
    CGFloat const LEFT_PLAYER_REL_X = -0.341796875;
    CGFloat const LEFT_PLAYER_REL_Y = -0.2078645833;
    
    self.leftPlayer = [[KPPlayerNode alloc] initWithType:PlayerTypeLeft
                                                         textures:self.textures
                                                     timePerFrame:1.0/14.0];
    self.leftPlayer.audioDelegate = self.audioDelegate;
    self.leftPlayer.delegate = (id<KPPlayerSwipeHandler>)self;
    self.leftPlayer.position = CGPointMake(
        [Coordinates convertXFromiPhone:IPHONE_LANDSCAPE_WIDTH_PTS * LEFT_PLAYER_REL_X
                    scalesForWidescreen:NO],
        [Coordinates convertYFromiPhone:IPHONE_LANDSCAPE_HEIGHT_PTS * LEFT_PLAYER_REL_Y]);
    [self.leftPlayer animate];
    [self addNodeToLayer:LayerIDPlayers node:self.leftPlayer];
    
    [self.leftPlayer addObserver:self
                      forKeyPath:@"hidden"
                         options:NSKeyValueObservingOptionNew
                         context:NULL];
    
    self.leftPlayerThrow =
        [[KPPlayerAttackNode alloc]
         initWithSpriteSheet:[self.textures getTexture:TextureIDPlayerOneAttack]
         columns:7 rows:2 numFrames:12 horizontalOrder:YES timePerFrame:1.0/14.0];
    self.leftPlayerThrow.position = CGPointMake(
       [Coordinates convertXFromiPhone:IPHONE_LANDSCAPE_WIDTH_PTS * LEFT_PLAYER_REL_X
                   scalesForWidescreen:NO],
       [Coordinates convertYFromiPhone:IPHONE_LANDSCAPE_HEIGHT_PTS * LEFT_PLAYER_REL_Y]);
    [self addNodeToLayer:LayerIDPlayers node:self.leftPlayerThrow];
    self.leftPlayerThrow.hidden = YES;
    
    [self.leftPlayerThrow addObserver:self
                           forKeyPath:@"isAnimating"
                              options:NSKeyValueObservingOptionNew
                              context:NULL];
    
    CGFloat const RIGHT_PLAYER_REL_X = 0.341796875;
    CGFloat const RIGHT_PLAYER_REL_Y = -0.2078645833;
    
    self.rightPlayer = [[KPPlayerNode alloc] initWithType:PlayerTypeRight
                                                          textures:self.textures
                                                      timePerFrame:1.0/14.0];
    self.rightPlayer.audioDelegate = self.audioDelegate;
    self.rightPlayer.delegate = (id<KPPlayerSwipeHandler>)self;
    self.rightPlayer.position = CGPointMake(
        [Coordinates convertXFromiPhone:IPHONE_LANDSCAPE_WIDTH_PTS * RIGHT_PLAYER_REL_X
                    scalesForWidescreen:NO],
        [Coordinates convertYFromiPhone:IPHONE_LANDSCAPE_HEIGHT_PTS * RIGHT_PLAYER_REL_Y]);
    [self.rightPlayer animate];
    [self addNodeToLayer:LayerIDPlayers node:self.rightPlayer];
    
    [self.rightPlayer addObserver:self
                       forKeyPath:@"hidden"
                          options:NSKeyValueObservingOptionNew
                          context:NULL];
    
    self.rightPlayerThrow =
        [[KPPlayerAttackNode alloc]
         initWithSpriteSheet:[self.textures getTexture:TextureIDPlayerTwoAttack]
         columns:7 rows:2 numFrames:12 horizontalOrder:YES timePerFrame:1.0/14.0];
    self.rightPlayerThrow.position = CGPointMake(
        [Coordinates convertXFromiPhone:IPHONE_LANDSCAPE_WIDTH_PTS * RIGHT_PLAYER_REL_X
                    scalesForWidescreen:NO],
        [Coordinates convertYFromiPhone:IPHONE_LANDSCAPE_HEIGHT_PTS * RIGHT_PLAYER_REL_Y]);
    [self addNodeToLayer:LayerIDPlayers node:self.rightPlayerThrow];
    self.rightPlayerThrow.hidden = YES;
    
    [self.rightPlayerThrow addObserver:self
                            forKeyPath:@"isAnimating"
                               options:NSKeyValueObservingOptionNew
                               context:NULL];
    
    // Initialise scenery layer
    CGFloat const LEFT_GRASS_REL_X = -0.33203125;
    CGFloat const LEFT_GRASS_REL_Y = -0.4070833333;
    
    SSKSpriteNode* leftGrassTuft =
        [[SSKSpriteNode alloc]
         initWithTexture:[self.textures getTexture:TextureIDGrassTuftLeft]];
    leftGrassTuft.position = CGPointMake(
        [Coordinates convertXFromiPhone:IPHONE_LANDSCAPE_WIDTH_PTS * LEFT_GRASS_REL_X
                    scalesForWidescreen:NO],
        [Coordinates convertYFromiPhone:IPHONE_LANDSCAPE_HEIGHT_PTS * LEFT_GRASS_REL_Y]);
    [self addNodeToLayer:LayerIDScenery node:leftGrassTuft];
    
    CGFloat const RIGHT_GRASS_REL_X = 0.33203125;
    CGFloat const RIGHT_GRASS_REL_Y = -0.4070833333;
    
    SSKSpriteNode* rightGrassTuft =
        [[SSKSpriteNode alloc]
         initWithTexture:[self.textures getTexture:TextureIDGrassTuftRight]];
    rightGrassTuft.position = CGPointMake(
        [Coordinates convertXFromiPhone:IPHONE_LANDSCAPE_WIDTH_PTS * RIGHT_GRASS_REL_X
                    scalesForWidescreen:NO],
        [Coordinates convertYFromiPhone:IPHONE_LANDSCAPE_HEIGHT_PTS * RIGHT_GRASS_REL_Y]);
    [self addNodeToLayer:LayerIDScenery node:rightGrassTuft];
}

#pragma mark SKPhysicsContactDelegate

- (void)didBeginContact:(SKPhysicsContact *)contact {
    uint32_t bodyACategory = contact.bodyA.categoryBitMask;
    uint32_t bodyBCategory = contact.bodyB.categoryBitMask;
    
    // only handle collisions between appropriate nodes (targets and projectiles)
    if ((bodyACategory == ColliderTypeProjectile
                && bodyBCategory == ColliderTypeTarget)
        || (bodyACategory == ColliderTypeTarget
                && bodyBCategory == ColliderTypeProjectile)) {
            
            // determine the target and projectile in the collision
            id target;
            KPProjectileNode* projectile;
            ProjectileType projType;
            if (bodyACategory == ColliderTypeTarget) {
                target = contact.bodyA.node;
                projectile = (KPProjectileNode*)contact.bodyB.node;
                projType = projectile.type;
            } else {
                target = contact.bodyB.node;
                projectile = (KPProjectileNode*)contact.bodyA.node;
                projType = projectile.type;
            }
            
            // handle the collision
            if ([target isKindOfClass:[KPTargetNode class]]
                    && !((KPTargetNode*)target).collided) {
                KPTargetNode* node = (KPTargetNode*)target;
                node.collided = true;
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
                
                // remove the projectile from the scene graph
                if (projType == ProjectileTypeLeft) {
                    [self.poolManager addToPool:ResourcePoolIDLeftProjectile resource:projectile];
                } else {
                    [self.poolManager addToPool:ResourcePoolIDRightProjectile resource:projectile];
                }
                
                // display popping animation
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
    if (player) {
        self.rightPlayerThrowVector = vector;
        [self.rightPlayerThrow animateOnce];
    } else {
        self.leftPlayerThrowVector = vector;
        [self.leftPlayerThrow animateOnce];
    }
}

#pragma mark Helper Methods

- (void)addRemoveTargetActionToQueue {
    void (^checkOffScreen)(SKNode*, CFTimeInterval) =
    ^(SKNode* node, CFTimeInterval elapsedTime) {
        CGFloat maxX = self.scene.frame.size.width/2.0 + node.frame.size.width/2.0;
        CGFloat minX = -maxX;
        CGFloat maxY = self.scene.frame.size.height/2.0 + node.frame.size.height/2.0;
        CGFloat minY = -maxY - 300;
        
        if (node.position.x > maxX || node.position.x < minX) {
            [self garbageCollectNode:node];
        } else if (node.position.y > maxY || node.position.y < minY) {
            if (![node isKindOfClass:[KPProjectileNode class]]) {
                [self garbageCollectNode:node];
            }
        }
    };
    
    SSKAction *action =
        [[SSKAction alloc] initWithCategory:ActionCategoryProjectile | ActionCategoryTarget
                                     action:checkOffScreen];
    [self.actionQueue push:action];
}

- (void)garbageCollectNode:(SKNode*)node {
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

- (void)startCountdownTimer {
    [self runAction:self.countdownSoundAction];
    [self.countdownTimer animate];
}

- (void)setRandomSpawnLocation:(SKNode*)target {
    double const X_LOWER_BOUND_REL = -0.175 * self.scene.frame.size.width;
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
@synthesize leftPlayerThrow;
@synthesize leftPlayerThrowVector;
@synthesize leftProjectileThrown;
@synthesize rightPlayer;
@synthesize rightPlayerThrow;
@synthesize rightPlayerThrowVector;
@synthesize rightProjectileThrown;
@synthesize durationRemaining;

- (void)setIsActive:(BOOL)isActive {
    [super setIsActive:isActive];
    
    if (isActive) {
        self.scene.physicsWorld.speed = 1.0f;
    } else {
        self.scene.physicsWorld.speed = 0.0f;
    }
}

@end
