//
//  TouchDrawView.m
//  TouchTracker
//
//  Created by Nick on 11/28/12.
//  Copyright (c) 2012 Nick. All rights reserved.
//

#import "TouchDrawView.h"
#import "Line.h"

@implementation TouchDrawView

@synthesize selectedLine;

- (id)initWithFrame:(CGRect)frame
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    self = [super initWithFrame:frame];
    
    if (self) {
        linesInProcess = [[NSMutableDictionary alloc] init];
        completeLines = [[NSMutableArray alloc] init];
        lineWidth = 10.0;
        drawingColor = [UIColor redColor];
        
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setMultipleTouchEnabled:YES];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(tap:)];
        [tapRecognizer setNumberOfTapsRequired:2];
        [self addGestureRecognizer:tapRecognizer];
        
        UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                          action:@selector(longPress:)];
        [self addGestureRecognizer:longPressRecognizer];
        
        panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                 action:@selector(pan:)];
        [panRecognizer setDelegate:self];
        [panRecognizer setCancelsTouchesInView:NO];
        [self addGestureRecognizer:panRecognizer];
        
        UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                              action:@selector(swipe:)];
        [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
        [swipeRecognizer setNumberOfTouchesRequired:2];
        [self addGestureRecognizer:swipeRecognizer];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context =  UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    // Draw complete lines in black
    [[UIColor blackColor] set];
    for (Line *line in completeLines) {
        CGContextMoveToPoint(context, [line begin].x, [line begin].y);
        CGContextAddLineToPoint(context, [line end].x, [line end].y);
        CGContextStrokePath(context);
    }
    
    // Draw lines in process in user set color, default is red
    [drawingColor set];
    for (NSValue *v in linesInProcess) {
        Line *line = [linesInProcess objectForKey:v];
        CGContextMoveToPoint(context, [line begin].x, [line begin].y);
        CGContextAddLineToPoint(context, [line end].x, [line end].y);
        CGContextStrokePath(context);
    }
    
    // If there is a selected line, draw it in green
    if ([self selectedLine]) {
        [[UIColor greenColor] set];
        CGContextMoveToPoint(context, [[self selectedLine] begin].x, [[self selectedLine] begin].y);
        CGContextAddLineToPoint(context, [[self selectedLine] end].x, [[self selectedLine] end].y);
        CGContextStrokePath(context);
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark Custom Methods

- (void)clearAll
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    // Clear all collections
    [linesInProcess removeAllObjects];
    [completeLines removeAllObjects];
    
    // Redraw
    [self setNeedsDisplay];
}

- (void)endTouches:(NSSet *)touches
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    // Remove ending touches from dictionary
    for (UITouch *touch in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:touch];
        Line *line = [linesInProcess objectForKey:key];
        
        // If this is a double tap, 'line' will be nil,
        // so make sure not to add it to the array
        if (line) {
            [completeLines addObject:line];
            [linesInProcess removeObjectForKey:key];
        }
    }
    
    // Redraw
    [self setNeedsDisplay];
}

- (Line *)lineAtPoint:(CGPoint)p
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    // Find a line close to p
    for (Line *line in completeLines) {
        CGPoint start = [line begin];
        CGPoint end = [line end];
        
        // Check a few points on the line
        for (float t = 0.0; t <= 1.0; t += 0.5) {
            float x = start.x + t * (end.x - start.x);
            float y = start.y + t * (end.y - start.y);
            
            // If the tapped point is within 20 points, let's return this line
            if (hypot(x - p.x, y - p.y) < 20.0) {
                return line;
            }
        }
    }
    
    // If nothing is close enough to the tapped point, then we didn't select a line
    return nil;
}

- (void)deleteLine:(id)sender
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    // Remove the selected line from from the list of completeLines
    [completeLines removeObject:[self selectedLine]];
    
    // Redraw everything
    [self setNeedsDisplay];
}

# pragma mark Gesture Recognizer methods

- (void)longPress:(UIGestureRecognizer *)gr
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    if ([gr state] == UIGestureRecognizerStateBegan) {
        CGPoint point = [gr locationInView:self];
        [self setSelectedLine:[self lineAtPoint:point]];
        
        if ([self selectedLine]) {
            [linesInProcess removeAllObjects];
        }
    } else if ([gr state] == UIGestureRecognizerStateEnded) {
        [self setSelectedLine:nil];
    }
    
    [self setNeedsDisplay];
}

- (void)pan:(UIPanGestureRecognizer *)gr
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    if (![self selectedLine]) {
        return;
    }
    
    // When the pan recognizer changes its position...
    if ([gr state] == UIGestureRecognizerStateChanged) {
        // How far has the pan moved?
        CGPoint translation = [gr translationInView:self];
        
        // Get velocity of the pan
        CGPoint velocityPoint = [gr velocityInView:self];
        
        float x = abs(velocityPoint.x);
        float y  = abs(velocityPoint.y);
        
        // Change line width depending on pan velocity
        if (x < 400.0 || y < 400) {
            // do nothing
        } else if (x < 800.0 || y < 800) {
            lineWidth = 20.0;
        } else if (x < 1200 || y < 1200) {
            lineWidth = 25.0;
        } else {
            lineWidth = 30.0;
        }
        
        // Add the transation to the current begin and end points of the line
        CGPoint begin = [[self selectedLine] begin];
        CGPoint end = [[self selectedLine] end];
        
        begin.x += translation.x;
        begin.y += translation.y;
        end.x += translation.x;
        end.y += translation.y;
        
        // Set the new beginning and end points of the line
        [[self selectedLine] setBegin:begin];
        [[self selectedLine] setEnd:end];
        
        // Redraw the screen
        [self setNeedsDisplay];
        
        // Reset translation to zero
        [gr setTranslation:CGPointZero inView:self];
    }
}

- (void)tap:(UITapGestureRecognizer *)gr
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    CGPoint point = [gr locationInView:self];
    [self setSelectedLine:[self lineAtPoint:point]];
    
    // If we just tapped, remove all lines in process
    // so that a tap doesn't result in a new line
    [linesInProcess removeAllObjects];
    
    if ([self selectedLine]) {
        [self becomeFirstResponder];
        
        // Grab the menu controller
        UIMenuController *menu = [UIMenuController sharedMenuController];
        
        // Create a new "Delete" UIMenuItem
        UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(deleteLine:)];
        [menu setMenuItems:[NSArray arrayWithObject:deleteItem]];
        
        // Tell the menu where it should come from and show it
        [menu setTargetRect:CGRectMake(point.x, point.y, 2, 2) inView:self];
        [menu setMenuVisible:YES animated:YES];
    } else {
        // Clear all lines
        [self clearAll];
        
        // Hide the menu if no line is selected
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    }
    
    [self setNeedsDisplay];
}

- (void)swipe:(UISwipeGestureRecognizer *)gr
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    // setup panel
    CGRect yellowColorRect = CGRectMake(0.0, 0.0, 100.0, 100.0);
    CGRect blueColorRect = CGRectMake(100.0, 0.0, 100.0, 100.0);
    CGRect orangeColorRect = CGRectMake(200.0, 0.0, 100.0, 100.0);
    
    yellowColorPanel = [[UIView alloc] initWithFrame:yellowColorRect];
    [yellowColorPanel setBackgroundColor:[UIColor yellowColor]];
    
    blueColorPanel = [[UIView alloc] initWithFrame:blueColorRect];
    [blueColorPanel setBackgroundColor:[UIColor blueColor]];
    
    orangeColorPanel = [[UIView alloc] initWithFrame:orangeColorRect];
    [orangeColorPanel setBackgroundColor:[UIColor orangeColor]];
    
    UITapGestureRecognizer *yellowTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(yellowColorTap:)];
    UITapGestureRecognizer *blueTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blueColorTap:)];
    UITapGestureRecognizer *orangeTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(orangeColorTap:)];
    
    [yellowColorPanel addGestureRecognizer:yellowTapRecognizer];
    [blueColorPanel addGestureRecognizer:blueTapRecognizer];
    [orangeColorPanel addGestureRecognizer:orangeTapRecognizer];
    
    // bring up yellow panel
    [UIView beginAnimations:nil context:NULL];
    [self addSubview:yellowColorPanel];
    [UIView commitAnimations];
    
    // bring up blue panel
    [UIView beginAnimations:nil context:NULL];
    [self addSubview:blueColorPanel];
    [UIView commitAnimations];
    
    // bring up orange panel
    [UIView beginAnimations:nil context:NULL];
    [self addSubview:orangeColorPanel];
    [UIView commitAnimations];
}

- (void)yellowColorTap:(UITapGestureRecognizer *)gr
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    drawingColor = [UIColor yellowColor];
    
    // hide up yellow panel
    [UIView beginAnimations:nil context:NULL];
    [yellowColorPanel removeFromSuperview];
    [blueColorPanel removeFromSuperview];
    [orangeColorPanel removeFromSuperview];
    [UIView commitAnimations];
    
    [linesInProcess removeAllObjects];
}

- (void)blueColorTap:(UITapGestureRecognizer *)gr
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    drawingColor = [UIColor blueColor];
    
    // hide up yellow panel
    [UIView beginAnimations:nil context:NULL];
    [yellowColorPanel removeFromSuperview];
    [blueColorPanel removeFromSuperview];
    [orangeColorPanel removeFromSuperview];
    [UIView commitAnimations];
    
    [linesInProcess removeAllObjects];
    
}

- (void)orangeColorTap:(UITapGestureRecognizer *)gr
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    drawingColor = [UIColor orangeColor];
    
    // hide up yellow panel
    [UIView beginAnimations:nil context:NULL];
    [yellowColorPanel removeFromSuperview];
    [blueColorPanel removeFromSuperview];
    [orangeColorPanel removeFromSuperview];
    [UIView commitAnimations];
    
    [linesInProcess removeAllObjects];
}

#pragma mark UIResponder Delegate methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    if ([touches count] == 1) {
        // Deselect the line to start drawing a new one
        if ([self selectedLine]) {
            [self setSelectedLine:nil];
            [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
        }
        
        for (UITouch *touch in touches) {
            // Use the touch object (packed in an NSValue) as the key
            NSValue *key = [NSValue valueWithNonretainedObject:touch];
            
            // Create a line for the value
            CGPoint loc = [touch locationInView:self];
            Line *newLine = [[Line alloc] init];
            [newLine setBegin:loc];
            [newLine setEnd:loc];
            
            // Put pair in dictionary
            [linesInProcess setObject:newLine forKey:key];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    // Update linesInProcess with moved touches
    for (UITouch *touch in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:touch];
        
        // Find the line for this touch
        Line *line = [linesInProcess objectForKey:key];
        
        // Update the line
        CGPoint loc = [touch locationInView:self];
        [line setEnd:loc];
    }
    
    // Redraw
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    [self endTouches:touches];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    [self endTouches:touches];
}

#pragma mark -
#pragma mark === Gesture Recognizer delegate methods ===
#pragma mark

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
    shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    if (gestureRecognizer == panRecognizer) {
        return YES;
    }
    
    return NO;
}

@end
