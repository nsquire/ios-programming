//
//  BNRImageStore.m
//  Homepwner
//
//  Created by joeconway on 9/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BNRImageStore.h"

@implementation BNRImageStore

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

- (id)init {
    self = [super init];
    
    if (self) {
        dictionary = [[NSMutableDictionary alloc] init];
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(clearCache:)
                   name:UIApplicationDidReceiveMemoryWarningNotification
                 object:nil];
    }
    
    return self;
}

- (void)setImage:(UIImage *)i forKey:(NSString *)key
{
    [dictionary setObject:i forKey:key];
    
    // Create full path for image
    NSString *imagePath = [self imagePathForKey:key];
    
    // Turn image into JPEG data
    NSData *d = UIImageJPEGRepresentation(i, 0.5);
    
    // Write it to full path
    [d writeToFile:imagePath atomically:YES];
}

- (UIImage *)imageForKey:(NSString *)key
{
    //return [dictionary objectForKey:key];
    
    // If possible, get it from the disctionary
    UIImage *result = [dictionary objectForKey:key];
    
    if (!result) {
        // Create UIImage object from file
        result = [UIImage imageWithContentsOfFile:[self imagePathForKey:key]];
        
        // If we found an image on the file system, place it into the cache
        if (result) {
            [dictionary setObject:result forKey:key];
        } else {
            NSLog(@"Error: unable to find %@", [self imagePathForKey:key]);
        }
    }
    
    return result;
}

- (NSString *)imagePathForKey:(NSString *)key
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:key];
}

- (void)deleteImageForKey:(NSString *)key
{
    if (!key) {
        return;
    }
    
    [dictionary removeObjectForKey:key];
    
    NSString *path = [self imagePathForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
}

- (void)clearCache:(NSNotification *)note
{
    NSLog(@"Flushing %d images out of the cache", [dictionary count]);
    [dictionary removeAllObjects];
}

@end
