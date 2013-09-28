/**
 * @filename HHActionCategories.h
 * @author Morgan Wall
 * @date 24-9-13
 *
 * @brief The types of scene nodes in the scene graph for the game.
 */

#import <Foundation/Foundation.h>

@interface HHActionCategories : NSObject

/**
 * @brief An enumeration of all the receiver categories used to be able to send 
 * to actions multiple applicable nodes in a scene graph. A node in the scene
 * graph only handles actions that share at least one category with one another.
 */
typedef enum Category {
    ActionCategoryNone = 0,
    ActionCategoryScene = 1 << 0,
    ActionCategoryTarget = 1 << 1,
    ActionCategoryObstacle = 1 << 2,
    ActionCategoryBackground = 1 << 3,
    ActionCategoryScore = 1 << 4,
    ActionCategoryTime = 1 << 5
} ActionCategory;

/**
 * @brief Determine the node name associated with a category.
 *
 * @param category
 * The receiver category.
 *
 * @note The SpriteKit framework uses the name property on node objects to determine
 * whether they should handle an action or not.
 */
+ (NSString*)nodeNameForCategory:(unsigned int)category;

@end
