//
//  PFGridViewLabelCell.h
//  PFGridView
//
//  Created by YJ Park on 3/11/11.
//  Copyright 2011 PettyFun.com All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFGridViewCell.h"

@interface PFGridViewLabelCell : PFGridViewCell {
    UILabel *textLabel;
    CGFloat margin;
}
@property (nonatomic, readonly) UILabel *textLabel;
@property (nonatomic, assign) CGFloat margin;
@end
