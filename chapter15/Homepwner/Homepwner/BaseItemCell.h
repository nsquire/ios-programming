//
//  BaseItemCell.h
//  Homepwner
//
//  Created by Nick on 11/18/12.
//
//

#import <UIKit/UIKit.h>

@interface BaseItemCell : UITableViewCell

@property (weak, nonatomic) id controller;
@property (weak, nonatomic) UITableView *tableView;

- (void)sendActionMessageToController:(NSString *)selector withSender:(id)sender;

@end
