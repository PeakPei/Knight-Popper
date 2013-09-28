/**
 * @filename NSMutableArray+QueueAdditions.h
 * @date 28-10-2011
 *
 * @brief A category on NSMutableArray providing a queue abstract data type.
 *
 * @note Sourced from: https://github.com/esromneb/ios-queue-object
 */

@interface NSMutableArray (QueueAdditions) 

-(id) dequeue;

-(void) enqueue:(id)obj;

-(id) peek:(int)index;

-(id) peekHead;

-(id) peekTail;

-(BOOL) empty;

@end