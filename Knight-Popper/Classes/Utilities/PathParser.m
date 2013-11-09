/**
 * @filename PathParser.m
 * @author Morgan Wall
 * @date 7-11-2013
 */

#import "PathParser.h"

@implementation PathParser

+ (NSArray*)parsePaths:(NSString*)baseFilename
               columns:(unsigned int)columns
                  rows:(unsigned int)rows
             numFrames:(unsigned int)numFrames
       horizontalOrder:(BOOL)horizontalOrder
                 width:(double)width
                height:(double)height {
    
    NSMutableArray* paths = [[NSMutableArray alloc] initWithCapacity:numFrames];
    
    // Initialise loop properties
    unsigned int addedFrames = 0;
    unsigned int primaryLoopCount = horizontalOrder ? rows : columns;
    unsigned int secondaryLoopCount = horizontalOrder ? columns : rows;
    
    // Extract the hitbox path for each frame
    for (int i = 1; i <= primaryLoopCount && addedFrames < numFrames; i++) {
        for (int j = 1; j <= secondaryLoopCount && addedFrames < numFrames; j++) {
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, nil, 0, 0);
            
            int row = horizontalOrder ? i : j;
            int column = horizontalOrder ? j : i;
            
            NSString* xBaseName = [NSString stringWithFormat:@"%@%@%d%d",
                                   baseFilename, @"_x_", row, column];
            NSString* yBaseName = [NSString stringWithFormat:@"%@%@%d%d",
                                   baseFilename, @"_y_", row, column];
            
            NSString* xPath =
                [[NSBundle mainBundle] pathForResource:xBaseName ofType:@"plist"];
            NSString* yPath =
                [[NSBundle mainBundle] pathForResource:yBaseName ofType:@"plist"];
            
            NSArray* xValues = [[NSArray alloc] initWithContentsOfFile:xPath];
            NSArray* yValues = [[NSArray alloc] initWithContentsOfFile:yPath];
            
            for (int i = 0; i < xValues.count; i++) {
                CGPathAddLineToPoint(path, nil,
                                     [xValues[i] doubleValue] * width,
                                     [yValues[i] doubleValue] * height);
            }
            
            CGPathAddLineToPoint(path, nil,
                                 [xValues[0] doubleValue] * width,
                                 [yValues[0] doubleValue] * height);
            
            paths[addedFrames++] = (__bridge id)(path);
        }
    }
    
    return paths;
}

@end
