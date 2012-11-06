//
//  ChangeDateViewController.h
//  Homepwner
//
//  Created by Nick on 11/5/12.
//
//

#import <UIKit/UIKit.h>

@class BNRItem;

@interface ChangeDateViewController : UIViewController
{
    __weak IBOutlet UIDatePicker *changeDatePicker;
}

@property (nonatomic, strong) BNRItem *item;

@end
