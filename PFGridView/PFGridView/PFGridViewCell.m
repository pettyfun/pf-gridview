//
//  PFGridViewCell.m
//  PFGridView
//
//  Created by YJ Park on 3/8/11.
//  Copyright 2011 PettyFun.com. All rights reserved.
//

#import "PFGridViewCell.h"

@implementation PFGridViewCell
@synthesize reuseIdentifier;
@synthesize indexPath;
@synthesize selected;
@synthesize normalBackgroundColor;
@synthesize selectedBackgroundColor;

- (id)initWithReuseIdentifier:(NSString *)identifier {
    if ((self = [super init])) {
        self.reuseIdentifier = identifier;
        self.selectedBackgroundColor = [UIColor blueColor];
        self.normalBackgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)dealloc {
    self.normalBackgroundColor = nil;
    self.selectedBackgroundColor = nil;
    [reuseIdentifier release];
    [indexPath release];
    [super dealloc];
}

- (void)setSelected:(BOOL)newSelected {
    if (newSelected == selected) return;
    selected = newSelected;
    
    if (selected) {
        self.backgroundColor = selectedBackgroundColor;
    } else {
        self.backgroundColor = normalBackgroundColor;
    }    
}

- (void)setSelected:(BOOL)newSelected animated:(BOOL)animated {
    [self setSelected:newSelected];
    //animation not supported here
}

- (void)setNormalBackgroundColor:(UIColor *)newNormalBackgroundColor {
    if (normalBackgroundColor == newNormalBackgroundColor) return;
    [normalBackgroundColor release];
    normalBackgroundColor = [newNormalBackgroundColor retain];
    if (!selected) {
        self.backgroundColor = normalBackgroundColor;
    }
}

- (void)setSelectedBackgroundColor:(UIColor *)newSelectedBackgroundColor {
    if (selectedBackgroundColor == newSelectedBackgroundColor) return;
    [selectedBackgroundColor release];
    selectedBackgroundColor = [newSelectedBackgroundColor retain];
    if (selected) {
        self.backgroundColor = selectedBackgroundColor;
    }
}

@end
