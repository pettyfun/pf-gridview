//
//  PFGridViewCell.h
//  PFGridView
//
//  Created by YJ Park on 3/8/11.
//  Copyright 2011 PettyFun.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFGridIndexPath.h"

@interface PFGridViewCell : UIView {
    NSString *reuseIdentifier;
    PFGridIndexPath *indexPath;
    UIColor *normalBackgroundColor;
    UIColor *selectedBackgroundColor;
}
@property (nonatomic, copy) NSString *reuseIdentifier;
@property (nonatomic, retain) PFGridIndexPath *indexPath;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, retain) UIColor *normalBackgroundColor;
@property (nonatomic, retain) UIColor *selectedBackgroundColor;

- (id)initWithReuseIdentifier:(NSString *)identifier;

- (void)setSelected:(BOOL)newSelected animated:(BOOL)animated;

@end
