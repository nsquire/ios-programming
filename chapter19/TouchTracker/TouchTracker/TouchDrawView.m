//
//  TouchDrawView.m
//  TouchTracker
//
//  Created by Nick on 11/28/12.
//  Copyright (c) 2012 Nick. All rights reserved.
//

#include <math.h>

#import "TouchDrawView.h"
#import "Line.h"
#import "Circle.h"

@implementation TouchDrawView

- (id)initWithFrame:(CGRect)frame
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    self = [super initWithFrame:frame];
    
    if (self) {
        linesInProcess = [[NSMutableDictionary alloc] init];
        circlesInProcess = [[NSMutableDictionary alloc] init];
        completeCircles = [[NSMutableArray alloc] init];
        
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setMultipleTouchEnabled:YES];
        
        // Read in TouchTracker.xcdatamodeld
        model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        NSString *path = [self itemArchivePath];
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        NSError *error = nil;
        
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            [NSException raise:@"Open failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        // Create the managed object context
        objectContext = [[NSManagedObjectContext alloc] init];
        [objectContext setPersistentStoreCoordinator:psc];
        
        // The managed object context can manage undo, but we don't need it
        [objectContext setUndoManager:nil];
        
        // Load lines
        [self loadAllLines];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 10.0);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    // Draw complete lines in black
    [[UIColor blackColor] set];
    for (Line *line in completeLines) {
        //NSLog(@"Angle: %f", [TouchDrawView angleBetweenPoint:[line beginPoint] andSecondPoint:[line endPoint]]);
        CGFloat angle = [TouchDrawView angleBetweenPoint:[line beginPoint] andSecondPoint:[line endPoint]];
        if (angle >= 0 && angle < 180) {
            [[UIColor grayColor] set];
        } else if (angle < 0 && angle >= -180) {
            [[UIColor greenColor] set];
        }
        
        CGContextMoveToPoint(context, [line beginPoint].x, [line beginPoint].y);
        CGContextAddLineToPoint(context, [line endPoint].x, [line endPoint].y);
        CGContextStrokePath(context);
    }
    
    // Draw lines in process in red
    [[UIColor redColor] set];
    for (NSValue *v in linesInProcess) {
        Line *line = [linesInProcess objectForKey:v];
        CGContextMoveToPoint(context, [line beginPoint].x, [line beginPoint].y);
        CGContextAddLineToPoint(context, [line endPoint].x, [line endPoint].y);
        CGContextStrokePath(context);
    }
    
    // Draw circles in process in red
    [[UIColor redColor] set];
    for (NSValue *v in circlesInProcess) {
        Circle *circle = [circlesInProcess objectForKey:v];
        CGContextMoveToPoint(context, [circle originX], [circle originY]);
        CGContextStrokeEllipseInRect(context, CGRectMake([circle originX], [circle originY], [circle boundingBoxWidth], [circle boundingBoxHeight]));
        CGContextStrokePath(context);
    }
    
    // Draw completed circles in process in black
    [[UIColor blackColor] set];
    for (Circle *circle in completeCircles) {
        CGContextMoveToPoint(context, [circle originX], [circle originY]);
        CGContextStrokeEllipseInRect(context, CGRectMake([circle originX], [circle originY], [circle boundingBoxWidth], [circle boundingBoxHeight]));
        CGContextStrokePath(context);
    }
}

#pragma mark Custom Methods

- (void)loadAllLines
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    if (!completeLines) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [[model entitiesByName] objectForKey:@"Line"];
        [request setEntity:e];
        
        NSError *error = nil;
        NSArray *result = [objectContext executeFetchRequest:request error:&error];
        
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        completeLines = [[NSMutableArray alloc] initWithArray:result];
        NSLog(@"Count of complete lines: %i", [completeLines count]);
        
        for (Line *line in completeLines) {
            NSLog(@"Loading - Begin: %f, %f", [line beginPoint].x, [line beginPoint].y);
            NSLog(@"Loading - End: %f, %f", [line endPoint].x, [line endPoint ].y);
        }
    }
}

- (BOOL)saveChanges
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    for (Line *line in completeLines) {
        NSLog(@"Saving - Begin: %f, %f", [line beginPoint].x, [line beginPoint].y);
        NSLog(@"Saving - End: %f, %f", [line endPoint].x, [line endPoint].y);
    }
    
    NSError *error = nil;
    BOOL successful = [objectContext save:&error];
    if (!successful) {
        NSLog(@"Error saving %@", [error localizedDescription]);
    }
    
    return successful;
}

- (NSString *)itemArchivePath
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                       NSUserDomainMask,
                                                                       YES);
    
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}


- (void)clearAll
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    // Clear all collections
    [linesInProcess removeAllObjects];
    [completeLines removeAllObjects];
    [circlesInProcess removeAllObjects];
    [completeCircles removeAllObjects];
    
    for (Line *line in completeLines) {
        [objectContext deleteObject:line];
    }
    
    // Redraw
    [self setNeedsDisplay];
}

#pragma mark Touch methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    for (UITouch *touch in touches) {
        // Is this a double tap?
        if ([touch tapCount] > 1) {
            [self clearAll];
            return;
        }
    }

    if ([touches count] == 1) {
        NSLog(@"Single touch");
        
        for (UITouch *touch in touches) {
            
            // Use the touch object (packed in an NSValue) as the key
            NSValue *key = [NSValue valueWithNonretainedObject:touch];
            
            // Create a line for the value
            CGPoint loc = [touch locationInView:self];
            Line *newLine = [NSEntityDescription insertNewObjectForEntityForName:@"Line"
                                                          inManagedObjectContext:objectContext];
            
            [newLine setBeginPoint:loc];
            [newLine setEndPoint:loc];
            
            // Put pair in dictionary
            [linesInProcess setObject:newLine forKey:key];
        }
    } else if ([touches count] == 2) {
        NSLog(@"Double touch");
        
        NSValue *key = [NSValue valueWithNonretainedObject:[[touches allObjects] objectAtIndex:0]];
        NSLog(@"key: %@", key);
    
        // Get references to the first and second touches
        UITouch *firstTouch = [[touches allObjects] objectAtIndex:0];
        NSLog(@"Begin First: %f, %f", [firstTouch locationInView:self].x, [firstTouch locationInView:self].y);
        UITouch *secondTouch = [[touches allObjects] objectAtIndex:1];
        NSLog(@"Begin Second: %f, %f", [secondTouch locationInView:self].x, [secondTouch locationInView:self].y);
        
        // Setup convenience variables to make getting some common data easier
        CGFloat firstX = [firstTouch locationInView:self].x;
        CGFloat firstY = [firstTouch locationInView:self].y;
        CGFloat secondX = [secondTouch locationInView:self].x;
        CGFloat secondY = [secondTouch locationInView:self].y;
        CGFloat width = (firstX < secondX) ? (secondX - firstX) : (firstX - secondX);
        CGFloat height = (firstY < secondY) ? (secondY - firstY) : (firstY - secondY);
        CGFloat boxBounds = (width < height) ? height : width;
        
        // Setup our in process circle
        Circle *circle = [[Circle alloc] init];
        [circle setBoundingBoxWidth:boxBounds];
        [circle setBoundingBoxHeight:boxBounds];
        [circle setOriginX:(firstX < secondX) ? firstX : secondX];
        [circle setOriginY:(firstY < secondY) ? firstY : secondY];
        
        // Add the circle to the in process dictionary
        [circlesInProcess setObject:circle forKey:key];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    if ([touches count] == 1) {
        NSLog(@"Single touch");
        // Update linesInProcess with moved touches
        for (UITouch *touch in touches) {
            NSValue *key = [NSValue valueWithNonretainedObject:touch];
            
            // Find the line for this touch
            Line *line = [linesInProcess objectForKey:key];
            
            // Update the line
            CGPoint loc = [touch locationInView:self];
            [line setEndPoint:loc];
        }

    } else if ([touches count] == 2) {
        NSLog(@"Double touch");
        
        NSValue *key = [NSValue valueWithNonretainedObject:[[touches allObjects] objectAtIndex:0]];
        NSLog(@"key: %@", key);
        Circle *circle = [circlesInProcess objectForKey:key];
        
        UITouch *firstTouch = [[touches allObjects] objectAtIndex:0];
        NSLog(@"Update First: %f, %f", [firstTouch locationInView:self].x, [firstTouch locationInView:self].y);
        UITouch *secondTouch = [[touches allObjects] objectAtIndex:1];
        NSLog(@"Update Second: %f, %f", [secondTouch locationInView:self].x, [secondTouch locationInView:self].y);
        
        CGFloat firstX = [firstTouch locationInView:self].x;
        CGFloat firstY = [firstTouch locationInView:self].y;
        CGFloat secondX = [secondTouch locationInView:self].x;
        CGFloat secondY = [secondTouch locationInView:self].y;
        CGFloat width = (firstX < secondX) ? (secondX - firstX) : (firstX - secondX);
        CGFloat height = (firstY < secondY) ? (secondY - firstY) : (firstY - secondY);
        CGFloat boxBounds = (width < height) ? height : width;
        
        // Update our in process circle
        [circle setBoundingBoxWidth:boxBounds];
        [circle setBoundingBoxHeight:boxBounds];
        [circle setOriginX:(firstX < secondX) ? firstX : secondX];
        [circle setOriginY:(firstY < secondY) ? firstY : secondY];
    }
    
    // Redraw
    [self setNeedsDisplay];
}

- (void)endTouches:(NSSet *)touches
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    if ([touches count] == 1) {
        // Remove ending touches from dictionary
        for (UITouch *touch in touches) {
            NSValue *key = [NSValue valueWithNonretainedObject:touch];
            Line *line = [linesInProcess objectForKey:key];
            
            // If this is a double tap, 'line' will be nil,
            // so make sure not to add it to the array
            if (line) {
                [completeLines addObject:line];
                [linesInProcess removeObjectForKey:key];
                
                NSLog(@"Saving line...");
                [self saveChanges];
            }
        }
    } else if ([touches count] == 2) {
        NSLog(@"Double touch");
        
        NSValue *key = [NSValue valueWithNonretainedObject:[[touches allObjects] objectAtIndex:0]];
        Circle *circle = [circlesInProcess objectForKey:key];
        
        if (circle) {
            [completeCircles addObject:circle];
            [circlesInProcess removeObjectForKey:key];
        }
    }
        
    // Redraw
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endTouches:touches];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endTouches:touches];
}

#pragma mark Utility methods

+ (CGFloat)angleBetweenPoint:(CGPoint) firstPoint andSecondPoint:(CGPoint) secondPoint;
{
    CGFloat height = secondPoint.y - firstPoint.y;
    CGFloat width = firstPoint.x - secondPoint.x;
    CGFloat bearingInRadians = atan2f(height, width);
    CGFloat bearingInDegrees = bearingInRadians * (180.0 / M_PI);
    
    return bearingInDegrees;
}

@end
