//
//  PFGridViewSection.m
//  PFGridView
//
//  Created by YJ Park on 3/8/11.
//  Copyright 2011 PettyFun.com. All rights reserved.
//

#import "PFGridViewSection.h"
#import "PFGridViewSection+Internal.m"

@implementation PFGridViewSection
@synthesize owner;
@synthesize sectionIndex;
@synthesize headerView;
@synthesize gridView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        headerView = [[UIScrollView alloc] init];
        gridView = [[UIScrollView alloc] init];
        
        [self setupScrollView:headerView];
        [self setupScrollView:gridView];

        colOriginXs = [[NSMutableArray alloc] init];
        colWidths = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    [headerView release];
    [gridView release];
    [colOriginXs release];
    [colWidths release];
    [super dealloc];
}


@end
