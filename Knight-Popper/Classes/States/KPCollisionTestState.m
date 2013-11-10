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
    [self addNodeToLayer:LayerIDTestLower node:lower];
    [lower.physicsBody applyForce:CGVectorMake(100, 0)];
    [lower animate];
    
    KPTestProjNode* upper =
        [[KPTestProjNode alloc] initWithTexture:[self.textures getTexture:TextureIDGiantLollipop]];
    upper.position = CGPointMake(300, 0.0);
    [self addNodeToLayer:LayerIDTestUpper node:upper];
    [upper.physicsBody applyForce:CGVectorMake(-100, 0)];
}

@end
