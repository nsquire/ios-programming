//
//  HomepwnerItemCell.h
//  Homepwner
//
//  Created by Nick on 11/16/12.
//
//

#import <Foundation/Foundation.h>
#import "BaseItemCell.h"

@interface HomepwnerItemCell : BaseItemCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

- (IBAction)showImage:(id)sender;

@end
