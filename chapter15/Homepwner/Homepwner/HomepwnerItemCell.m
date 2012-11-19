//
//  HomepwnerItemCell.m
//  Homepwner
//
//  Created by Nick on 11/16/12.
//
//

#import "HomepwnerItemCell.h"

@implementation HomepwnerItemCell

@synthesize thumbnailView;
@synthesize nameLabel;
@synthesize serialNumberLabel;
@synthesize valueLabel;

- (IBAction)showImage:(id)sender
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    [self sendActionMessageToController:@"showImage:atIndexPath:" withSender:sender];
}

@end
