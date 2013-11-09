/**
 * @filename KPTestState.m
 * @author Morgan Wall
 * @date 7-11-2013
 */

#import "KPTestState.h"
#import <SpriteStackKit/SSKSpriteNode.h>
#import <SpriteStackKit/SSKShapeNode.h>
#import <SpriteStackKit/SSKSpriteAnimationNode.h>
#import "TextureIDs.h"
#import "KPShapeNode.h"
#import "KPShapeAnimationNode.h"
#import "PathParser.h"

#pragma mark - Interface

@interface KPTestState()

typedef enum layers {
    LayerIDBackground = 0,
    LayerIDTest
} LayerID;

@end

#pragma mark - Implementation

#import "KPTestState.h"

@implementation KPTestState

- (id)initWithStateStack:(SSKStateStack *)stateStack
          textureManager:(SSKTextureManager *)textureManager
           audioDelegate:(id<SSKAudioManagerDelegate>)delegate {
    unsigned int const LAYER_COUNT = 2;
    if (self = [super initWithStateStack:stateStack
                          textureManager:textureManager
                           audioDelegate:delegate
                              layerCount:LAYER_COUNT]) {
        // stub
    }
    return self;
}

- (void)update:(CFTimeInterval)deltaTime {
    // stub
}

- (void)buildState {
    // Initialise background layer
    SSKSpriteNode* background =
        [[SSKSpriteNode alloc]
         initWithTexture:[self.textures getTexture:TextureIDBackground]];
    background.position = CGPointZero;
    [self addNodeToLayer:LayerIDBackground node:background];
    
    // Initialise test layer
    KPShapeNode* giantLollipop =
        [[KPShapeNode alloc]
         initWithTexture:[self.textures getTexture:TextureIDGiantLollipop] color:[UIColor greenColor] size:[self.textures getTexture:TextureIDGiantLollipop].size];
    NSArray* test = [PathParser parsePaths:@"giant_lollipop"
                                        columns:1 rows:1 numFrames:1
                                      horizontalOrder:YES width:giantLollipop.frame.size.width
                                               height:giantLollipop.frame.size.height];
    giantLollipop.hitboxPath = (__bridge CGPathRef)(test[0]);
    [self addNodeToLayer:LayerIDTest node:giantLollipop];
    [giantLollipop runAction:[SKAction rotateByAngle:3 duration:10]];
    
    KPShapeAnimationNode* lollipop =
        [[KPShapeAnimationNode alloc]
         initWithSpriteSheet:[self.textures getTexture:TextureIDLollipopLeftProjectile]
         columns:3 rows:3 numFrames:8 horizontalOrder:YES timePerFrame:4];
    lollipop.position = CGPointZero;
    
    NSLog(@"%f", lollipop.frame.size.width);
    NSLog(@"%f", lollipop.frame.size.height);
    
    NSArray* paths =
        [PathParser parsePaths:@"lollipop_left_projectile"
         columns:3 rows:3 numFrames:8 horizontalOrder:YES
         width:lollipop.frame.size.width height:lollipop.frame.size.height];
    
    [lollipop setHitboxPaths:paths];
    
    [self addNodeToLayer:LayerIDTest node:lollipop];
    [lollipop animate];
}

@end
