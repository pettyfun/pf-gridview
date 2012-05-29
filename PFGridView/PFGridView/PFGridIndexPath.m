//
//  NSIndexPath+PFGridView.m
//  PFGridView
//
//  Created by YJ Park on 3/8/11.
//  Copyright 2011 PettyFun.com. All rights reserved.
//

#import "PFGridIndexPath.h"


@implementation PFGridIndexPath
@synthesize section;
@synthesize row;
@synthesize col;

+ (PFGridIndexPath *)indexPathForCol:(NSUInteger)col inRow:(NSUInteger)row inSection:(NSUInteger)section {
    return [[[PFGridIndexPath
              alloc] initForCol:col inRow:row inSection:section] autorelease];
}

- (id)initForCol:(NSUInteger)pathCol inRow:(NSUInteger)pathRow inSection:(NSUInteger)pathSection {
    if ((self = [super init])) {
        section = pathSection;
        row = pathRow;
        col = pathCol;
    }
    return self;
}

- (NSUInteger)hash {
    return section * 100000000 + row * 10000 + col;
}

- (BOOL)isEqual:(id)object {
    BOOL result = NO;
    if (object && [object isMemberOfClass:[PFGridIndexPath class]]) {
        PFGridIndexPath *path = (PFGridIndexPath *)object;
        if ((section == path.section) && (row == path.row) && (col == path.col)) {
            result = YES;
        }
    }
    return result;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"PFGridIndexPath: section = %d, row = %d, col = %d", section, row, col];
}

@end
