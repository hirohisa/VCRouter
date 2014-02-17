//
//  AppDelegate.m
//  VCRouter Example
//
//  Created by Hirohisa Kawasaki on 2014/02/12.
//  Copyright (c) 2014年 Hirohisa Kawasaki. All rights reserved.
//

#import "AppDelegate.h"
#import "EXVCRouter.h"
#import "DemoViewController.h"

@interface AppDelegate () <VCRouterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    self.window.rootViewController = [self rootViewController];
    [EXVCRouter mainRouter].window = self.window;
    [EXVCRouter mainRouter].delegate = self;
    return YES;
}

- (UIViewController *)rootViewController
{
    UIViewController *viewController = [[DemoViewController alloc] init];
    return [[UINavigationController alloc] initWithRootViewController:viewController];
}

- (void)applicationWillResignActive:(UIApplication *)application
{}

- (void)applicationDidEnterBackground:(UIApplication *)application
{}

- (void)applicationWillEnterForeground:(UIApplication *)application
{}

- (void)applicationDidBecomeActive:(UIApplication *)application
{}

- (void)applicationWillTerminate:(UIApplication *)application
{}

#pragma mark - VCRouter

- (BOOL)vcRouter:(VCRouter *)router canStackViewController:(UIViewController *)viewController
{
    Class aClass = [viewController class];

    int countOfSameClass = 0;
    for (UIViewController *vc in router.navigationController.viewControllers) {
        if ([viewController isMemberOfClass:aClass]) {
            countOfSameClass++;
        }
    }
    return countOfSameClass < 3;
}

@end
