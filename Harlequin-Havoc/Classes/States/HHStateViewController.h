/**
 * @filename HHStateViewController.h
 * @author Morgan Wall
 * @date 23-9-2013
 *
 * @brief The base view controller describing a state in the game. Each state
 * has a view and a scene graph describing said view.
 */

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface HHStateViewController : UIViewController

/**
 * @brief The view associated with the view controller that is used to describe
 * the visual state of the scene.
 */
@property SKView* stateView;

/**
 * @brief The scene (graph) that is used to describe the contents of the scene.
 */
@property SKScene* scene;

@end
