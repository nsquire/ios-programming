//
//  HomepwnerStepperItemCell.m
//  Homepwner
//
//  Created by Nick on 11/18/12.
//
//

#import "HomepwnerStepperItemCell.h"

@implementation HomepwnerStepperItemCell

@synthesize nameLabel;
@synthesize valueLabel;
@synthesize valueStepper;

- (IBAction)changeValue:(id)sender
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    [self sendActionMessageToController:@"changeValue:atIndexPath:" withSender:sender];

}

@end
