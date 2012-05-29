//
//  NSIndexPath+PFGridView.h
//  PFGridView
//
//  Created by YJ Park on 3/8/11.
//  Copyright 2011 PettyFun.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PFGridIndexPath : NSObject {
    NSUInteger section;
    NSUInteger row;
    NSUInteger col;
}
@property (nonatomic, readonly) NSUInteger section;
@property (nonatomic, readonly) NSUInteger row;
@property (nonatomic, readonly) NSUInteger col;
           
+ (PFGridIndexPath *)indexPathForCol:(NSUInteger)col inRow:(NSUInteger)row inSection:(NSUInteger)section;

- (id)initForCol:(NSUInteger)pathCol inRow:(NSUInteger)pathRow inSection:(NSUInteger)pathSection;

@end
