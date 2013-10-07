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

- (void)addPositionDisplayActionToQueue;

- (void)addTargetMoveActionToQueue;

@property SSKActionQueue* actionQueue;

@property NSMutableDictionary* sceneLayers;

@end

#pragma mark - Implementation

@implementation KPStandardGameState

- (id)initWithStateStack:(SSKStateStack *)stateStack
          textureManager:(SSKTextureManager *)textureManager {
    if (self = [super initWithStateStack:stateStack textureManager:textureManager]) {
        self.actionQueue = [[SSKActionQueue alloc] init];
        self.sceneLayers = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark HHState

- (void)update:(CFTimeInterval)deltaTime {
    if (self.isActive) {
        [self addPositionDisplayActionToQueue];
        [self addTargetMoveActionToQueue];
        
        while (![self.actionQueue isEmpty]) {
            [self onAction:[self.actionQueue pop]];
        }
    }
}

- (void)buildState {
    KPSpriteNode* background = [[KPSpriteNode alloc] initWithTexture:
                                 [self.textures getTexture:TextureIDBackground]];
    background.position = CGPointZero;
    
    KPSpriteNode* leftGrassTuft = [[KPSpriteNode alloc] initWithTexture:
                                    [self.textures getTexture:TextureIDGrassTuftLeft]];
    leftGrassTuft.position = CGPointMake(-50, -50);
    
    KPSpriteNode* rightGrassTuft = [[KPSpriteNode alloc] initWithTexture:
                                     [self.textures getTexture:TextureIDGrassTuftRight]];
    rightGrassTuft.position = CGPointMake(50, -50);
    
    KPSpriteNode* pinkMonkeyHUD = [[KPSpriteNode alloc] initWithTexture:
                                    [self.textures getTexture:TextureIDPinkMonkeyHUD]];
    pinkMonkeyHUD.position = CGPointMake(300, 300);
    
    KPSpriteNode* blueMonkeyHUD = [[KPSpriteNode alloc] initWithTexture:
                                    [self.textures getTexture:TextureIDBlueMonkeyHUD]];
    blueMonkeyHUD.position = CGPointMake(-300, 300);
    
    KPTargetNode* target = [[KPTargetNode alloc] initWithType:TargetTypeBlueMonkey
                                                     textures:self.textures];
    target.position = CGPointZero;
    
    [self addChild:background];
    [self addChild:pinkMonkeyHUD];
    [self addChild:blueMonkeyHUD];
    [self addChild:leftGrassTuft];
    [self addChild:rightGrassTuft];
    [self addChild:target];
}

#pragma mark Helper Methods

- (void)addPositionDisplayActionToQueue {
    void (^garbageAction)(SKNode*, CGFloat) = ^(SKNode* node, CGFloat elapsedTime) {
        NSLog(@"X: %f Y: %f", node.position.x, node.position.y);
    };
    
    SSKAction *action = [[SSKAction alloc] initWithCategory:ActionCategoryTarget
                                              actionBlock:garbageAction
                                             timeInterval:0];
    [self.actionQueue push:action];
}

- (void)addTargetMoveActionToQueue {
    SKAction *moveAction = [SKAction moveByX:3 y:3 duration:0];
    SSKAction *action = [[SSKAction alloc] initWithCategory:ActionCategoryTarget
                                                   action:moveAction];
    [self.actionQueue push:action];
}

#pragma mark - Properties

@synthesize actionQueue;
@synthesize sceneLayers;

@end
