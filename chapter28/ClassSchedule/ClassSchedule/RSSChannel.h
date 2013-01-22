//
//  RSSChannel.h
//  ClassSchedule
//
//  Created by Nick on 1/21/13.
//  Copyright (c) 2013 Nick Org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONSerializable.h"

@interface RSSChannel : NSObject <JSONSerializable>

@property (nonatomic, readonly, strong) NSMutableArray *items;

@end
