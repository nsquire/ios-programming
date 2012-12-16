//
//  TouchDrawView.h
//  TouchTracker
//
//  Created by Nick on 11/28/12.
//  Copyright (c) 2012 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Line;

@interface TouchDrawView : UIView <UIGestureRecognizerDelegate>
{
    NSMutableDictionary *linesInProcess;
    NSMutableArray *completeLines;
    
    UIGestureRecognizer *panRecognizer;
    float lineWidth;
    UIColor *drawingColor;
    
    UIView *yellowColorPanel;
    UIView *blueColorPanel;
    UIView *orangeColorPanel;
}

@property (nonatomic, weak) Line *selectedLine;

- (void)clearAll;
- (void)endTouches:(NSSet *)touches;
- (Line *)lineAtPoint:(CGPoint)p;

@end
