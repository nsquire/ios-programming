//
//  DetailViewController.h
//  Homepwner
//
//  Created by Nick on 11/4/12.
//
//

#import <UIKit/UIKit.h>

@class BNRItem;

@interface DetailViewController : UIViewController
{
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UITextField *serialNumberField;
    __weak IBOutlet UITextField *valueField;
    __weak IBOutlet UILabel *dateField;
    //__weak IBOutlet UIButton *ChangeDateButton;
}

@property (nonatomic, strong) BNRItem *item;

- (IBAction)ChangeDate:(id)sender;

@end
