//
//  KPCollisionTestState.m
//  Knight-Popper
//
//  Created by Morgan on 10/11/2013.
//  Copyright (c) 2013 QUT. All rights reserved.
//

#import "KPCollisionTestState.h"
#import "KPTestTargetNode.h"
#import "KPTestProjectileNode.h"
#import "TextureIDs.h"
#import "ColliderTypes.h"
#import "SoundIDs.h"
#import "KPTestProjNode.h"
#import "PathParser.h"

#pragma mark - Interface

@interface KPCollisionTestState()

typedef enum layers {
    LayerIDTestLower = 0,
    LayerIDTestUpper
} LayerID;

@end

#pragma mark - Implementation

@implementation KPCollisionTestState

- (id)initWithStateStack:(SSKStateStack *)stateStack
          textureManager:(SSKTextureManager *)textureManager
           audioDelegate:(id<SSKAudioManagerDelegate>)delegate
                    data:(NSDictionary*)data {
    unsigned int layerCount = 2;
    if (self = [super initWithStateStack:stateStack
                          textureManager:textureManager
                           audioDelegate:delegate
                                    data:data
                              layerCount:layerCount]) {
    }
    return self;
}

#pragma mark SSKState

- (void)update:(CFTimeInterval)deltaTime {
}

- (void)buildState {
    KPTestTargetNode* lower =
    [[KPTestTargetNode alloc]
     initWithSpriteSheet:[self.textures getTexture:TextureIDGoldMonkeyTarget]
     columns:8 rows:3 numFrames:20 horizontalOrder:YES timePerFrame:1.0/14.0];
    lower.position = CGPointMake(-300, 0.0);
    
    NSArray* pathsGold = [PathParser parsePaths:@"blue_gold_monkeys" columns:1 rows:1
                                  numFrames:1 horizontalOrder:YES width:lower.frame.size.width
                                     height:lower.frame.size.height];
    
    SKPhysicsBody* physicsBodyGold =
    [SKPhysicsBody bodyWithPolygonFromPath:(__bridge CGPathRef)(pathsGold[0])];
    physicsBodyGold.dynamic = YES;
    physicsBodyGold.affectedByGravity = NO;
    physicsBodyGold.usesPreciseCollisionDetection = YES;
    physicsBodyGold.categoryBitMask = ColliderTypeTarget;
    physicsBodyGold.contactTestBitMask = ColliderTypeProjectile;
    [lower setPhysicsBody:physicsBodyGold];
    
    [self addNodeToLayer:LayerIDTestLower node:lower];
    [lower.physicsBody applyForce:CGVectorMake(100, 0)];
    
    KPTestProjectileNode* upper =
        [[KPTestProjectileNode alloc]
         initWithSpriteSheet:[self.textures getTexture:TextureIDLollipopLeftProjectile]
         columns:3 rows:3 numFrames:8 horizontalOrder:YES timePerFrame:1.0/14.0];
    upper.position = CGPointMake(300, -1);
    
    NSArray* paths = [PathParser parsePaths:@"lollipop_left_projectile" columns:1 rows:1
                      numFrames:1 horizontalOrder:YES width:upper.frame.size.width
                      height:upper.frame.size.height];
    
    SKPhysicsBody* physicsBody =
    [SKPhysicsBody bodyWithPolygonFromPath:(__bridge CGPathRef)(paths[0])];
    physicsBody.dynamic = YES;
    physicsBody.affectedByGravity = NO;
    physicsBody.usesPreciseCollisionDetection = YES;
    physicsBody.categoryBitMask = ColliderTypeProjectile;
    physicsBody.contactTestBitMask = ColliderTypeTarget;
    [upper setPhysicsBody:physicsBody];
    
    [self addNodeToLayer:LayerIDTestUpper node:upper];
    [upper.physicsBody applyForce:CGVectorMake(-100, 0)];
}

@end
