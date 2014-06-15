/**
 * @filename KPMainMenuState.m
 * @author Morgan Wall
 * @date 16-10-2013
 */

#import "KPMainMenuState.h"
#import "KPTargetNode.h"
#import "KPActionCategories.h"
#import "TextureIDs.h"
#import "StateIDs.h"
#import "SoundIDs.h"
#import "SoundInstanceIDs.h"
#import <SpriteStackKit/SSKSpriteNode.h>
#import <SpriteStackKit/SSKAction.h>
#import <SpriteStackKit/SSKActionQueue.h>
#import <SpriteStackKit/SSKSpriteAnimationNode.h>
#import <SpriteStackKit/SSKButtonNode.h>
#import "Coordinates.h"
#import <SpriteStackKit/SSKResourcePoolManager.h>
#import "KPProjectileNode.h"
#import "Random.h"

#pragma mark - Interface

@interface KPMainMenuState ()

typedef enum layers {
    LayerIDBackground = 0,
    LayerIDProjectiles,
    LAyerIDTitle,
    LayerIDHUD
} LayerID;

typedef enum resourcePools {
    ResourcePoolIDProjectile = 0
} ResourcePoolID;

- (void)setProjectileLocation:(SKNode*)node;

@property SSKActionQueue* actionQueue;

@property SSKResourcePoolManager* poolManager;

@property CFTimeInterval timeLastGeneration;

@end

#pragma mark - Implementation

@implementation KPMainMenuState

- (id)initWithStateStack:(SSKStateStack *)stateStack
          textureManager:(SSKTextureManager *)textureManager
           audioDelegate:(id<SSKAudioManagerDelegate>)delegate
                    data:(NSDictionary *)data{
    unsigned int layerCount = 4;
    if (self = [super initWithStateStack:stateStack
                          textureManager:textureManager
                           audioDelegate:delegate
                                    data:data
                              layerCount:layerCount]) {
        self.actionQueue = [[SSKActionQueue alloc] init];
        self.poolManager = [[SSKResourcePoolManager alloc] initWithCapacity:1];
    }
    return self;
}

#pragma mark SSKState

- (void)updateState:(CFTimeInterval)deltaTime {
    if (self.isActive) {
        if (self.timeLastGeneration >= 3) {
            self.timeLastGeneration = 0;
            [self.poolManager retrieveFromPool:ResourcePoolIDProjectile];
        } else {
            self.timeLastGeneration += deltaTime;
        }
        
        [self addRemoveTargetActionToQueue];
        
        while (![self.actionQueue isEmpty]) {
            [self onAction:[self.actionQueue pop] deltaTime:deltaTime];
        }
    }
}

- (void)buildState {
    // Initialise projectile pool
    void (^projectileAdd)(id) = ^(id node) {
        SSKSpriteNode* resource = (SSKSpriteNode*)node;
        resource.physicsBody.resting = YES;
        [resource removeFromParent];
    };
    
    void (^projectileGet)(id) = ^(id node) {
        KPTargetNode* resource = (KPTargetNode*)node;
        [self setProjectileLocation:resource];
        [self addNodeToLayer:LayerIDProjectiles node:resource];
        
        CGFloat vectorLength =
            sqrt(pow(resource.position.x, 2) + pow(resource.position.y, 2));
        CGVector unitVectorToOrigin = CGVectorMake(-resource.position.x / vectorLength,
                                                   -resource.position.y / vectorLength);
        
        [resource.physicsBody applyForce:CGVectorMake(
              unitVectorToOrigin.dx * self.scene.frame.size.height,
              unitVectorToOrigin.dy * self.scene.frame.size.height)];
        resource.physicsBody.angularVelocity =
            [Random generateDouble:-5 upperBound:5];
        resource.physicsBody.angularDamping =
            [Random generateDouble:0.05 upperBound:0.4];
        resource.physicsBody.linearDamping = 0.0;
    };
    
    [self.poolManager addResourcePool:5
                         resourceType:[KPProjectileNode class]
                            addAction:projectileAdd
                            getAction:projectileGet
                       poolIdentifier:ResourcePoolIDProjectile];
    
    for (int i = 0; i < 15; i++) {
        KPProjectileNode* node =
            [[KPProjectileNode alloc] initWithType:ProjectileTypeLeft textures:self.textures];
        [self.poolManager addToPool:ResourcePoolIDProjectile resource:node];
    }
    
    // Initialise background layer
    SSKSpriteNode* background =
        [[SSKSpriteNode alloc]
         initWithTexture:[self.textures getTexture:TextureIDMainMenuBackground]];
    background.position = CGPointZero;
    [self addNodeToLayer:LayerIDBackground node:background];
    
    // Initialise HUD layer
    CGFloat const TITLE_REL_X = 0;
    CGFloat const TITLE_REL_Y = 0.1302083333;
    
    SSKSpriteNode* title =
        [[SSKSpriteNode alloc]
         initWithTexture:[self.textures getTexture:TextureIDMainMenuTitle]];
    title.position = CGPointMake(
        [Coordinates convertXFromiPhone:IPHONE_LANDSCAPE_WIDTH_PTS * TITLE_REL_X
                    scalesForWidescreen:YES],
        [Coordinates convertYFromiPhone:IPHONE_LANDSCAPE_HEIGHT_PTS * TITLE_REL_Y]);
    [self addNodeToLayer:LAyerIDTitle node:title];
    
    CGFloat const PLAY_REL_X = 0;
    CGFloat const PLAY_REL_Y = -0.3255208333;
    
    SSKButtonNode* playButton =
        [[SSKButtonNode alloc]
         initWithDefaultTexture:[self.textures getTexture:TextureIDPlayButton]
         pressedTexture:[self.textures getTexture:TextureIDPlayButtonHover]
         beginPressBlock:NULL
         endPressBlock:^(SSKButtonNode* node) {
             [node.audioDelegate playSound:SoundIDForwardPress];
             [node.state requestStackClear];
             [node.state requestStackPush:StateIDLoading data:NULL];
         }];
    playButton.audioDelegate = self.audioDelegate;
    playButton.position = CGPointMake(
        [Coordinates convertXFromiPhone:IPHONE_LANDSCAPE_WIDTH_PTS * PLAY_REL_X
                    scalesForWidescreen:YES],
        [Coordinates convertYFromiPhone:IPHONE_LANDSCAPE_HEIGHT_PTS * PLAY_REL_Y]);
    [self addNodeToLayer:LayerIDHUD node:playButton];
    
    CGFloat const ABOUT_REL_X = -0.406494;
    CGFloat const ABOUT_REL_Y = -0.3515625;
    
    SSKButtonNode* aboutButton =
        [[SSKButtonNode alloc]
         initWithDefaultTexture:[self.textures getTexture:TextureIDAboutButton]
         pressedTexture:[self.textures getTexture:TextureIDAboutButtonHover]
         beginPressBlock:NULL
         endPressBlock:^(SSKButtonNode* node) {
             self.isActive = NO;
             [node.audioDelegate playSound:SoundIDForwardPress];
             [node.state requestStackPush:StateIDCredits data:NULL];
         }];
    aboutButton.audioDelegate = self.audioDelegate;
    aboutButton.position = CGPointMake(
        [Coordinates convertXFromiPhone:IPHONE_LANDSCAPE_WIDTH_PTS * ABOUT_REL_X
                    scalesForWidescreen:YES],
        [Coordinates convertYFromiPhone:IPHONE_LANDSCAPE_HEIGHT_PTS * ABOUT_REL_Y]);
    [self addNodeToLayer:LayerIDHUD node:aboutButton];
    
    [self.audioDelegate playSound:SoundIDMenuMusic
                        loopCount:-1
                       instanceId:SoundInstanceIDMenuMusic];
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
            
            if ([node isKindOfClass:[KPProjectileNode class]]) {
                [self.poolManager addToPool:ResourcePoolIDProjectile resource:node];
            }
            
            [node destroy];
        }
    };
    
    SSKAction *action =
        [[SSKAction alloc] initWithCategory:ActionCategoryProjectile
                                     action:checkOffScreen];
    [self.actionQueue push:action];
}

- (void)setProjectileLocation:(SKNode*)node {
    CGPoint location;
    
    double const MAX_X = self.scene.frame.size.width/2.0 + node.frame.size.width/2.0;
    double const MIN_X = -MAX_X;
    
    double const MAX_Y = self.scene.frame.size.height/2.0 + node.frame.size.height/2.0;
    double const MIN_Y = -MAX_Y;
    
    double randomNumber = [Random generateDouble:0.0 upperBound:1.0];
    if (randomNumber < 0.25) {
        location.x = MAX_X;
        location.y = [Random generateDouble:MIN_Y upperBound:MAX_Y];
    } else if (randomNumber < 0.5) {
        location.x = MIN_X;
        location.y = [Random generateDouble:MIN_Y upperBound:MAX_Y];
    } else if (randomNumber < 0.75) {
        location.x = [Random generateDouble:MIN_X upperBound:MAX_X];
        location.y = MAX_Y;
    } else {
        location.x = [Random generateDouble:MIN_X upperBound:MAX_X];
        location.y = MIN_Y;
    }
    
    node.position = location;
}

#pragma mark - Properties

@synthesize actionQueue;
@synthesize poolManager;
@synthesize timeLastGeneration;

@end
