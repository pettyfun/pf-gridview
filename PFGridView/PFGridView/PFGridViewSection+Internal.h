//
//  PFGridViewSection+Internal.h
//  PFGridView
//
//  Created by YJ Park on 3/10/11.
//  Copyright 2011 PettyFun.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFGridViewSection.h"
#import "PFGridViewCell.h"
#import "PFGridView.h"

@interface PFGridViewSection (PFGridViewSection_Internal)

//Used by PFGridView
- (void)reloadData;
- (void)scrollToOffsetY:(CGFloat)y;
- (void)scrollToCol:(NSUInteger)col scrollPosition:(PFGridViewScrollPosition)scrollPosition;

- (PFGridViewCell *) cellInView:(UIScrollView *)scrollView forColAtIndexPath:(PFGridIndexPath *)indexPath;

//internal usage
- (void)setupScrollView:(UIScrollView *)scrollView;
- (void)clearScrollView:(UIScrollView *)scrollView;

- (PFGridIndexPath *)indexPathForCol:(NSUInteger)col inRow:(NSUInteger)row;

- (void)snapToGrid:(UIScrollView *)scrollView;

// will return the visible ones, so can be used when showVisibleCells
- (NSSet *)hideUnvisibleCells:(UIScrollView *)scrollView;

- (void)showVisibleCells:(UIScrollView *)scrollView visibleIndexPathes:(NSSet *)visibleIndexPathes;

- (PFGridIndexPath *)indexPathForColAtPoint:(CGPoint)point;

- (CGRect)frameForCol:(NSUInteger)col inRow:(NSUInteger)row;

- (void)refreshScrollView:(UIScrollView *)scrollView;


@end
