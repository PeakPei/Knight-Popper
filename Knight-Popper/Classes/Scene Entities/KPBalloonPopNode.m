/**
 * @filename KPBalloonPopNode.m
 * @author Morgan Wall
 * @date 11-11-2013
 */

#import "KPBalloonPopNode.h"
#import "KPActionCategories.h"
#import "TextureIDs.h"
#import <SpriteStackKit/SSKSpriteNode.h>

#pragma mark - Interface

@interface KPBalloonPopNode()

/**
 * @brief Retrieve the unique texture identifier associated with a specific
 * player type.
 *
 * @param type
 * The player type.
 *
 * @returns The unique texture identifier associated with the player type.
 */
+ (TextureID)textureIDForType:(PopType)type;

+ (TextureID)pointTextureIDForType:(PopType)type;

/**
 * @brief The category defining the actions handled by the node.
 */
@property ActionCategory category;

@end

#pragma mark - Implementation

@implementation KPBalloonPopNode

- (id)initWithType:(PopType)popType
          textures:(SSKTextureManager*)textures
      timePerFrame:(double)timePerFrame {
    
    unsigned int const COLUMNS = 3;
    unsigned int const ROWS = 2;
    unsigned int const NUM_FRAMES = 5;
    BOOL const HORIZONTAL_ORDER = YES;
    
    TextureID spriteSheetID = [KPBalloonPopNode textureIDForType:popType];
    
    if (self = [super initWithSpriteSheet:[textures getTexture:spriteSheetID]
                                  columns:COLUMNS
                                     rows:ROWS
                                numFrames:NUM_FRAMES
                          horizontalOrder:HORIZONTAL_ORDER
                             timePerFrame:timePerFrame]) {
        _type = popType;
        
        SSKSpriteNode* points =
            [[SSKSpriteNode alloc] initWithTexture:[textures
             getTexture:[KPBalloonPopNode pointTextureIDForType:popType]]];
        points.anchorPoint = CGPointMake(1, 1);
        points.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addChild:points];
    }
    
    return self;
}

+ (TextureID)textureIDForType:(PopType)type {
    TextureID identifier;
    
    switch (type) {
        case PopTypePink:
            identifier = TextureIDPinkPop;
            break;
            
        case PopTypeBlue:
            identifier = TextureIDBluePop;
            break;
            
        case PopTypeGold:
            identifier = TextureIDGoldPop;
            break;
    }
    
    return identifier;
}

+ (TextureID)pointTextureIDForType:(PopType)type {
    TextureID identifier;
    
    switch (type) {
        case PopTypePink:
            identifier = TextureIDPointsPink;
            break;
            
        case PopTypeBlue:
            identifier = TextureIDPointsBlue;
            break;
            
        case PopTypeGold:
            identifier = TextureIDPointsGold;
            break;
    }
    
    return identifier;
}

#pragma mark SSKSpriteNode

- (unsigned int)getActionCategory {
    return ActionCategoryNone;
}

#pragma mark - Properties

@synthesize type = _type;
@synthesize category;

@end