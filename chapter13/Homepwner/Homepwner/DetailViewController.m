//
//  DetailViewController.m
//  Homepwner
//
//  Created by joeconway on 9/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "BNRItem.h"
#import "BNRImageStore.h"
#import "BNRItemStore.h"
#import "ImagePickerPopoverBackgroundView.h"

@implementation DetailViewController

@synthesize item, dismissBlock;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"Wrong initializer"
                                   reason:@"User initForNewItem:"
                                 userInfo:nil];
}

- (id)initForNewItem:(BOOL)isNew
{
    self = [super initWithNibName:@"DetailViewController" bundle:nil];
    
    if (self && isNew) {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
        [[self navigationItem] setRightBarButtonItem:doneButton];
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
        [[self navigationItem] setLeftBarButtonItem:cancelButton];
    }
    
    return self;
}

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
    [dateLabel setText:[dateFormatter stringFromDate:[item dateCreated]]];

    // Change the navigation item to display name of item
    [[self navigationItem] setTitle:[item itemName]];

    NSString *imageKey = [item imageKey];
    if (imageKey) {
        // Get image for image key from image store
        UIImage *imageToDisplay =
        [[BNRImageStore defaultImageStore] imageForKey:imageKey];
        // Use that image to put on the screen in imageView
        [imageView setImage:imageToDisplay];
    } else {
        // Clear the imageView
        [imageView setImage:nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor *clr = nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        clr = [UIColor colorWithRed:0.875 green:0.88 blue:0.91 alpha:1];
    } else {
        //clr = [UIColor groupTableViewBackgroundColor]; doesn't work on iPhone 5 simulator
        clr = [UIColor colorWithRed:0.875 green:0.88 blue:0.91 alpha:1];
    }
    
    [[self view] setBackgroundColor:clr];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES; 
}

- (IBAction)takePicture:(id)sender 
{
    if ([imagePickerPopover isPopoverVisible]) {
        // If the popover is up already, get rid of it
        [imagePickerPopover dismissPopoverAnimated:YES];
        imagePickerPopover = nil;
        return;
    }
    
    UIImagePickerController *imagePicker =
            [[UIImagePickerController alloc] init];
    
    // If our device has a camera, we want to take a picture, otherwise, we
    // just pick from photo library
    if ([UIImagePickerController
            isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    [imagePicker setDelegate:self];

    // Place image picker on the screen
    //[self presentViewController:imagePicker animated:YES completion:nil];
    // Check for iPad device before instantiating the popover controller
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
         // Create a new popover controller that will display the imagePicker
        imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        [imagePickerPopover setDelegate:self];
        [imagePickerPopover setPopoverBackgroundViewClass:[ImagePickerPopoverBackgroundView class]];
        
        // Display the popover controller; sender
        // is the camera bar button item
        [imagePickerPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else {
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"User dismissed popover");
    imagePickerPopover = nil;
}

- (IBAction)backgroundTapped:(id)sender 
{
    [[self view] endEditing:YES];
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

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *oldKey = [item imageKey];
    // Did the item already have an image?
    if (oldKey) {
        // Delete the old image
        [[BNRImageStore defaultImageStore] deleteImageForKey:oldKey];
    }
    
    // Get picked image from info dictionary
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];

    // Create a CFUUID object - it knows how to create unique identifier strings
    CFUUIDRef newUniqueID = CFUUIDCreate (kCFAllocatorDefault);

    // Create a string from unique identifier
    CFStringRef newUniqueIDString =
            CFUUIDCreateString (kCFAllocatorDefault, newUniqueID);

    // Use that unique ID to set our item's imageKey
    NSString *key = (__bridge NSString *)newUniqueIDString;
    [item setImageKey:key];
    
    
    // Store image in the BNRImageStore with this key
    [[BNRImageStore defaultImageStore] setImage:image
                                         forKey:[item imageKey]];

    CFRelease(newUniqueIDString);
    CFRelease(newUniqueID);
            
    // Put that image onto the screen in our image view
    [imageView setImage:image];

    // Take image picker off the screen -
    // you must call this dismiss method
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [imagePickerPopover dismissPopoverAnimated:YES];
        imagePickerPopover = nil;
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

// Doesn't work on iPhone 5 simulator
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
    }
}

- (void)save:(id)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:dismissBlock];
}

- (void)cancel:(id)sender
{
    // If the user cancelled, then remove the item from the item store
    [[BNRItemStore defaultStore] removeItem:item];
    
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:dismissBlock];
}

@end
