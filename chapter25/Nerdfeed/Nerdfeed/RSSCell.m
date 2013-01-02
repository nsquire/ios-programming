//
//  RSSCell.m
//  Nerdfeed
//
//  Created by Nick on 1/1/13.
//  Copyright (c) 2013 Nick. All rights reserved.
//

#import "RSSCell.h"

@implementation RSSCell

@synthesize titleLabel, authorLabel, categoryLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Setup the cell's title label
        titleLabel = [[UILabel alloc] init];
        [titleLabel setTextColor:[UIColor blackColor]];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
        [titleLabel setHighlightedTextColor:[UIColor whiteColor]];
        [titleLabel setFrame:CGRectZero];
        [[self contentView] addSubview:titleLabel];
        
        // Setup the cell's author label
        authorLabel = [[UILabel alloc] init];
        [authorLabel setTextColor:[UIColor darkGrayColor]];
        [authorLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
        [authorLabel setHighlightedTextColor:[UIColor whiteColor]];
        [authorLabel setFrame:CGRectZero];
        [[self contentView] addSubview:[self authorLabel]];
        
        // Setup the cell's category label
        categoryLabel = [[UILabel alloc] init];
        [categoryLabel setTextColor:[UIColor darkGrayColor]];
        [categoryLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
        [categoryLabel setHighlightedTextColor:[UIColor whiteColor]];
        [categoryLabel setFrame:CGRectZero];
        [[self contentView] addSubview:[self categoryLabel]];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Get the cell's bounds
    CGRect contentRect = [[self contentView] bounds];
    
    // Layout the title label
    CGRect frame = CGRectMake(contentRect.origin.x + 10.0, contentRect.origin.y, contentRect.size.width, 30.0);
    [titleLabel setFrame:frame];
    
    // Layout the author label
    frame = CGRectMake(contentRect.origin.x + 22.0, contentRect.origin.y + 25.0, contentRect.size.width, 22.0);
    [authorLabel setFrame:frame];
    
    // Layout the category label
    frame = CGRectMake(contentRect.origin.x + 22.0, contentRect.origin.y + 45.0, contentRect.size.width, 25.0);
    [categoryLabel setFrame:frame];
}

@end
