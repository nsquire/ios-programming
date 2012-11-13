//
//  ImagePickerPopoverBackgroundView.m
//  Homepwner
//
//  Created by Nick on 11/13/12.
//
//

#import "ImagePickerPopoverBackgroundView.h"

@implementation ImagePickerPopoverBackgroundView

@synthesize arrowDirection;
@synthesize arrowOffset;

- (UIPopoverArrowDirection) arrowDirection
{
    return UIPopoverArrowDirectionUp;
}

- (void) setArrowDirection:(UIPopoverArrowDirection)direction
{
    arrowDirection = direction;
}

- (CGFloat) arrowOffset
{
    return 5.0;
}

- (void) setArrowOffset:(CGFloat)offset
{
    arrowOffset = offset;
}

+ (CGFloat)arrowHeight
{
    return 30.0;
}

+ (CGFloat)arrowBase
{
    return 42.0;
}

+ (UIEdgeInsets)contentViewInsets
{
    return UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0);
}

+ (BOOL)wantsDefaultContentAppearance
{
    return NO;
}

@end
