//
//  TouchDrawView.h
//  TouchTracker
//
//  Created by Nick on 11/28/12.
//  Copyright (c) 2012 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TouchDrawView : UIView
{
    NSMutableDictionary *linesInProcess;
    NSMutableDictionary *circlesInProcess;
    NSMutableArray *completeLines;
    NSMutableArray *completeCircles;
    
    NSManagedObjectContext *objectContext;
    NSManagedObjectModel *model;
}

+ (CGFloat)angleBetweenPoint:(CGPoint) firstPoint andSecondPoint:(CGPoint) secondPoint;

- (void)clearAll;
- (void)endTouches:(NSSet *)touches;

- (NSString *)itemArchivePath;
- (BOOL)saveChanges;

@end
