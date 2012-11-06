//
//  TimeViewController.h
//  HypnoTime
//
//  Created by Nick on 10/13/12.
//  Copyright (c) 2012 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeViewController : UIViewController
{
    __weak IBOutlet UILabel *timeLabel;
}

- (IBAction)showCurrentTime:(id)sender;

@end
