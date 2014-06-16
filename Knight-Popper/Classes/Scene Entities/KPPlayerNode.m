/**
 * @filename KPPlayerNode.m
 * @author Morgan Wall
 * @date 10-11-2013
 */

#import "KPPlayerNode.h"
#import "KPActionCategories.h"
#import "TextureIDs.h"
#import "KPProjectileNode.h"

#define INITIAL_TOUCH_DURATION 0.01f
#define INITIAL_TOUCH_DISTANCE 0.0f

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

/**
 * @brief The duration of the current touch.
 */
@property NSTimeInterval touchDuration;

/**
 * @brief The distance covered by the current touch.
 */
@property float touchDistance;

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
        self.touchDuration = INITIAL_TOUCH_DURATION;
        self.touchDistance = INITIAL_TOUCH_DISTANCE;
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

#pragma mark SSKUpdateProtocol

- (void)update:(CFTimeInterval)deltaTime {
    if (!self.currentTouch) {
        self.touchDuration += deltaTime;
    }
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
    
    // handle touch event
    if (self.isActive) {
        
        // handle new touch
        if (!self.currentTouch && [self containsPoint:touchLocation]) {
            [self touchBegan:event touch:touch];
            eventHandled = YES;
            
        // handle existing touch
        } else if (self.currentTouch == touch) {
            [self updateCurrentTouchDistance:touch];
            
            if ([self containsPoint:touchLocation]) {
                // stub
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
        [self updateCurrentTouchDistance:touch];
        [self touchEnded:event touch:touch];
        eventHandled = YES;
    }
    
    return eventHandled;
}

- (void)touchBegan:(UIEvent*)event touch:(UITouch*) touch {
    self.touchDuration = INITIAL_TOUCH_DURATION;
    self.touchDistance = INITIAL_TOUCH_DISTANCE;
    
    self.currentTouch = touch;
    self.touchBegin = [touch locationInNode:[self parent]];
}

- (void)touchEnded:(UIEvent*)event touch:(UITouch*)touch {
    self.currentTouch = NULL;
    self.touchEnd = [touch locationInNode:[self parent]];
    
    // determine throw force
    float const MIN_THROW_MAGNITUDE = 200.0f;
    float const MAX_THROW_MAGNITUDE = 575.0f;
    float const FORCE_COEF = 0.025f;
    
    float swipeSpeed = self.touchDistance / self.touchDuration;
    
    float throwMagnitude = swipeSpeed * FORCE_COEF;
    if (throwMagnitude > MAX_THROW_MAGNITUDE) {
        throwMagnitude = MAX_THROW_MAGNITUDE;
        NSLog(@"Max");
    } else if (throwMagnitude < MIN_THROW_MAGNITUDE) {
        throwMagnitude = MIN_THROW_MAGNITUDE;
        NSLog(@"Min");
    }
    
    NSLog(@"Speed: %f", throwMagnitude);
    
    // apply impulse force
    CGVector swipeVector = CGVectorMake(self.touchEnd.x - self.touchBegin.x,
                                        self.touchEnd.y - self.touchBegin.y);
    CGVector impulseForce = [KPPlayerNode CGVectorNormalise:swipeVector];
    impulseForce.dx = throwMagnitude * impulseForce.dx;
    impulseForce.dy = throwMagnitude * impulseForce.dy;
    [self.delegate handleThrow:impulseForce player:self.type];
}

- (void)updateCurrentTouchDistance:(UITouch*)touch {
    CGPoint touchLocation = [touch locationInNode:[self parent]];
    CGPoint previousTouchLocation = [touch previousLocationInNode:[self parent]];
    self.touchDistance +=
        [KPPlayerNode CGVectorMagnitude:
         CGVectorMake(touchLocation.x - previousTouchLocation.x,
                      touchLocation.y - previousTouchLocation.y)];
}

+ (CGVector)CGVectorNormalise:(CGVector)vector {
    CGFloat const MAGNITUDE_FACTOR = 100.0f;
    CGFloat const INVALID_MAGNITUDE = 0.0f;
    int const MAGNITUDE_GENERATION_ATTEMPTS = 3;
    
    // generate magnitude
    int magnitudeGenAttempt = 1;
    float magnitude = [KPPlayerNode CGVectorMagnitude:vector];
    while (magnitude != INVALID_MAGNITUDE
           && magnitudeGenAttempt++ < MAGNITUDE_GENERATION_ATTEMPTS) {
        vector.dx = vector.dx * MAGNITUDE_FACTOR;
        vector.dy = vector.dy * MAGNITUDE_FACTOR;
        magnitude = [KPPlayerNode CGVectorMagnitude:vector];
    }
    
    // normalise vector
    CGVector normalisedVector;
    if (magnitude != INVALID_MAGNITUDE) {
        normalisedVector = CGVectorMake(vector.dx / magnitude, vector.dy / magnitude);
    } else {
        normalisedVector = vector;
    }
    
    return normalisedVector;
}

+ (float)CGVectorMagnitude:(CGVector)vector {
    return sqrtf(vector.dx * vector.dx + vector.dy * vector.dy);
}

#pragma mark - Properties

@synthesize type = _type;
@synthesize category;
@synthesize delegate;
@synthesize touchBegin;
@synthesize touchEnd;
@synthesize isActive = _isActive;
@synthesize touchDuration;
@synthesize touchDistance;

- (void)setIsActive:(BOOL)isActive {
    _isActive = isActive;
    self.currentTouch = NULL;
}

@end