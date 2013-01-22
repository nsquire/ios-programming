//
//  BNRClassViewController.m
//  ClassSchedule
//
//  Created by Nick on 1/21/13.
//  Copyright (c) 2013 Nick Org. All rights reserved.
//

#import "BNRClassViewController.h"
#import "RSSItem.h"

@implementation BNRClassViewController

@synthesize titleLabel, locationLabel, startDateLabel, endDateLabel, instructorLabel, offeringIdLabel, item;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [titleLabel setText:[item title]];
    [locationLabel setText:[item location]];
    [startDateLabel setText:[item startDate]];
    [endDateLabel setText:[item endDate]];
    [instructorLabel setText:[item instructor]];
    [offeringIdLabel setText:[item offeringId]];
}

@end
