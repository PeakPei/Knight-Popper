/**
 * @filename HHTextureManager.m
 * @author Morgan Wall
 * @date 23-8-2013
 *
 * @brief The implementation of the HHTextureManager class.
 */

#import "HHTextureManager.h"

#pragma mark - Interface

@interface HHTextureManager ()

@property NSMutableDictionary* textures;

@end

#pragma mark - Implementation

@implementation HHTextureManager

- (id)init {
    if (self = [super init]) {
        self.textures = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id)initWithTextureCount:(TextureID)count {
    if (self = [super init]) {
        self.textures = [[NSMutableDictionary alloc] initWithCapacity:count];
    }
    return self;
}

- (SKTexture*)getTexture:(TextureID)identifier {
    NSNumber* textureId = [NSNumber numberWithUnsignedInt:identifier];
    
    SKTexture* texture;
    if (!(texture = [self.textures objectForKey:textureId])) {
        [[NSException
          exceptionWithName:@"TextureNotFoundException"
          reason:@"The identifier specified does not correspond to a texture"
          userInfo:nil] raise];
    }
    
    return texture;
}

- (void)loadTexture:(NSString*)textureName identifier:(TextureID)identifier {
    NSNumber* textureId = [NSNumber numberWithUnsignedInt:identifier];
    if (![self.textures objectForKey:textureId]) {
        [[NSException
          exceptionWithName:@"TextureAlreadyStoredException"
          reason:@"The specified identifier already corresponds to a texture."
          userInfo:nil] raise];
    }
    
    [self.textures setObject:[SKTexture textureWithImageNamed:textureName] forKey:textureId];
}

#pragma mark - Properties

@synthesize textures;

@end
