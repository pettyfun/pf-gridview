//
//  PFGridViewDemoViewController.m
//  PFGridViewDemo
//
//  Created by YJ Park on 3/8/11.
//  Copyright 2011 PettyFun.com. All rights reserved.
//

#import "PFGridViewDemoViewController.h"

@implementation PFGridViewDemoViewController

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    demoGridView.cellHeight = 60.0f;
    demoGridView.headerHeight = 60.0f;
    [demoGridView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [demoGridView reloadData];
}

#pragma mark - PFGridViewDataSource

- (NSUInteger)numberOfSectionsInGridView:(PFGridView *)gridView {
    return 2;
}

- (CGFloat)widthForSection:(NSUInteger)section {
    if (section == 0) {
        return 120.0f;
    } else {
        return demoGridView.frame.size.width - 120.0f;
    }
}

- (NSUInteger)numberOfRowsInGridView:(PFGridView *)gridView {
    return 100;
}

- (NSUInteger)gridView:(PFGridView *)gridView numberOfColsInSection:(NSUInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 100;
    }
}

- (CGFloat)gridView:(PFGridView *)gridView widthForColAtIndexPath:(PFGridIndexPath *)indexPath {
    return 120;
}

- (UIColor *) backgroundColorForIndexPath:(PFGridIndexPath *)indexPath {
    UIColor *result = nil;
    if (indexPath.section == 0) {
        if (indexPath.row % 2) {
            result = [UIColor colorWithRed:0.7 green:1.0 blue:0.7 alpha:1.0];        
        } else {
            result = [UIColor colorWithRed:0.8 green:1.0 blue:0.8 alpha:1.0];
        }
    } else {
        if (indexPath.row % 2) {
            if (indexPath.col % 2) {
                result = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
            } else {
                result = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.0];
                
            }
        } else {
            if (indexPath.col % 2) {
                result = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
            } else {
                result = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
            }
        }
    }
    return result;
}

- (PFGridViewCell *)gridView:(PFGridView *)gridView cellForColAtIndexPath:(PFGridIndexPath *)indexPath {
    PFGridViewLabelCell *gridCell = (PFGridViewLabelCell *)[gridView dequeueReusableCellWithIdentifier:@"LABEL"];
    if (gridCell == nil) {
        gridCell = [[[PFGridViewLabelCell alloc] initWithReuseIdentifier:@"LABEL"] autorelease];
        gridCell.textLabel.textAlignment = UITextAlignmentCenter;
        gridCell.selectedBackgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.8 alpha:1];
        gridCell.selectedForegrondColor = [UIColor whiteColor];
    }
    gridCell.textLabel.text = [NSString stringWithFormat:@"%d-%d", indexPath.row,  indexPath.col];
    gridCell.normalBackgroundColor = [self backgroundColorForIndexPath:indexPath];
    return gridCell;
}

- (UIColor *)headerBackgroundColorForIndexPath:(PFGridIndexPath *)indexPath {
    UIColor *result = nil;
    if (indexPath.section == 0) {
        result = [UIColor greenColor];
    } else {
        if (indexPath.col % 2) {
            result = [UIColor colorWithRed:0.4 green:0.4 blue:1.0 alpha:1.0];        
        } else {
            result = [UIColor colorWithRed:0.5 green:0.5 blue:1.0 alpha:1.0];
        }
    }
    return result;
}

- (PFGridViewCell *)gridView:(PFGridView *)gridView headerForColAtIndexPath:(PFGridIndexPath *)indexPath {
    PFGridViewLabelCell *gridCell = (PFGridViewLabelCell *)[gridView dequeueReusableCellWithIdentifier:@"HEADER"];
    if (gridCell == nil) {
        gridCell = [[[PFGridViewLabelCell alloc] initWithReuseIdentifier:@"HEADER"] autorelease];
        gridCell.textLabel.textAlignment = UITextAlignmentCenter;        
    }
    gridCell.textLabel.text = [NSString stringWithFormat:@"[ %d ]", indexPath.col];
    gridCell.normalBackgroundColor = [self headerBackgroundColorForIndexPath:indexPath];
    return gridCell;
}

- (void)gridView:(PFGridView *)gridView didClickHeaderAtIndexPath:(PFGridIndexPath *)indexPath {
    NSLog(@"didClickHeaderAtIndexPath %@", indexPath);
}

@end
