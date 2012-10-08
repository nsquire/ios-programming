//
//  HypnosisterAppDelegate.h
//  Hypnosister
//
//  Created by Nick on 10/6/12.
//  Copyright (c) 2012 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HypnosisView.h"

@interface HypnosisterAppDelegate : UIResponder <UIApplicationDelegate, UIScrollViewDelegate>
{
    HypnosisView *view;
}
@property (strong, nonatomic) UIWindow *window;

@end
