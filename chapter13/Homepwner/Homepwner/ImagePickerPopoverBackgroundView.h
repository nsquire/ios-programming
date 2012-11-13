//
//  ImagePickerPopoverBackgroundView.h
//  Homepwner
//
//  Created by Nick on 11/13/12.
//
//

#import <UIKit/UIKit.h>

@interface ImagePickerPopoverBackgroundView : UIPopoverBackgroundView

@property (nonatomic, readwrite) UIPopoverArrowDirection arrowDirection;
@property (nonatomic, readwrite) CGFloat arrowOffset;

+ (CGFloat)arrowHeight;
+ (CGFloat)arrowBase;
+ (UIEdgeInsets)contentViewInsets;
+ (BOOL)wantsDefaultContentAppearance;

@end
