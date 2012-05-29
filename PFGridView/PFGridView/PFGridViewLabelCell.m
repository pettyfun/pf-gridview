//
//  PFGridViewLabelCell.m
//  PFGridView
//
//  Created by YJ Park on 3/11/11.
//  Copyright 2011 PettyFun.com All rights reserved.
//

#import "PFGridViewLabelCell.h"


@implementation PFGridViewLabelCell
@synthesize textLabel;
@synthesize margin;

- (id)initWithReuseIdentifier:(NSString *)identifier {
    if ((self = [super initWithReuseIdentifier:identifier])) {
        textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:textLabel];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    CGRect labelFrame = CGRectMake(margin, 0,
                                   frame.size.width - margin * 2,
                                   frame.size.height);
    textLabel.frame = labelFrame;
}

@end
