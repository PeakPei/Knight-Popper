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

/**
 * @brief The UITouch object associated with the current touch interaction
 * on the player. 
 *
 * @note A UITouch object is persistent throughout a touch interaction. This
 * property is null if there is no current touch interaction on the player.
 */
@property UITouch* currentTouch;

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
        self.isActive = YES;
        self.currentTouch = NULL;
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

#pragma mark SSKEventProtocol

- (BOOL)handleBeginEvent:(UIEvent*)event touch:(UITouch *)touch {
    BOOL eventHandled = NO;
    CGPoint touchLocation = [touch locationInNode:[self parent]];
    
    if (self.isActive && [self containsPoint:touchLocation]) {
        [self touchBegan:event touch:touch];
        eventHandled = YES;
    }
    
    return eventHandled;
}

- (BOOL)handleMoveEvent:(UIEvent *)event touch:(UITouch *)touch {
    BOOL eventHandled = NO;
    CGPoint touchLocation = [touch locationInNode:[self parent]];
//    CGPoint previousTouchLocation = [touch previousLocationInNode:[self parent]];
    
    // handle touch event
    if (self.isActive) {
        
        // handle new touch
        if (!self.currentTouch && [self containsPoint:touchLocation]) {
            [self touchBegan:event touch:touch];
            eventHandled = YES;
            
        // handle existing touch
        } else if (self.currentTouch == touch) {
            
            if ([self containsPoint:touchLocation]) {
                // ongoing touch handling (stub)
            } else {
                [self touchEnded:event touch:touch];
            }
            eventHandled = YES;
        }
    }
    
    return eventHandled;
}

- (BOOL)handleEndEvent:(UIEvent *)event touch:(UITouch *)touch {
    return [self handleTouchEnd:event touch:touch];
}

- (BOOL)handleCancelEvent:(UIEvent *)event touch:(UITouch *)touch {
    return [self handleTouchEnd:event touch:touch];
}

#pragma mark Helper Methods

- (BOOL)handleTouchEnd:(UIEvent*)event touch:(UITouch*)touch {
    BOOL eventHandled = NO;
    
    if (self.isActive && self.currentTouch == touch) {
        [self touchEnded:event touch:touch];
        eventHandled = YES;
    }
    
    return eventHandled;
}

- (void)touchBegan:(UIEvent*)event touch:(UITouch*) touch {
    self.currentTouch = touch;
    self.touchBegin = [touch locationInNode:[self parent]];
}

- (void)touchEnded:(UIEvent*)event touch:(UITouch*)touch {
    self.currentTouch = NULL;
    self.touchEnd = [touch locationInNode:[self parent]];
    
    CGVector throwArc = CGVectorMake(self.touchEnd.x - self.touchBegin.x,
                                     self.touchEnd.y - self.touchBegin.y);
    [self.delegate handleThrow:throwArc player:self.type];
}

#pragma mark - Properties

@synthesize type = _type;
@synthesize category;
@synthesize delegate;
@synthesize touchBegin;
@synthesize touchEnd;
@synthesize isActive = _isActive;

- (void)setIsActive:(BOOL)isActive {
    _isActive = isActive;
    self.currentTouch = NULL;
}

@end