//
//  AssetTypePicker.h
//  Homepwner
//
//  Created by Nick on 11/21/12.
//
//

#import <Foundation/Foundation.h>

@class BNRItem;

@interface AssetTypePicker : UITableViewController <UITableViewDataSource>

@property (nonatomic, strong) BNRItem *item;
@property (nonatomic, strong) UIPopoverController *popoverController;

@end
