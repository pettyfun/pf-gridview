//
//  PFGridViewDemoAppDelegate.h
//  PFGridViewDemo
//
//  Created by YJ Park on 3/8/11.
//  Copyright 2011 PettyFun.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFGridViewDemoViewController;

@interface PFGridViewDemoAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet PFGridViewDemoViewController *viewController;

@end
