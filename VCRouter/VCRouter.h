//
//  VCRouter.h
//  VCRouter
//
//  Created by Hirohisa Kawasaki on 13/04/23.
//  Copyright (c) 2013年 Hirohisa Kawasaki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class VCRouter;

@protocol VCRouterDelegate <NSObject>

@optional

//
// use `pushViewController:animated:`, then navigation controller has same class in view controllers,
// pop same class's view controller in view controllers.
// if you control to push view controller, use `vcRouter:canStackViewController:`
//
- (BOOL)vcRouter:(VCRouter *)router canStackViewController:(UIViewController *)viewController;

@end

@interface VCRouter : NSObject

@property (nonatomic, assign) UIWindow *window;
@property (nonatomic, assign, readonly) UINavigationController *navigationController;

@property (nonatomic, assign) id<VCRouterDelegate> delegate;

//
// Returns the default singleton instance.
//
+ (instancetype)mainRouter;

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end
