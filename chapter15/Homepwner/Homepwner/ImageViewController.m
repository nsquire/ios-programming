//
//  ImageViewController.m
//  Homepwner
//
//  Created by Nick on 11/17/12.
//
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

@synthesize image;

- (void)viewDidLoad
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    [super viewDidLoad];
    
    [scrollView setMinimumZoomScale:0.5];
    [scrollView setMaximumZoomScale:6.0];
    [scrollView setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    [super viewWillAppear:animated];
    
    CGSize sz = [[self image] size];
    
    NSLog(@"size: %f, %f", sz.width, sz.height);
    
    [scrollView setContentSize:sz];
    
    // Center image in frame
    [imageView setFrame:CGRectMake(([[self view] bounds].size.width / 2) - (sz.width / 2),
                                   ([[self view] bounds].size.height / 2) - (sz.height / 2),
                                   sz.width,
                                   sz.height)];
    
    [imageView setImage:[self image]];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)sv withView:(UIView *)view atScale:(float)scale
{
    CGSize sz = [view bounds].size;
    
    sz.width *= scale;
    sz.height *= scale;
    
    NSLog(@"size: %f, %f scale: %f", sz.width, sz.height, scale);
    
    [sv setContentSize:sz];
}

@end
