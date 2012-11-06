//
//  QuizAppDelegate.h
//  Quiz
//
//  Created by Nicholas Squire on 9/23/12.
//  Copyright (c) 2012 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QuizViewController;

@interface QuizAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) QuizViewController *viewController;

@end
