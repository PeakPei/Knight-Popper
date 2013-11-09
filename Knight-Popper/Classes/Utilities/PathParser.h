/**
 * @filename PathParser.h
 * @author Morgan Wall
 * @date 7-11-2013
 *
 * @brief A utility class used to parse plist files describing hitboxes for 
 * textures and frames in sprite sheets.
 * 
 * @note The plist files in question come in pairs and contain arrays of coordinate
 * values (one for each axis) which collectively describe a path outlining the
 * hitbox.
 */

#import <Foundation/Foundation.h>

@interface PathParser : NSObject

/**
 * @brief Retrieve a collection of core graphics paths describing the hitbox
 * for each frame in a sprite sheet (or texture) described by a set of
 * plist files.
 *
 * @param baseFilename
 * The base name of the plist files describing the hitboxes for each frame.
 * The entire filename consists of <name>_<coord>_<row><col>, where <coord>
 * is either x or y and <row> and <col> denotes the frame in the sprite sheet.
 * In this case, <name> is the base filename.
 *
 * @param columns
 * The number of columns of frame images in the sprite sheet (or texture).
 *
 * @param rows
 * The number of rows of frame images in the sprite sheet (or texture).
 *
 * @param numFrames
 * The number of frames in the sprite sheet. This does not have to be the product
 * of columns and rows.
 *
 * @param horizontalOrder
 * Denotes whether the frames are order horizontally (true) or vertically (false).
 *
 * @param width
 * The width of a frame in the sprite sheet (or texture).
 *
 * @param height
 * The height of a frame in the sprite sheet (or texture).
 *
 * @returns An array of core graphic paths describing the hitboxes, the order
 * of which corresponds to the frame traversal order.
 */
+ (NSArray*)parsePaths:(NSString*)baseFilename
               columns:(unsigned int)columns
                  rows:(unsigned int)rows
             numFrames:(unsigned int)numFrames
       horizontalOrder:(BOOL)horizontalOrder
                 width:(double)width
                height:(double)height;

@end
