//
//  PFGridView.m
//  PFGridView
//
//  Created by YJ Park on 3/8/11.
//  Copyright 2011 PettyFun.com. All rights reserved.
//

#import "PFGridView.h"
#import "PFGridView+Internal.h"
#import "PFGridViewSection+Internal.h"

@implementation PFGridView
@synthesize dataSource;
@synthesize delegate;
@synthesize headerHeight;
@synthesize cellHeight;
@synthesize directionalLockEnabled;
@synthesize snapToGrid;
@synthesize snapToGridAnamationDuration;
@synthesize selectMode;
@synthesize selectAnimated;
@synthesize selectAnamationDuration;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    sections = [[NSMutableArray alloc] init];
    cellQueues = [[NSMutableDictionary alloc] init];
    headerHeight = 44.0f;
    cellHeight = 44.0f;    
    
    snapToGrid = NO;
    snapToGridAnamationDuration = 0.1f;
    selectAnamationDuration = 0.2f;
    selectAnimated = YES;
    
    selectMode = PFGridViewSelectModeRow;
    
    [self setupGestures];
}

- (void)dealloc
{
    [sections release];
    [cellQueues release];
    [selectedCellIndexPath release];
    [super dealloc];
}

#pragma mark - public methods;
- (void)reloadData {
    [cellQueues removeAllObjects];
    
    [self reloadSections];
    [self setNeedsDisplay];
}

- (PFGridViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier {
    PFGridViewCell *result = nil;

    NSMutableArray *queue = [cellQueues objectForKey:identifier];
    if (queue) {
        result = [[[queue lastObject] retain] autorelease];
        if (result) {
            [queue removeLastObject];
        }
    }

    return result;
}

- (PFGridViewSection *)section:(NSUInteger)sectionIndex {
    PFGridViewSection *result = nil;
    if (sectionIndex < sections.count) {
        result = [sections objectAtIndex:sectionIndex];
    }
    return result;
}

- (PFGridViewCell *) cellForColAtIndexPath:(PFGridIndexPath *)indexPath {
    PFGridViewCell *result = nil;
    PFGridViewSection *section = [self section:indexPath.section];
    if (section) {
        result = [section cellInView:section.gridView forColAtIndexPath:indexPath];
    }
    return result;
}

- (PFGridViewCell *) headerForColAtIndexPath:(PFGridIndexPath *)indexPath {
    PFGridViewCell *result = nil;
    PFGridViewSection *section = [self section:indexPath.section];
    if (section) {
        result = [section cellInView:section.headerView forColAtIndexPath:indexPath];
    }
    return result;    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (selectMode == PFGridViewSelectModeNone) {
        return NO;
    }
    return YES;
}

#pragma mark - seletion
- (PFGridIndexPath *)indexPathForSelectedCell {
    return selectedCellIndexPath;
}

- (void)selectCellAtIndexPath:(PFGridIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(PFGridViewScrollPosition)scrollPosition {
    if (indexPath == nil || [indexPath isEqual:selectedCellIndexPath]) return;

    [selectedCellIndexPath release];
    selectedCellIndexPath = [indexPath retain];

    [self scrollToCellAtIndexPath:selectedCellIndexPath animated:animated scrollPosition:scrollPosition];
}

- (void)scrollToCellAtIndexPath:(PFGridIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(PFGridViewScrollPosition)scrollPosition {
    
    CGFloat offsetY = 0;
    if (scrollPosition == PFGridViewScrollPositionNone) {
        for (PFGridViewSection *section in sections) {
            [section refreshScrollView:section.gridView];
        } 
        return;
    } else {
        //TODO scrollPosition not implemented
        offsetY = indexPath.row * cellHeight;
    }
    if (animated) {
        [UIView animateWithDuration:selectAnamationDuration
                         animations:^{
                             [self scrollFromSection:nil offsetY:offsetY];                    
                         }];
    } else {
        [self scrollFromSection:nil offsetY:offsetY];        
    }
}

@end
