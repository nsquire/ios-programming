//
//  BNRClassStore.h
//  ClassSchedule
//
//  Created by Nick on 1/21/13.
//  Copyright (c) 2013 Nick Org. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RSSChannel;

@interface BNRClassStore : NSObject

+(BNRClassStore *)sharedStore;
-(void)fetchClassesWithCompletion:(void (^)(RSSChannel *obj, NSError *err))block;

@end
