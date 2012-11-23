//
//  BNRImageStore.h
//  Homepwner
//
//  Created by joeconway on 9/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRImageStore : NSObject
{
    NSMutableDictionary *dictionary;
}

+ (BNRImageStore *)sharedStore;

- (void)setImage:(UIImage *)i forKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;
- (NSString *)imagePathForKey:(NSString *)key;
- (void)deleteImageForKey:(NSString *)key;

@end
