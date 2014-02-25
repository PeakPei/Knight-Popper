/**
 * @filename KPPlayerAttackNode.m
 * @author Morgan Wall
 * @date 25-2-2014
 */

#import "KPPlayerAttackNode.h"

#pragma mark - Interface

@interface KPPlayerAttackNode () {
    /**
     * @brief The textures used for animating the sprite (in animation order).
     */
    NSArray* _frames;
    
    /**
     * @brief The action key used for animating the sprite (continuously).
     *
     * @note This key can be used to disable the sprite animation (see SKNode).
     */
    NSString* _animationKey;
}

@property SKTexture* projectileGenerationTexture;

@end

#pragma mark - Implementation

@implementation KPPlayerAttackNode

- (BOOL)showingProjectileGenerationFrame {
    return (self.projectileGenerationTexture == self.texture);
}

#pragma mark SSKSpriteAnimationNode

- (void)setSpriteSheet:(SKTexture*)spriteSheet
               columns:(unsigned int)columns
                  rows:(unsigned int)rows
             numFrames:(unsigned int)numFrames
       horizontalOrder:(BOOL)horizontalOrder {
    
    unsigned int const PROJECTILE_GENERATION_FRAME_INDEX = 3;
    
    [self stopAnimating];
    
    _framesCount = numFrames;
    
    CGFloat widthProportion = 1.0 / columns;
    CGFloat heightProportion = 1.0 / rows;
    
    // Initialise loop variables
    CGRect frameRect;
    NSMutableArray* frames =
    [[NSMutableArray alloc] initWithCapacity:numFrames];
    SKTexture* frame;
    
    // Initialise loop properties
    unsigned int numFramesRetrieved = 0;
    unsigned int primaryLoopCount = horizontalOrder ? rows : columns;
    unsigned int secondaryLoopCount = horizontalOrder ? columns : rows;
    
    // Retrieve frames from sprite sheet
    for (unsigned int i = 0; i < primaryLoopCount && numFramesRetrieved < numFrames; i++) {
        
        for (unsigned int j = 0; j < secondaryLoopCount && numFramesRetrieved < numFrames; j++) {
            
            frameRect = CGRectMake(widthProportion * (horizontalOrder ? j : i),
                                   heightProportion * (horizontalOrder
                                                       ? ((primaryLoopCount - 1) - i)
                                                       : ((secondaryLoopCount - 1) - j)),
                                   widthProportion,
                                   heightProportion);
            
            frame = [SKTexture textureWithRect:frameRect inTexture:spriteSheet];
            [frames addObject:frame];
            numFramesRetrieved++;
        }
    }
    
    _frames = frames;
    self.projectileGenerationTexture =
        [_frames objectAtIndex:PROJECTILE_GENERATION_FRAME_INDEX];
    [self setTexture:[_frames objectAtIndex:0]];
    [self setSize:CGSizeMake(spriteSheet.size.width * widthProportion,
                             spriteSheet.size.height * heightProportion)];
}

- (BOOL)setTimePerFrame:(double)timePerFrame {
    BOOL canSetFrameDuration = !self.isAnimating;
    
    if (canSetFrameDuration) {
        _timePerFrame = timePerFrame;
    }
    
    return canSetFrameDuration;
}

- (void)animate {
    if (self.isAnimating) {
        [self stopAnimating];
    }
    
    [self willChangeValueForKey:@"isAnimating"];
    _isAnimating = YES;
    [self didChangeValueForKey:@"isAnimating"];
    [self runAction:[SKAction repeatActionForever:
                     [SKAction animateWithTextures:_frames
                                      timePerFrame:self.timePerFrame
                                            resize:NO
                                           restore:YES]] withKey:_animationKey];
}

// HACK (to preserve existing API)
- (void)animateReverse {
    if (self.isAnimating) {
        [self stopAnimating];
    }
    
    [self willChangeValueForKey:@"isAnimating"];
    _isAnimating = YES;
    [self didChangeValueForKey:@"isAnimating"];
    [self runAction:[SKAction repeatActionForever:
                     [[SKAction animateWithTextures:_frames
                                       timePerFrame:self.timePerFrame
                                             resize:NO
                                            restore:YES] reversedAction]] withKey:_animationKey];
}

- (void)animateOnce {
    if (self.isAnimating) {
        [self stopAnimating];
    }
    
    [self willChangeValueForKey:@"isAnimating"];
    _isAnimating = YES;
    [self didChangeValueForKey:@"isAnimating"];
    [self runAction:
     [SKAction sequence:@[[SKAction animateWithTextures:_frames timePerFrame:self.timePerFrame],
                          [SKAction runBlock:^{
         [self willChangeValueForKey:@"isAnimating"];
         _isAnimating = NO;
         [self didChangeValueForKey:@"isAnimating"];
     }]]]];
}

#pragma mark - Properties

@synthesize projectileGenerationTexture;
@synthesize framesCount = _framesCount;
@synthesize isAnimating = _isAnimating;
@synthesize timePerFrame = _timePerFrame;

@end
