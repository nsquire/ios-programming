//
//  DetailViewController.m
//  Homepwner
//
//  Created by Nick on 11/4/12.
//
//

#import "DetailViewController.h"
#import "BNRItem.h"
#import "ChangeDateViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize item;

- (void)setItem:(BNRItem *)i
{
    item = i;

    [[self navigationItem] setTitle:[item itemName]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [nameField setText:[item itemName]];
    [serialNumberField setText:[item serialNumber]];
    [valueField setText:[NSString stringWithFormat:@"%d", [item valueInDollars]]];
    
    // Create a NSDateFormatter that will turn a date into a simple date string
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    // Use filtered NSDate object to set dateLabel contents
    [dateField setText:[dateFormatter stringFromDate:[item dateCreated]]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]]; // doing anything?
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Clear first responder
    [[self view] endEditing:YES];
    
    // "Save" changes to item
    [item setItemName:[nameField text]];
    [item setSerialNumber:[serialNumberField text]];
    [item setValueInDollars:[[valueField text] intValue]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self view] endEditing:YES];
}

- (IBAction)ChangeDate:(id)sender
{
    ChangeDateViewController *changeDateViewController = [[ChangeDateViewController alloc] init];
    [changeDateViewController setItem:item];
    [[self navigationController] pushViewController:changeDateViewController animated:YES];
}


@end
