//
//  HypnosisViewController.m
//  HypnoTime
//
//  Created by Nick on 10/13/12.
//  Copyright (c) 2012 Nick. All rights reserved.
//

#import "HypnosisViewController.h"
#import "HypnosisView.h"

@implementation HypnosisViewController
{
    HypnosisView *v;
}

- (void)segmentAction:(id)sender
{
    NSLog(@"Selected segment: %d", [sender selectedSegmentIndex]);
    
    switch ([sender selectedSegmentIndex]) {
        case 0:
            [v setCircleColor:[UIColor redColor]];
            break;
        case 1:
            [v setCircleColor:[UIColor greenColor]];
            break;
        case 2:
            [v setCircleColor:[UIColor blueColor]];
            break;
        default:
            break;
    }
}

#pragma mark View Controller lifecycle methods

- (void)loadView
{
    // Create a view
    CGRect frame = [[UIScreen mainScreen] bounds];
    v = [[HypnosisView alloc] initWithFrame:frame];
    
    // Set it as *the* view of this view controller
    [self setView:v];
    
    // Silver challenge
    CGRect segmentFrame = CGRectMake(40.0, 350.0, 240.0, 40.0); // Don't use hardcoded values like this
    NSArray *segmentTextContent = [NSArray arrayWithObjects:@"Red", @"Green", @"Blue", nil];
    UISegmentedControl *sc = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
    [sc setFrame:segmentFrame];
    [sc addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    [[self view] addSubview:sc];
}

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle
{
    // Call the superclass's designated initializer
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        // Get the tab bar item
        UITabBarItem *tbi = [self tabBarItem];
        
        // Give it a label
        [tbi setTitle:@"Hypnosis"];
        
        // Create a UIImage from a file
        // This will use Hypno@2x for retina devices
        UIImage *i = [UIImage imageNamed:@"Hypno.png"];
        [tbi setImage:i];
    }
    
    return self;
}

- (void)viewDidLoad
{
    // Always call the super implementation of viewDidLoad
    [super viewDidLoad];
    
    NSLog(@"HypnosisViewController loaded its view");
}

@end
