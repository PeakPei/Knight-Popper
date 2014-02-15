/**
 * @filename KPPlayerNode.m
 * @author Morgan Wall
 * @date 10-11-2013
 */

#import "KPPlayerNode.h"
#import "KPActionCategories.h"
#import "TextureIDs.h"
#import "KPProjectileNode.h"

#pragma mark - Interface

@interface KPPlayerNode()

/**
 * @brief Retrieve the unique texture identifier associated with a specific
 * player type.
 *
 * @param type
 * The player type.
 *
 * @returns The unique texture identifier associated with the player type.
 */
+ (TextureID)textureIDForType:(PlayerType)type;

/**
 * @brief The category defining the actions handled by the node.
 */
@property ActionCategory category;

@property SSKTextureManager* textureManager;

@end

#pragma mark - Implementation

@implementation KPPlayerNode

- (id)initWithType:(PlayerType)playerType
          textures:(SSKTextureManager*)textures
      timePerFrame:(double)timePerFrame {
    
    unsigned int const COLUMNS = 7;
    unsigned int const ROWS = 3;
    unsigned int const NUM_FRAMES = 20;
    BOOL const HORIZONTAL_ORDER = YES;
    
    TextureID spriteSheetID = [KPPlayerNode textureIDForType:playerType];
    
    if (self = [super initWithSpriteSheet:[textures getTexture:spriteSheetID]
                                  columns:COLUMNS
                                     rows:ROWS
                                numFrames:NUM_FRAMES
                          horizontalOrder:HORIZONTAL_ORDER
                             timePerFrame:timePerFrame]) {
        _type = playerType;
        self.textureManager = textures;
    }
    
    return self;
}

+ (TextureID)textureIDForType:(PlayerType)type {
    TextureID identifier;
    
    switch (type) {
        case PlayerTypeLeft:
            identifier = TextureIDPlayerOneIdle;
            break;
            
        case PlayerTypeRight:
            identifier = TextureIDPlayerTwoIdle;
            break;
    }
    
    return identifier;
}

#pragma mark SSKSpriteNode

- (unsigned int)getActionCategory {
    return ActionCategoryNone;
}

#pragma mark SSKEventHandler

- (BOOL)handleBeginEvent:(UIEvent*)event touch:(UITouch *)touch {
    BOOL eventHandled = NO;
    CGPoint touchLocation = [touch locationInNode:[self parent]];
    
    if ([self containsPoint:touchLocation]) {
        touchLocation = [touch locationInNode:self];
        CGVector arc = CGVectorMake(touchLocation.x, touchLocation.y);
        [self.delegate handleThrow:arc player:self.type];
        eventHandled = YES;
    }
    
    return eventHandled;
}

#pragma mark - Properties

@synthesize textureManager;
@synthesize type = _type;
@synthesize category;
@synthesize delegate;

@end