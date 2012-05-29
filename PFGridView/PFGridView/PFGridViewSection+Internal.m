//
//  PFGridViewSection+Internal.m
//  PFGridView
//
//  Created by YJ Park on 3/10/11.
//  Copyright 2011 PettyFun.com. All rights reserved.
//

#import "PFGridViewSection+Internal.h"
#import "PFGridIndexPath.h"
#import "PFGridView+Internal.m"

@implementation PFGridViewSection (PFGridViewSection_Internal)

#pragma mark - Used by PFGridView
- (void)reloadData {
    [self clearScrollView:headerView];
    [self clearScrollView:gridView];
    
    id<PFGridViewDataSource> dataSource = owner.dataSource;
    if (dataSource == nil) {
        return;
    }
    numberOfRow = [dataSource numberOfRowsInGridView:owner];
    numberOfCol = [dataSource gridView:owner numberOfColsInSection:sectionIndex];
    [colOriginXs removeAllObjects];
    [colWidths removeAllObjects];
    
    CGFloat gridWidth = 0.0f;
    for (int i = 0; i < numberOfCol; i++) {
        [colOriginXs addObject:[NSNumber numberWithFloat:gridWidth]];
        CGFloat colWidth = [dataSource gridView:owner widthForColAtIndexPath:[self indexPathForCol:i inRow:0]];
        gridWidth += colWidth;
        [colWidths addObject:[NSNumber numberWithFloat:colWidth]];
    }
    
    headerView.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, owner.headerHeight);
    gridView.frame = CGRectMake(0.0f, owner.headerHeight, self.frame.size.width, self.frame.size.height - owner.headerHeight);
    
    headerView.contentSize = CGSizeMake(gridWidth, owner.headerHeight);
    gridView.contentSize = CGSizeMake(gridWidth, owner.cellHeight * numberOfRow);
        
    [self scrollViewDidScroll:headerView];
    [self scrollViewDidScroll:gridView];
}

- (void) scrollToOffsetY:(CGFloat)y {
    gridView.contentOffset = CGPointMake(gridView.contentOffset.x, y);
}

- (void)scrollToCol:(NSUInteger)col scrollPosition:(PFGridViewScrollPosition)scrollPosition {
    if (col < numberOfCol) {
        CGFloat originX = ((NSNumber *)[colOriginXs objectAtIndex:col]).floatValue;
        gridView.contentOffset = CGPointMake(originX, gridView.contentOffset.y);
    }
    //TODO: scroll style not supported yet.
}

- (PFGridViewCell *) cellInView:(UIScrollView *)scrollView forColAtIndexPath:(PFGridIndexPath *)indexPath {
    PFGridViewCell *result = nil;
    for (UIView *view in [[scrollView.subviews copy] autorelease]) {
        if ([[view class] isSubclassOfClass:[PFGridViewCell class]]) {
            PFGridViewCell *cell = (PFGridViewCell *)view;
            if ([cell.indexPath isEqual:indexPath]) {
                result = cell;
                break;
            }
        }
    }
    return result;
}

#pragma mark - Internal
- (void)setupScrollView:(UIScrollView *)scrollView {
    scrollView.delegate = self;
    scrollView.clipsToBounds = YES;
    scrollView.directionalLockEnabled = owner.directionalLockEnabled;
    scrollView.scrollEnabled = YES;
    scrollView.scrollsToTop = (scrollView == gridView);
    [self addSubview:scrollView];
}

- (void)clearScrollView:(UIScrollView *)scrollView {
    for (UIView *view in [[scrollView.subviews copy] autorelease]) {
        if ([[view class] isSubclassOfClass:[PFGridViewCell class]]) {
            [view removeFromSuperview];
        }
    }    
}

- (PFGridIndexPath *)indexPathForCol:(NSUInteger)col inRow:(NSUInteger)row {
    if (row >= numberOfRow) row = numberOfRow - 1;
    if (col >= numberOfCol) col = numberOfCol - 1;
    return [PFGridIndexPath indexPathForCol:col inRow:row inSection:sectionIndex];
}

- (NSSet *)hideUnvisibleCells:(UIScrollView *)scrollView {
    //showing some extra cells, for a better animation effects
    CGRect visibleRect = CGRectMake(scrollView.contentOffset.x - owner.cellHeight,
                                    scrollView.contentOffset.y - owner.cellHeight,
                                    scrollView.frame.size.width + owner.cellHeight * 2.0f,
                                    scrollView.frame.size.height + owner.cellHeight * 2.0f);
    
    int count = 0;
    NSMutableSet *result = [NSMutableSet set];
    for (UIView *view in [[scrollView.subviews copy] autorelease]) {
        if ([[view class] isSubclassOfClass:[PFGridViewCell class]]) {
            PFGridViewCell *cell = (PFGridViewCell *)view;
            if (!CGRectIntersectsRect(cell.frame, visibleRect)) {
                [owner enqueueReusableCell:cell];
                [cell removeFromSuperview];
                count++;
            } else {
                [result addObject:cell.indexPath];
            }
        }
    }
    //NSLog(@"hideUnvisibleCells: %d", count);
    return result;
}

- (void)showVisibleCells:(UIScrollView *)scrollView visibleIndexPathes:(NSSet *)visibleIndexPathes {
    id<PFGridViewDataSource> dataSource = owner.dataSource;
    if (dataSource == nil) {
        return;
    }    
    
    BOOL inGrid = (scrollView == gridView);
    PFGridIndexPath *indexPath = [self indexPathForColAtPoint:scrollView.contentOffset];
    NSUInteger row = indexPath.row;
    NSUInteger col = indexPath.col;
    
    CGRect visibleRect = CGRectMake(scrollView.contentOffset.x,
                                    scrollView.contentOffset.y,
                                    scrollView.frame.size.width,
                                    scrollView.frame.size.height);
    
    BOOL hasMoreRow = YES;
    int count = 0;
    while (hasMoreRow) {
        BOOL hasMoreCol = YES;
        NSUInteger currentCol = col;
        while (hasMoreCol) {
            if (currentCol < numberOfCol) {
                PFGridIndexPath *indexPath = [self indexPathForCol:currentCol inRow:row];
                if (![visibleIndexPathes containsObject:indexPath]) {
                    CGRect cellFrame = [self frameForCol:currentCol inRow:row];
                    if (CGRectIntersectsRect(cellFrame, visibleRect)) {
                        PFGridViewCell *cell = nil;
                        if (scrollView == headerView) {
                            cell = [dataSource gridView:owner headerForColAtIndexPath:indexPath];
                        } else {
                            cell = [dataSource gridView:owner cellForColAtIndexPath:indexPath];                        
                        }
                        if (cell) {
                            //cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            cell.indexPath = indexPath;
                            cell.frame = cellFrame;
                            //insert at the begining incase hide the indicator
                            [scrollView insertSubview:cell atIndex:0];
                            BOOL selected = (inGrid && [owner isIndexPathSelected:indexPath]);
                            if (cell.selected != selected) {
                                cell.selected = selected;
                            }
                            if (inGrid && [owner isIndexPathSelected:indexPath]) {
                            }
                            [owner willDisplayCell:cell forRowAtIndexPath:indexPath];
                            count++;
                        }
                    } else {
                        hasMoreCol = NO;                    
                    }
                }
                currentCol++;
            } else {
                hasMoreCol = NO;
            }
        }
        
        if (scrollView == headerView) {
            hasMoreRow = NO;
        } else {
            row++;
            if (row * owner.cellHeight > scrollView.contentOffset.y + scrollView.frame.size.height 
                || row >= numberOfRow) {
                hasMoreRow = NO;
            }
        }
    }
    
    if (inGrid) {
        for (PFGridIndexPath *indexPath in visibleIndexPathes) {
            PFGridViewCell *cell = [self cellInView:gridView forColAtIndexPath:indexPath];
            if (cell) {
                BOOL selected = [owner isIndexPathSelected:indexPath];
                if (cell.selected != selected) {
                    [cell setSelected:selected animated:owner.selectAnimated];
                }
            }
        }
    }
    //NSLog(@"showVisibleCells: %d", count);
}

- (CGRect)frameForCol:(NSUInteger)col inRow:(NSUInteger)row {
    CGRect result = CGRectZero;
    if ((row < numberOfRow) && (col < numberOfCol)) {
        CGFloat originX = ((NSNumber *)[colOriginXs objectAtIndex:col]).floatValue;
        CGFloat width = ((NSNumber *)[colWidths objectAtIndex:col]).floatValue;
        CGFloat originY = row * owner.cellHeight;
        result = CGRectMake(originX, originY, width, owner.cellHeight);
    }
    return result;
}

- (PFGridIndexPath *)indexPathForColAtPoint:(CGPoint)point {
    NSUInteger col = numberOfCol - 1;
    for (int i = 1; i < colOriginXs.count; i++) {
        CGFloat originX = ((NSNumber *)[colOriginXs objectAtIndex:i]).floatValue;
        if (originX > point.x) {
            col = i - 1;
            break;
        }
    }
    NSUInteger row = (int)floorf(point.y / owner.cellHeight);
    return [self indexPathForCol:col inRow:row];
}

- (void)snapToGrid:(UIScrollView *)scrollView {
    PFGridIndexPath *indexPath = [self indexPathForColAtPoint:scrollView.contentOffset];
    CGRect cellFrame = [self frameForCol:indexPath.col inRow:indexPath.row];
    
    BOOL inGrid = (scrollView == gridView);
    //matching to row
    NSUInteger row = indexPath.row;
    if ((scrollView.contentOffset.y - cellFrame.origin.y > cellFrame.size.height / 2.0f)
       || (inGrid && (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height))) {
        if (indexPath.row < numberOfRow - 1) {
            row ++;
            cellFrame = [self frameForCol:indexPath.col inRow:row];
        }
    }
    
    //matching to col
    if ((scrollView.contentOffset.x - cellFrame.origin.x > cellFrame.size.width / 2.0f)
        || (scrollView.contentOffset.x + scrollView.frame.size.width >= scrollView.contentSize.width)) {
        if (indexPath.col < numberOfCol - 1) {
            cellFrame = [self frameForCol:indexPath.col + 1 inRow:row];
        }
    }
    
    scrollView.contentOffset = cellFrame.origin;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        if (owner.snapToGrid) {
            [self scrollViewDidEndDecelerating:scrollView];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (owner.snapToGrid) {
        [UIView transitionWithView:self
                          duration:owner.snapToGridAnamationDuration
                           options:UIViewAnimationOptionTransitionNone
                        animations:^{
                            [self snapToGrid:scrollView];
                        }
                        completion:NULL];
    }
}

- (void)refreshScrollView:(UIScrollView *)scrollView {
    //remove unvisible cells and put them back to reuse queue.
    NSSet *visibleIndexPathes = [self hideUnvisibleCells:scrollView];
    //NSLog(@"CCCC %d", visibleIndexPathes.count);
    //showing the new visible cells for both scrollViews
    [self showVisibleCells:scrollView visibleIndexPathes:visibleIndexPathes];    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //synchronize the two scrollview.
    if (scrollView == headerView) {
        gridView.contentOffset = CGPointMake(scrollView.contentOffset.x, gridView.contentOffset.y);
    } else {
        headerView.contentOffset = CGPointMake(scrollView.contentOffset.x, headerView.contentOffset.y);
    }
    
    [self refreshScrollView:scrollView];
    
    if (scrollView == gridView) {
        [owner scrollFromSection:self offsetY:gridView.contentOffset.y];
    }
}

@end
