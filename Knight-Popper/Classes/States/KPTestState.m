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
     initWithTexture:[self.textures getTexture:TextureIDBackground]
     state:NULL audioDelegate:self.audioDelegate];
    background.position = CGPointZero;
    [self addNodeToLayer:LayerIDBackground node:background];
    
    // Initialise test layer
    KPShapeAnimationNode* lollipop =
        [[KPShapeAnimationNode alloc]
         initWithSpriteSheet:[self.textures getTexture:TextureIDLollipopLeftProjectile]
         state:self audioDelegate:self.audioDelegate columns:3 rows:3 numFrames:8
         horizontalOrder:YES timePerFrame:1];
    lollipop.position = CGPointZero;
    
    NSMutableArray* paths = [[NSMutableArray alloc] initWithCapacity:8];
    
    int totalFrames = 8;
    int addedFrames = 0;
    for (int i = 1; i <= 3 && addedFrames < totalFrames; i++) {
        for (int j = 1; j <= 3 && addedFrames < totalFrames; j++) {
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, nil, 0, 0);
            
            NSString* xName =
                [NSString stringWithFormat:@"%@%d%d", @"lollipop_left_projectile_x_", i, j];
            NSString* yName =
                [NSString stringWithFormat:@"%@%d%d", @"lollipop_left_projectile_y_", i, j];
            
            NSString* xPath =
                [[NSBundle mainBundle] pathForResource:xName ofType:@"plist"];
            NSString* yPath =
                [[NSBundle mainBundle] pathForResource:yName ofType:@"plist"];
            
            NSArray* xValues =
            [[NSArray alloc] initWithContentsOfFile:xPath];
            NSArray* yValues =
            [[NSArray alloc] initWithContentsOfFile:yPath];
            
            for (int i = 0; i < xValues.count; i++) {
                CGPathAddLineToPoint(path, nil,
                                     [xValues[i] doubleValue] * lollipop.frame.size.width,
                                     [yValues[i] doubleValue] * lollipop.frame.size.height);
            }
            
            CGPathAddLineToPoint(path, nil,
                                 [xValues[0] doubleValue] * lollipop.frame.size.width,
                                 [yValues[0] doubleValue] * lollipop.frame.size.height);
            
            paths[addedFrames++] = (__bridge id)(path);
        }
    }
    
    [lollipop setHitboxPaths:paths];
    
    [self addNodeToLayer:LayerIDTest node:lollipop];
    [lollipop animate];
}

@end
