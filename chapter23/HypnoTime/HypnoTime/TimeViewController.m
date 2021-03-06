//
//  TimeViewController.m
//  HypnoTime
//
//  Created by joeconway on 8/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "TimeViewController.h"

@implementation TimeViewController

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle
{
    // Call the superclass's designated initializer
 // Get a pointer to the application bundle object
    NSBundle *appBundle = [NSBundle mainBundle];
    
    self = [super initWithNibName:@"TimeViewController"
                           bundle:appBundle];
                           
    if (self) {
        // Get the tab bar item
        UITabBarItem *tbi = [self tabBarItem];
        
        // Give it a label
        [tbi setTitle:@"Time"];

        // Give it an image
        UIImage *i = [UIImage imageNamed:@"Time.png"];
        [tbi setImage:i];
    }
    
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"In: %@ -> %@", [self class], NSStringFromSelector(_cmd));
    
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor greenColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"In: %@ -> %@", [self class], NSStringFromSelector(_cmd));
    
    [super viewWillAppear:animated];
    
    [self showCurrentTime:nil];
    [self moveButton];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"In: %@ -> %@", [self class], NSStringFromSelector(_cmd));
    
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    NSLog(@"In: %@ -> %@", [self class], NSStringFromSelector(_cmd));
    
    [super viewDidUnload];
    NSLog(@"Unloading TimeViewController's subviews %@", timeLabel);
    //timeLabel = nil;
}

- (IBAction)showCurrentTime:(id)sender
{
    NSLog(@"In: %@ -> %@", [self class], NSStringFromSelector(_cmd));
    
    NSDate *now = [NSDate date];
    
    // Static here means "only once." The variable formatter
    // is created when the program is first loaded into memory.
    // The first time this method runs, formatter will
    // be nil and the if-block will execute, creating
    // an NSDateFormatter object that formatter will point to.
    // Subsequent entry into this method will reuse the same
    // NSDateFormatter object.
    static NSDateFormatter *formatter = nil;
    
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
    }
    
    [timeLabel setText:[formatter stringFromDate:now]];
    
    //[self spinTimeLabel];
    [self bounceTimeLabel];
}

- (void)spinTimeLabel
{
    // Create a basic animation
    CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    
    [spin setDelegate:self];
    
    // fromValue is implied
    [spin setToValue:[NSNumber numberWithFloat:M_PI * 2.0]];
    [spin setDuration:1.0];
    
    // Set the timing function
    CAMediaTimingFunction *tf = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [spin setTimingFunction:tf];
    
    // Kick off the animation by adding it to the layer
    [[timeLabel layer] addAnimation:spin forKey:@"spinAnimation"];
}

- (void)bounceTimeLabel
{
    // Create a key frame animation
    CAKeyframeAnimation *bounce = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    // Create the values it will pass through
    CATransform3D forward = CATransform3DMakeScale(1.3, 1.3, 1);
    CATransform3D back = CATransform3DMakeScale(0.7, 0.7, 1);
    CATransform3D forward2 = CATransform3DMakeScale(1.2, 1.2, 1);
    CATransform3D back2 = CATransform3DMakeScale(0.9, 0.9, 1);
    
    [bounce setValues:[NSArray arrayWithObjects:
                       [NSValue valueWithCATransform3D:CATransform3DIdentity],
                       [NSValue valueWithCATransform3D:forward],
                       [NSValue valueWithCATransform3D:back],
                       [NSValue valueWithCATransform3D:forward2],
                       [NSValue valueWithCATransform3D:back2],
                       [NSValue valueWithCATransform3D:CATransform3DIdentity],
                       nil]];
    
    // Set the duration
    //[bounce setDuration:0.6];
    
    // Create another key frame animation for opacity
    CAKeyframeAnimation *opacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    
    [opacity setValues:[NSArray arrayWithObjects:
                        [NSNumber numberWithFloat:0.7],
                        [NSNumber numberWithFloat:1.0],
                        [NSNumber numberWithFloat:0.5],
                        [NSNumber numberWithFloat:1.0],
                        [NSNumber numberWithFloat:0.5],
                        [NSNumber numberWithFloat:0.7],
                        nil]];
    
    // Set the duration
    //[opacity setDuration:0.6];
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    [animGroup setAnimations:[NSArray arrayWithObjects:opacity, bounce, nil]];
    [animGroup setDuration:0.6];
    
    // Animate the layer
    [[timeLabel layer] addAnimation:animGroup forKey:@"bounceAndFadeAnimation"];
}

- (void)moveButton
{
    // Add an animation to move the button onto the view
    CABasicAnimation *moveButtonAnim = [CABasicAnimation animationWithKeyPath:@"position"];
    [moveButtonAnim setFromValue:[NSValue valueWithCGPoint:CGPointMake(-70.0, 67.5)]];
    [moveButtonAnim setToValue:[NSValue valueWithCGPoint:CGPointMake(160.5, 67.5)]];
    //[[timeButton layer] setPosition:CGPointMake(160.5, 67.5)];
    
    [moveButtonAnim setDuration:0.5];
    [moveButtonAnim setDelegate:self];
    
    [[timeButton layer] addAnimation:moveButtonAnim forKey:@"moveButtonAnim"];
}

- (void)pulseButton
{
    CAKeyframeAnimation *pulse = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    
    [pulse setValues:[NSArray arrayWithObjects:
                        [NSNumber numberWithFloat:1.0],
                        [NSNumber numberWithFloat:0.75],
                        [NSNumber numberWithFloat:1.0],
                        nil]];
    
    [pulse setDuration:1.5];
    [pulse setRepeatCount:HUGE_VALF];
    
    CAMediaTimingFunction *tf = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [pulse setTimingFunction:tf];
    
    [[timeButton layer] addAnimation:pulse forKey:@"pulsingButton"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"%@ finished: %d", anim, flag);
    CGPoint newPt = [[[timeButton layer] presentationLayer] position];
    NSLog(@"New point: %f, %f", newPt.x, newPt.y);
    //[[timeButton layer] setPosition:newPt];
    [self pulseButton];
    
}

@end
