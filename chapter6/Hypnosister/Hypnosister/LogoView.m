//
//  LogoView.m
//  Hypnosister
//
//  Created by Nick on 10/12/12.
//  Copyright (c) 2012 Nick. All rights reserved.
//

#import "LogoView.h"

@implementation LogoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Gold challenge
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect bounds = [self bounds];
    
    // Figure out the center of the bounds rectangle
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height / 2.0;
    
    // The thickness of the line should be 10 points wide
    CGContextSetLineWidth(ctx, 2);
    
    // Get a reference to the image
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"Icon@2x.png" ofType:nil];
    UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
    image = CGImageRetain(img.CGImage);
    
    // Flip the coordinate system before we start drawing
    CGContextTranslateCTM(ctx, 0.0, self.bounds.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    
    CGContextSaveGState(ctx);
    
    // The shadow will move 4 points to the right and 3 points down from the text
    CGSize offset2 = CGSizeMake(4, 3);
    
    // The shadow will be dark gray in color
    CGColorRef color2 = [[UIColor darkGrayColor] CGColor];
    
    // Set the shadow of the context with these parameters,
    // all subsequent drawing will be shadowed
    CGContextSetShadowWithColor(ctx, offset2, 2.0, color2);
    
    // Create a background circle
    CGContextAddArc(ctx, 67.0, self.bounds.size.height - 60, 50.0, 0.0, M_PI * 2.0, YES);
    [[UIColor whiteColor] setFill];
    CGContextFillPath(ctx);
    
    CGContextRestoreGState(ctx);
    
    // Clip mask with a circle
    CGContextSaveGState(ctx);
    CGContextAddArc(ctx, 67.0, self.bounds.size.height - 60, 50.0, 0.0, M_PI * 2.0, YES);
    CGContextClip(ctx);
    
    // Draw image
    CGContextDrawImage(ctx, CGRectMake(23.0, self.bounds.size.height - 100.0, 90.0, 90.0), image);
    
    // Add gradient
    CGGradientRef myGradient;
    CGFloat colors[] = { 255.0 / 255.0, 255.0 / 255.0, 255.0 / 255.0, 0.00,
        200.0 / 255.0, 200.0 / 255.0, 255.0 / 255.0, 1.00 };
    
    CGColorSpaceRef myColorSpace = CGColorSpaceCreateDeviceRGB();
    
    myGradient = CGGradientCreateWithColorComponents(myColorSpace, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
    CGColorSpaceRelease(myColorSpace);
    
    CGPoint myStartPoint = CGPointMake(0.0, 430);
    CGPoint myEndPoint = CGPointMake(0.0, 470);
    CGContextDrawLinearGradient(ctx, myGradient, myStartPoint, myEndPoint, 0);
    
    // Draw outline with a circle
    CGContextSaveGState(ctx);
    CGContextAddArc(ctx, 67.0, self.bounds.size.height - 60, 50.0, 0.0, M_PI * 2.0, YES);
    [[UIColor blackColor] setStroke];
    CGContextStrokePath(ctx);
}

- (void) dealloc
{
    CGImageRelease(image);
}

@end
