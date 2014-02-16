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

- (void)touchFinished;

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

/**
 * @brief Indicates whether the node is touched (true) or not (false).
 */
@property BOOL isTouched;

/**
 * @brief The initial position touched in a touch event involving the node.
 */
@property CGPoint touchBegin;

/**
 * @brief The last position touched in a touch event involving the node.
 */
@property CGPoint touchEnd;

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
        self.isTouched = NO;
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

#pragma mark Helper Methods

- (void)touchFinished {
    CGVector throwArc = CGVectorMake(self.touchEnd.x - self.touchBegin.x,
                                    self.touchEnd.y - self.touchBegin.y);
    [self.delegate handleThrow:throwArc player:self.type];
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
        self.isTouched = YES;
        self.touchBegin = touchLocation;
        eventHandled = YES;
    }
    
    return eventHandled;
}

- (BOOL)handleMoveEvent:(UIEvent *)event touch:(UITouch *)touch {
    BOOL eventHandled = NO;
    CGPoint touchLocation = [touch locationInNode:[self parent]];
    CGPoint previousTouchLocation = [touch previousLocationInNode:[self parent]];
    
    if ([self containsPoint:previousTouchLocation]
            && ![self containsPoint:touchLocation] && self.isTouched) {
        self.isTouched = NO;
        self.touchEnd = touchLocation;
        [self touchFinished];
        eventHandled = YES;
    }
    
    return eventHandled;
}

- (BOOL)handleEndEvent:(UIEvent *)event touch:(UITouch *)touch {
    BOOL eventHandled = NO;
    CGPoint touchLocation = [touch locationInNode:[self parent]];
    
    if ([self containsPoint:touchLocation] && self.isTouched) {
        self.isTouched = NO;
        self.touchEnd = touchLocation;
        [self touchFinished];
        eventHandled = YES;
    }
    
    return eventHandled;
}

- (BOOL)handleCancelEvent:(UIEvent *)event touch:(UITouch *)touch {
    BOOL eventHandled = NO;
    CGPoint touchLocation = [touch locationInNode:[self parent]];
    
    if ([self containsPoint:touchLocation] && self.isTouched) {
        self.isTouched = NO;
        eventHandled = YES;
    }
    
    return eventHandled;
}

#pragma mark - Properties

@synthesize type = _type;
@synthesize category;
@synthesize delegate;
@synthesize isTouched;
@synthesize touchBegin;
@synthesize touchEnd;

@end