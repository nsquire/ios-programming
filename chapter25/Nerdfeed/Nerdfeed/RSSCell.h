//
//  RSSCell.h
//  Nerdfeed
//
//  Created by Nick on 1/1/13.
//  Copyright (c) 2013 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSSCell : UITableViewCell
{
    UILabel *titleLabel;
    UILabel *authorLabel;
    UILabel *categoryLabel;
}

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *categoryLabel;

@end
