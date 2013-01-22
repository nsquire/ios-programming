//
//  JSONSerializable.h
//  ClassSchedule
//
//  Created by Nick on 1/21/13.
//  Copyright (c) 2013 Nick Org. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JSONSerializable <NSObject>

- (void)readFromJSONDictionary:(NSDictionary *)dict;

@end
