//
//  PFGridView.h
//  PFGridView
//
//  Created by YJ Park on 3/8/11.
//  Copyright 2011 PettyFun.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFGridViewCell.h"
#import "PFGridViewLabelCell.h"
#import "PFGridViewSection.h"
#import "PFGridIndexPath.h"

@class PFGridView;

@protocol PFGridViewDataSource <NSObject>
@required
- (CGFloat)widthForSection:(NSUInteger)section;
- (NSUInteger)numberOfRowsInGridView:(PFGridView *)gridView;
- (NSUInteger)gridView:(PFGridView *)gridView numberOfColsInSection:(NSUInteger)section;
- (CGFloat)gridView:(PFGridView *)gridView widthForColAtIndexPath:(PFGridIndexPath *)indexPath;
- (PFGridViewCell *)gridView:(PFGridView *)gridView cellForColAtIndexPath:(PFGridIndexPath *)indexPath;
- (PFGridViewCell *)gridView:(PFGridView *)gridView headerForColAtIndexPath:(PFGridIndexPath *)indexPath;
@optional
- (NSUInteger)numberOfSectionsInGridView:(PFGridView *)gridView;
@end

@protocol PFGridViewDelegate <NSObject>
@required
@optional
- (void)gridView:(PFGridView *)gridView willDisplayCell:(PFGridViewCell *)cell forColAtIndexPath:(PFGridIndexPath *)indexPath;
- (BOOL)gridView:(PFGridView *)gridView willSelectCellAtIndexPath:(PFGridIndexPath *)indexPath;
- (void)gridView:(PFGridView *)gridView didSelectCellAtIndexPath:(PFGridIndexPath *)indexPath;
- (BOOL)gridView:(PFGridView *)gridView willDeselectCellAtIndexPath:(PFGridIndexPath *)indexPath;
- (void)gridView:(PFGridView *)gridView didDeselectCellAtIndexPath:(PFGridIndexPath *)indexPath;
- (void)gridView:(PFGridView *)gridView scrollToOffsetY:(CGFloat)offsetY;
@end

typedef enum {
    PFGridViewSelectModeNone,
    PFGridViewSelectModeCell,
    PFGridViewSelectModeRow
} PFGridViewSelectMode;

typedef enum {
    PFGridViewScrollPositionNone,
    PFGridViewScrollPositionTop,
    PFGridViewScrollPositionLeft,
    PFGridViewScrollPositionCenter,
    PFGridViewScrollPositionBottom,
    PFGridViewScrollPositionRight
} PFGridViewScrollPosition;

@interface PFGridView : UIView<UIGestureRecognizerDelegate> {
  @private
    id<PFGridViewDataSource> dataSource;
    id<PFGridViewDelegate> delegate;
    //for layout
    CGFloat headerHeight;
    CGFloat cellHeight;
    //setup
    BOOL directionalLockEnabled;
    BOOL snapToGrid;
    CGFloat snapToGridAnamationDuration;
    PFGridViewSelectMode selectMode;
    BOOL selectAnimated;
    CGFloat selectAnamationDuration;
    //Internal
    NSMutableArray *sections;
    NSMutableDictionary *cellQueues;
    PFGridIndexPath *selectedCellIndexPath;
}
@property (nonatomic, assign) IBOutlet id<PFGridViewDataSource> dataSource;
@property (nonatomic, assign) IBOutlet id<PFGridViewDelegate> delegate;

@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign) BOOL directionalLockEnabled;
@property (nonatomic, assign) BOOL snapToGrid;
@property (nonatomic, assign) CGFloat snapToGridAnamationDuration;
@property (nonatomic, assign) PFGridViewSelectMode selectMode;
@property (nonatomic, assign) BOOL selectAnimated;
@property (nonatomic, assign) CGFloat selectAnamationDuration;

- (void)reloadData;

- (PFGridViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;

- (PFGridViewSection *)section:(NSUInteger)sectionIndex;
- (PFGridViewCell *)cellForColAtIndexPath:(PFGridIndexPath *)indexPath;
- (PFGridViewCell *)headerForColAtIndexPath:(PFGridIndexPath *)indexPath;

- (PFGridIndexPath *)indexPathForSelectedCell;

//will not trigger (de)select event, scrollPosition not implemented yet, only none/top supported
- (void)selectCellAtIndexPath:(PFGridIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(PFGridViewScrollPosition)scrollPosition; 
//will not trigger scrollToOffsetY event, scrollPosition not implemented yet, , only none/top supported
- (void)scrollToCellAtIndexPath:(PFGridIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(PFGridViewScrollPosition)scrollPosition;

@end
