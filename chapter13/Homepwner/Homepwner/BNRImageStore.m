//
//  BNRImageStore.m
//  Homepwner
//
//  Created by Nick on 11/7/12.
//
//

#import "BNRImageStore.h"

@implementation BNRImageStore {}

#pragma mark - Initialization methods

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

+ (BNRImageStore *)sharedStore
{
    static BNRImageStore *sharedStore = nil;
    
    if (!sharedStore) {
        // Create the singleton
        sharedStore = [[super allocWithZone:NULL] init];
    }
    
    return sharedStore;
}

- (id)init
{
    NSLog(@"init ran...");
    
    self = [super init];
    
    if (self) {
        dictionary = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

#pragma mark - Image methods

- (void)setImage:(UIImage *)i forKey:(NSString *)s
{
    [dictionary setObject:i forKey:s];
}

- (UIImage *)imageForKey:(NSString *)s
{
    return [dictionary objectForKey:s];
}

- (void)deleteImageForKey:(NSString *)s
{
    if (!s) {
        return;
    }
    
    [dictionary removeObjectForKey:s];
}

@end
