//
//  PFGridViewSection.h
//  PFGridView
//
//  Created by YJ Park on 3/8/11.
//  Copyright 2011 PettyFun.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFGridIndexPath.h"

@class PFGridView;

@interface PFGridViewSection : UIView <UIScrollViewDelegate> {
    PFGridView *owner;
    NSUInteger sectionIndex;
    
    NSUInteger numberOfRow, numberOfCol;
    NSMutableArray *colOriginXs;
    NSMutableArray *colWidths;
    
    //subViews
    UIScrollView *headerView;
    UIScrollView *gridView;    
}
@property (nonatomic, assign) PFGridView *owner;
@property (nonatomic, assign) NSUInteger sectionIndex;

@property (nonatomic, readonly) UIScrollView *headerView;
@property (nonatomic, readonly) UIScrollView *gridView;

@end
