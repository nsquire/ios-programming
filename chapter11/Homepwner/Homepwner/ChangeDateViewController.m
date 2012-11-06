//
//  ChangeDateViewController.m
//  Homepwner
//
//  Created by Nick on 11/5/12.
//
//

#import "ChangeDateViewController.h"
#import "BNRItem.h"

@interface ChangeDateViewController ()

@end

@implementation ChangeDateViewController

@synthesize item;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [changeDatePicker setDate:[item dateCreated] animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // "Save" the item created date
    [item setDateCreated:[changeDatePicker date]];
}

@end
