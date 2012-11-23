//
//  AssetTypeViewController.m
//  Homepwner
//
//  Created by Nick on 11/22/12.
//
//

#import "AssetTypeViewController.h"
#import "BNRItemStore.h"

@interface AssetTypeViewController ()

@end

@implementation AssetTypeViewController

@synthesize dismissBlock;

#pragma mark Initialization methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"New Asset Type"];
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                       target:self
                                       action:@selector(save:)];
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
        
        [[self navigationItem] setLeftBarButtonItem:cancelButton];
        [[self navigationItem] setRightBarButtonItem:doneButton];
    }
    
    return self;
}

#pragma mark Custom methods

- (IBAction)save:(id)sender
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    [[BNRItemStore sharedStore] addAssetType:[labelTextField text]];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:dismissBlock];
}

- (IBAction)cancel:(id)sender
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:dismissBlock];
}

@end
