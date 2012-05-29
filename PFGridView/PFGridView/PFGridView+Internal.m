//
//  PFGridView+Internal.m
//  PFGridView
//
//  Created by YJ Park on 3/8/11.
//  Copyright 2011 PettyFun.com. All rights reserved.
//

#import "PFGridView+Internal.h"
#import "PFGridViewSection+Internal.h"

@implementation PFGridView (PFGridView_Internal)

- (void)setupGestures {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.delegate = self;
    [self addGestureRecognizer:tapGesture]; 
    [tapGesture release];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self];
    BOOL inHeader = point.y < headerHeight;
    if (inHeader) return;
    PFGridIndexPath *indexPath = [self indexPathForColAtPoint:point];
    if ([selectedCellIndexPath isEqual:indexPath]) {
        return;
    }
    if (delegate && [delegate respondsToSelector:@selector(gridView:willDeselectCellAtIndexPath:)]) {
        if (![delegate gridView:self willDeselectCellAtIndexPath:selectedCellIndexPath]) {
            return;
        }
    }
    if (delegate && [delegate respondsToSelector:@selector(gridView:willSelectCellAtIndexPath:)]) {
        if (![delegate gridView:self willSelectCellAtIndexPath:indexPath]) {
            return;
        }
    }
    
    PFGridIndexPath *oldSelectedCellIndexPath = [selectedCellIndexPath retain];

    [self selectCellAtIndexPath:indexPath animated:selectAnimated scrollPosition:PFGridViewScrollPositionNone];

    if (oldSelectedCellIndexPath) {
        if (delegate && [delegate respondsToSelector:@selector(gridView:didDeselectCellAtIndexPath:)]) {
            [delegate gridView:self didDeselectCellAtIndexPath:oldSelectedCellIndexPath];
        }
        [oldSelectedCellIndexPath release];
        oldSelectedCellIndexPath = nil;
    }
    
    if (delegate && [delegate respondsToSelector:@selector(gridView:didSelectCellAtIndexPath:)]) {
        [delegate gridView:self didSelectCellAtIndexPath:selectedCellIndexPath];
    }
}

- (PFGridViewSection *)sectionAtPoint:(CGPoint)point {
    PFGridViewSection *result = nil;
    for (PFGridViewSection *section in [[sections copy] autorelease]) {
        if (CGRectContainsPoint(section.frame, point)) {
            result = section;
            break;
        }
    }
    return result;
}

- (PFGridIndexPath *)indexPathForColAtPoint:(CGPoint)point {
    PFGridIndexPath *result = nil;
    PFGridViewSection *section = [self sectionAtPoint:point];
    if (section) {
        CGPoint pointInGrid = CGPointMake(
                point.x - section.frame.origin.x + section.gridView.contentOffset.x,
                point.y - headerHeight + section.gridView.contentOffset.y);
        result = [section indexPathForColAtPoint:pointInGrid];
    }
    return result;
}

- (BOOL) isIndexPathSelected:(PFGridIndexPath *)indexPath {
    BOOL result = NO;
    if (selectMode == PFGridViewSelectModeCell) {
        if (indexPath && [indexPath isEqual:selectedCellIndexPath]) {
            result = YES;
        }
    } else if (selectMode == PFGridViewSelectModeRow) {
        if (indexPath && selectedCellIndexPath && indexPath.row == selectedCellIndexPath.row) {
            result = YES;
        }
    }
    return result;
}

- (void)reloadSections {
    if (dataSource == nil) {
        return;
    }
    
    NSUInteger numberOfSections = 1;
    if ([dataSource respondsToSelector:@selector(numberOfSectionsInGridView:)]) {
        numberOfSections = [dataSource numberOfSectionsInGridView:self];
    }
    
    if (numberOfSections < sections.count) {
        for (NSUInteger i = numberOfSections; i < sections.count; i++) {
            PFGridViewSection *section = [sections objectAtIndex:i];
            [section removeFromSuperview];
        }
        NSRange range;
        range.location = numberOfSections;
        range.length = sections.count - numberOfSections;
        [sections removeObjectsInRange:range];
    } else if (numberOfSections > sections.count){
        for (NSUInteger i = sections.count; i < numberOfSections; i++) {
            PFGridViewSection *section = [[[PFGridViewSection alloc] initWithFrame:CGRectZero] autorelease];
            section.owner = self;
            section.sectionIndex = i;
            [sections addObject:section];
            [self addSubview:section];
        }
    }
    
    [self resizeSections];
}

- (void)resizeSections {
    CGFloat x = 0.0f;
    
    for (PFGridViewSection *section in sections) {
        CGFloat sectionWidth = [dataSource widthForSection:section.sectionIndex];
        section.frame = CGRectMake(
            x, 0.0f, sectionWidth, self.frame.size.height
        );
        [section reloadData];
        x += sectionWidth;
    }
}

- (void)enqueueReusableCell:(PFGridViewCell *)cell {
    NSString *identifier = cell.reuseIdentifier;
    NSMutableArray *queue = [cellQueues objectForKey:identifier];
    if (queue == nil) {
        queue = [NSMutableArray array];
        [cellQueues setObject:queue forKey:identifier];
    }
    if (cell.selected) {
        cell.selected = NO;
    }
    [queue addObject:cell];
}

- (void)scrollFromSection:(PFGridViewSection *)section offsetY:(CGFloat)y {
    for (PFGridViewSection *oneSection in sections) {
        if (section != oneSection) {
            [oneSection scrollToOffsetY:y];
        }
    }
    if (section) {
        //section is nil means the call is from outside, then don't call the delegate
        if (delegate && [delegate respondsToSelector:@selector(gridView:scrollToOffsetY:)]) {
            [delegate gridView:self scrollToOffsetY:y];
        }
    }
}

- (void)willDisplayCell:(PFGridViewCell *)cell forRowAtIndexPath:(PFGridIndexPath *)indexPath {
    if (delegate && [delegate respondsToSelector:@selector(gridView:willDisplayCell:forColAtIndexPath:)]) {
        [delegate gridView:self willDisplayCell:cell forColAtIndexPath:indexPath];
    }
}

@end
