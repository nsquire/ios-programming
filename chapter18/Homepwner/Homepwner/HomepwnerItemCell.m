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

@synthesize controller;
@synthesize tableView;

- (IBAction)showImage:(id)sender
{
    NSLog(@"Running: %@", NSStringFromSelector(_cmd));
    
    // Get the name of this method, "showImage:"
    NSString *selector = NSStringFromSelector(_cmd);
    
    // selector is now "showImage:atIndexPath:"
    selector = [selector stringByAppendingString:@"atIndexPath:"];
    
    // Prepare a selector from this string
    SEL newSelector = NSSelectorFromString(selector);
    
    NSIndexPath *indexPath = [[self tableView] indexPathForCell:self];
    
    if (indexPath) {
        NSLog(@"Have index path, %@", indexPath);
        
        NSLog(@"Checking if controller responds to: %@", NSStringFromSelector(newSelector));
        if ([[self controller] respondsToSelector:newSelector]) {
            NSLog(@"Controller responds to selector, calling method");
            
            // Ignore warning from this line - may or may not appear, doesn't matter
            [[self controller] performSelector:newSelector
                                    withObject:sender
                                    withObject:indexPath];
        }
    }
}

@end
