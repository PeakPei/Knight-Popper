/**
 * @filename KPTestState.m
 * @author Morgan Wall
 * @date 7-11-2013
 */

#import "KPTestState.h"
#import <SpriteStackKit/SSKSpriteNode.h>
#import <SpriteStackKit/SSKShapeNode.h>
#import "TextureIDs.h"
#import "KPShapeNode.h"

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
    SSKSpriteNode* lollipop =
    [[SSKSpriteNode alloc]
     initWithTexture:[self.textures getTexture:TextureIDGiantLollipop]
     state:self audioDelegate:self.audioDelegate];
    lollipop.position = CGPointZero;
    
    KPShapeNode* lollipopHitbox =
    [[KPShapeNode alloc] initWithAudioDelegate:self.audioDelegate];
    lollipopHitbox.position = CGPointZero;
    [lollipop addChild:lollipopHitbox];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 0, 0);
    
    NSString* xPath = [[NSBundle mainBundle] pathForResource:@"giant_lollipop_x" ofType:@"plist"];
    NSString* yPath = [[NSBundle mainBundle] pathForResource:@"giant_lollipop_y" ofType:@"plist"];
    
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
    
    lollipopHitbox.path = path;
    lollipopHitbox.fillColor = [UIColor redColor];
    
    [self addNodeToLayer:LayerIDTest node:lollipop];
}

@end
