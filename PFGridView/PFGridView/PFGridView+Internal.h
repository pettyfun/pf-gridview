//
//  PFGridView+Internal.h
//  PFGridView
//
//  Created by YJ Park on 3/8/11.
//  Copyright 2011 PettyFun.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFGridView.h"

@class PFGridViewSection;
@interface PFGridView (PFGridView_Internal)

- (void)reloadSections;
- (void)resizeSections;

- (void)setupGestures;

- (void)enqueueReusableCell:(PFGridViewCell *)cell;

- (void)willDisplayCell:(PFGridViewCell *)cell forRowAtIndexPath:(PFGridIndexPath *)indexPath;

- (void)scrollFromSection:(PFGridViewSection *)section offsetY:(CGFloat)y;

- (PFGridViewSection *)sectionAtPoint:(CGPoint)point;

- (PFGridIndexPath *)indexPathForColAtPoint:(CGPoint)point;

- (BOOL) isIndexPathSelected:(PFGridIndexPath *)indexPath;
@end
