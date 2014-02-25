/**
 * @filename KPPlayerAttackNode.h
 * @author Morgan Wall
 * @date 25-2-2014
 *
 * @brief The base class for sprite describing an attacking player in the scene 
 * graph of a game state. This class is a hack that was implemented to be able
 * to determine when a certain frame is displayed. Alternatively, the 
 * SSKSpriteAnimationNode could be rewritten to avoid the use of SKActions
 * (e.g. using the update: method to switch out textures).
 */

#import <SpriteStackKit/SSKSpriteAnimationNode.h>

@interface KPPlayerAttackNode : SSKSpriteAnimationNode

- (BOOL)showingProjectileGenerationFrame;

@end
