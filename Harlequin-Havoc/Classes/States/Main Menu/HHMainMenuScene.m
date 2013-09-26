/**
 * @filename HHMainMenuScene.m
 * @author Morgan Wall
 * @date 23-9-2013
 *
 * @brief The implementation of the scene graph for the main menu state.
 */

#import "HHMainMenuScene.h"

#pragma mark - Implementation

@implementation HHMainMenuScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        // stub
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
//    for (UITouch *touch in touches) {
//        CGPoint location = [touch locationInNode:self];
//        
//        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
//        
//        sprite.position = location;
//        
//        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
//        
//        [sprite runAction:[SKAction repeatActionForever:action]];
//        
//        [self addChild:sprite];
//    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

#pragma mark - HPScene

- (void)buildScene {
    [super buildScene];
    
    SKSpriteNode* background = [[SKSpriteNode alloc] initWithImageNamed:@"background.png"];
    background.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    [background setSize:CGSizeMake(1024, 768)];
    
    [self addChild:background];
}

- (void)clearScene {
    [super clearScene];
}

@end
