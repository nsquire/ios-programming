//
//  HypnosisView.m
//  Hypnosister
//
//  Created by Nick on 10/6/12.
//  Copyright (c) 2012 Nick. All rights reserved.
//

#import "HypnosisView.h"

@implementation HypnosisView

@synthesize circleColor;

- (void)drawRect:(CGRect)dirtyRect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect bounds = [self bounds];
    
    // Figure out the center of the bounds rectangle
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height / 2.0;
    
    // The radius of the circle should be nearly as big as the view
    float maxRadius = hypot(bounds.size.width, bounds.size.height) / 2.0;
    
    // The thickness of the line should be 10 points wide
    CGContextSetLineWidth(ctx, 10);
    
    // The color of the line should be gray (red/blue/greeen = 0.6, alpha = 1.0)
    //CGContextSetRGBStrokeColor(ctx, 0.6, 0.6, 0.6, 1.0);
    //[[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0] setStroke];
    //[[UIColor lightGrayColor] setStroke];
    [[self circleColor] setStroke];
    
    // Add a shape to the context - this does not draw the shape
    //CGContextAddArc(ctx, center.x, center.y, maxRadius, 0.0, M_PI * 2.0, YES);
    
    // Perform a drawing instruction; draw current shape with current state
    //CGContextStrokePath(ctx);
    
    // Draw concentric circles from the outside in
    for (float currentRadius = maxRadius; currentRadius > 0; currentRadius -= 20) {
        // Add path to the context
        CGContextAddArc(ctx, center.x, center.y, currentRadius, 0.0, M_PI * 2.0, YES);
        
        // Bronze challenge
        // Switch to a random color before drawing the circle
        NSArray *arrayOfColors = [NSArray arrayWithObjects:[UIColor redColor],
                                                           [UIColor blueColor],
                                                           [UIColor blackColor],
                                                           [UIColor lightGrayColor],
                                                           [UIColor greenColor], nil];
        
        [[arrayOfColors objectAtIndex:rand() % 5] setStroke];
        
        // Perform drawing instructions; removes path
        CGContextStrokePath(ctx);
    }
    
    // Create a string
    NSString *text = @"You are getting sleepy.";
    
    // Get a font to draw it in
    UIFont *font = [UIFont boldSystemFontOfSize:28];
    
    CGRect textRect;
    textRect.size = [text sizeWithFont:font];
    
    // Let's put that string in the center of the view
    textRect.origin.x = center.x - textRect.size.width / 2.0;
    textRect.origin.y = center.y - textRect.size.height / 2.0;
    
    // Set the fill color of the current context to black
    [[UIColor blackColor] setFill];
    
    // The shadow will move 4 points to the right and 3 points down from the text
    CGSize offset = CGSizeMake(4, 3);
    
    // The shadow will be dark gray in color
    CGColorRef color = [[UIColor darkGrayColor] CGColor];
    
    // Set the shadow of the context with these parameters,
    // all subsequent drawing will be shadowed - save the shadow settings
    CGContextSaveGState(ctx);
    CGContextSetShadowWithColor(ctx, offset, 2.0, color);
    
    // Draw the string
    [text drawInRect:textRect withFont:font];
    
    // Silver challenge
    
    // Remove the shadow settings
    CGContextRestoreGState(ctx);
    [[UIColor greenColor] setStroke];
    CGContextSetLineWidth(ctx, 1.0);
    
    CGContextMoveToPoint(ctx, center.x - 15.0, center.y);
    CGContextAddLineToPoint(ctx, center.x + 15.0, center.y);
    
    CGContextMoveToPoint(ctx, center.x, center.y - 15.0);
    CGContextAddLineToPoint(ctx, center.x, center.y + 15.0);
    
    CGContextStrokePath(ctx);
    
    // Gold challenge
    
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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // All HypnosisViews start with a clear background
        [self setBackgroundColor:[UIColor clearColor]];
        [self setCircleColor:[UIColor lightGrayColor]];
    }
    
    return self;
}

- (BOOL) canBecomeFirstResponder
{
    return YES;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake) {
        NSLog(@"Device started shaking");
        [self setCircleColor:[UIColor redColor]];
    }
}

- (void)setCircleColor:(UIColor *)clr
{
    circleColor = clr;
    [self setNeedsDisplay];
}

- (void) dealloc
{
    CGImageRelease(image);
}

@end
