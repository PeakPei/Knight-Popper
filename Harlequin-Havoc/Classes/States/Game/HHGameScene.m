/**
 * @filename HPGameScene.m
 * @author Morgan Wall
 * @date 23-9-2013
 *
 * @brief The implementation of the scene graph for the game state.
 */

#import "HHGameScene.h"

@implementation HHGameScene

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
}

- (void)clearScene {
    [super clearScene];
}

@end
