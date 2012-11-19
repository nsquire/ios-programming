//
//  HomepwnerStepperItemCell.h
//  Homepwner
//
//  Created by Nick on 11/18/12.
//
//

#import "BaseItemCell.h"

@interface HomepwnerStepperItemCell : BaseItemCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIStepper *valueStepper;

- (IBAction)changeValue:(id)sender;

@end
