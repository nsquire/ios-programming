//
//  Line.h
//  TouchTracker
//
//  Created by Nick on 12/8/12.
//  Copyright (c) 2012 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Line : NSManagedObject

@property (nonatomic, retain) NSValue *begin;
@property (nonatomic, retain) NSValue *end;

@property (nonatomic) CGPoint beginPoint;
@property (nonatomic) CGPoint endPoint;

@end
