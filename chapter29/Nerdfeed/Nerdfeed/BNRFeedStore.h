//
//  BNRFeedStore.h
//  Nerdfeed
//
//  Created by Nick on 1/20/13.
//  Copyright (c) 2013 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RSSChannel;
@class RSSItem;

@interface BNRFeedStore : NSObject
{
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
}

@property (nonatomic, strong) NSDate *topSongsCacheDate;

+ (BNRFeedStore *)sharedStore;

- (RSSChannel *)fetchRSSFeedWithCompletion:(void (^)(RSSChannel *obj, NSError *err))block;
- (void)fetchTopSongs:(int)count withCompletion:(void (^)(RSSChannel *obj, NSError *err))block;

- (void)markItemAsRead:(RSSItem *)item;
- (BOOL)hasItemBeenRead:(RSSItem *)item;

- (void)markItemAsFavorite:(RSSItem *)item;
- (void)removeItemAsFavorite:(RSSItem *)item;
- (BOOL)isFavorite:(RSSItem *)item;

@end
