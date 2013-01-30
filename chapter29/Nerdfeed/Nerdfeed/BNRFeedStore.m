//
//  BNRFeedStore.m
//  Nerdfeed
//
//  Created by Nick on 1/20/13.
//  Copyright (c) 2013 Nick. All rights reserved.
//

#import "BNRFeedStore.h"

#import "RSSChannel.h"
#import "BNRConnection.h"
#import "RSSItem.h"

@implementation BNRFeedStore

- (id)init
{
    self = [super init];
    
    if (self) {
        model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        NSError *error = nil;
        NSString *dbPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        dbPath = [dbPath stringByAppendingPathComponent:@"feed.db"];
        NSURL *dbURL = [NSURL fileURLWithPath:dbPath];
        
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:dbURL
                                     options:nil
                                       error:&error]) {
            
            [NSException raise:@"Open failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator:psc];
        [context setUndoManager:nil];
    }
    
    return self;
}

- (void)setTopSongsCacheDate:(NSDate *)topSongsCacheDate
{
    [[NSUserDefaults standardUserDefaults] setObject:topSongsCacheDate forKey:@"topSongsCacheDate"];
}

- (NSDate *)topSongsCacheDate
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"topSongsCacheDate"];
}

+ (BNRFeedStore *)sharedStore
{
    NSLog(@"In: %@->%@", [self class], NSStringFromSelector(_cmd));
    
    static BNRFeedStore *feedStore = nil;
    
    if (!feedStore) {
        feedStore = [[BNRFeedStore alloc] init];
    }
    
    return feedStore;
}

- (RSSChannel *)fetchRSSFeedWithCompletion:(void (^)(RSSChannel *obj, NSError *err))block
{
    NSLog(@"In: %@->%@", [self class], NSStringFromSelector(_cmd));
    
    NSURL *url = [NSURL URLWithString:@"http://forums.bignerdranch.com/"
                   @"smartfeed.php?limit=1_DAY&sort_by=standard"
                   @"&feed_type=RSS2.0&feed_style=COMPACT"];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    // Create an empty channel
    RSSChannel *channel = [[RSSChannel alloc] init];
    
    // Create a connection "actor" object that will transfer data from the server
    BNRConnection *connection = [[BNRConnection alloc] initWithRequest:req];
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    cachePath = [cachePath stringByAppendingPathComponent:@"nerd.archive"];
    
    // Load the cached channel
    RSSChannel *cachedChannel = [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];
    
    // If one hasn't aleardy been cached, create a blank one to fill it up
    if (!cachedChannel) {
        cachedChannel = [[RSSChannel alloc] init];
    }
    
    RSSChannel *channelCopy = [cachedChannel copy];
    
    [connection setCompletionBlock:^(RSSChannel *obj, NSError *err) {
       // This is the store's callback code
        if (!err) {
            [channelCopy addItemsFromChannel:obj];
            [NSKeyedArchiver archiveRootObject:channelCopy toFile:cachePath];
        }
        
        // This is the controller's callback code
        block(channelCopy, err);
    }];
    
    // Let the empty channel parse the returning data from the web service
    [connection setXmlRootObject:channel];
    
    // Begin the connection
    [connection start];
    
    return cachedChannel;
}

- (void)fetchTopSongs:(int)count withCompletion:(void (^)(RSSChannel *obj, NSError *err))block
{
    NSLog(@"In: %@->%@", [self class], NSStringFromSelector(_cmd));
    
    // Construct the cache path
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    cachePath = [cachePath stringByAppendingPathComponent:@"apple.archive"];
    
    // Make sure we have cached at least once before by checking to see
    // if this date exists!
    NSDate *tscDate = [self topSongsCacheDate];
    if (tscDate) {
        // How old is the cache?
        NSTimeInterval cacheAge = [tscDate timeIntervalSinceNow];
        
        if (cacheAge > -300.0) {
            // If it is less than 300 seconds (5 minutes) old, return cache
            // in completion block
            NSLog(@"Reading cache!");
            
            RSSChannel *cachedChannel = [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];
            
            if (cachedChannel) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    // Execute the controller's completion block to reload its table
                    block(cachedChannel, nil);
                }];
                
                // Don't need to make the request, just get out of this method
                return;
            }
        }
    }
    
    // Prepare a request URL, including the argument from the controller
    NSString *requestString = [NSString stringWithFormat:@"http://itunes.apple.com/us/rss/topsongs/limit=%d/json", count];
    
    NSURL *url = [NSURL URLWithString:requestString];
    
    // Set up the connection as normal
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    RSSChannel *channel = [[RSSChannel alloc] init];
    BNRConnection *connection = [[BNRConnection alloc] initWithRequest:req];

    [connection setCompletionBlock:^(RSSChannel *obj, NSError *err) {
        // This is the store's completion code:
        // If everything went smoothly, save the channel to disk and set cache date
        if (!err) {
            [self setTopSongsCacheDate:[NSDate date]];
            [NSKeyedArchiver archiveRootObject:obj toFile:cachePath];
        }
        
        // This is the controller's completion code:
        block(obj, err);
    }];
    
    
    [connection setJsonRootObject:channel];
    [connection start];
}

- (void)markItemAsRead:(RSSItem *)item
{
    // If this item is already in Core Data, no need for duplicates
    if ([self hasItemBeenRead:item]) {
        return;
    }
    
    // Create a new Link object and insert it into the context
    NSManagedObject *obj = [NSEntityDescription insertNewObjectForEntityForName:@"Link" inManagedObjectContext:context];
    [obj setValue:[item link] forKey:@"urlString"];
    
    // Immediately save the changes
    [context save:nil];
}

- (BOOL)hasItemBeenRead:(RSSItem *)item
{
    // Create a request to fetch all Link's with the same urlString as
    // this link
    NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:@"Link"];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"urlString LIKE %@", [item link]];
    [req setPredicate:pred];
    
    // If there is at least one link, then this item has been read before
    NSArray *entries = [context executeFetchRequest:req error:nil];
    if ([entries count] > 0) {
        return YES;
    }
    
    // If Core Data has never seen this link, then it hasn't been read
    return NO;
}

@end
