//
//  BaseItemCell.m
//  Homepwner
//
//  Created by Nick on 11/18/12.
//
//

#import "BaseItemCell.h"

@implementation BaseItemCell

@synthesize controller;
@synthesize tableView;

- (void)sendActionMessageToController:(NSString *)selector withSender:(id)sender
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    SEL selectorCommand = NSSelectorFromString(selector);
    
    NSIndexPath *indexPath = [[self tableView] indexPathForCell:self];

    NSLog(@"Checking if there's an index path");
    if (indexPath) {
        NSLog(@"Have index path, checking if controller contains method");
        if ([[self controller] respondsToSelector:selectorCommand]) {
            NSLog(@"Controller contains method, sending message");
            
            // Ignore warning - may or may not appear
            [[self controller] performSelector:selectorCommand
                                    withObject:sender
                                    withObject:indexPath];
        } else {
            NSLog(@"Controller does not contain method");
        }
    }
}

@end
