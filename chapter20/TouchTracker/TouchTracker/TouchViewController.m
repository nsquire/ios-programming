//
//  TouchViewController.m
//  TouchTracker
//
//  Created by Nick on 11/28/12.
//  Copyright (c) 2012 Nick. All rights reserved.
//

#import "TouchViewController.h"
#import "TouchDrawView.h"

@implementation TouchViewController

- (void)loadView
{
    [self setView:[[TouchDrawView alloc] initWithFrame:CGRectZero]];
}

@end
