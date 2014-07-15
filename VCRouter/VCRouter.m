//
//  VCRouter.m
//  VCRouter
//
//  Created by Hirohisa Kawasaki on 13/04/23.
//  Copyright (c) 2013年 Hirohisa Kawasaki. All rights reserved.
//

#import <objc/runtime.h>
#import "VCRouter.h"

void VCSwizzleInstanceMethod(Class c, SEL original, SEL alternative)
{
    Method orgMethod = class_getInstanceMethod(c, original);
    Method altMethod = class_getInstanceMethod(c, alternative);
    if(class_addMethod(c, original, method_getImplementation(altMethod), method_getTypeEncoding(altMethod))) {
        class_replaceMethod(c, alternative, method_getImplementation(orgMethod), method_getTypeEncoding(orgMethod));
    } else {
        method_exchangeImplementations(orgMethod, altMethod);
    }
}

//
// NSArray
//
@implementation NSArray (VCRouter)

- (NSUInteger)indexOfViewControllerWithClass:(Class)aClass
{
    NSUInteger index = 0;
    for (id object in self) {
        if ([object isMemberOfClass:aClass]) {
            return index;
        }
        index++;
    }
    return NSNotFound;
}

@end

//
// VCRouter
//
@interface VCRouter () <UINavigationControllerDelegate>

@property (nonatomic, getter = isAnimated) BOOL animated;

@end

//
// UIWindow
//
@implementation UIWindow (VCRouter)

+ (void)load
{
    VCSwizzleInstanceMethod([self class], @selector(setRootViewController:), @selector(vc_setRootViewController:));
}

- (void)vc_setRootViewController:(UIViewController *)rootViewController
{
    if (self.rootViewController) {
        for (UIView *view in self.subviews) {
            [view removeFromSuperview];
        }
    }
    [self vc_setRootViewController:rootViewController];
}

@end

//
// UIVieController
//
@implementation UIViewController (VCRouter)

+ (void)load
{
    VCSwizzleInstanceMethod([self class], @selector(presentModalViewController:animated:), @selector(vc_presentModalViewController:animated:));
    VCSwizzleInstanceMethod([self class], @selector(presentViewController:animated:completion:), @selector(vc_presentViewController:animated:completion:));
}

- (void)vc_presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated
{
    if ([self vc_canPresentViewController]) {
        VCRouter *router = (VCRouter *)self.navigationController.delegate;
        router.animated = animated;
        [self vc_presentModalViewController:modalViewController animated:animated];
        [self performSelectorOnMainThread:@selector(vc_animationDidEnd) withObject:nil waitUntilDone:YES];
    }
}

- (void)vc_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    if ([self vc_canPresentViewController]) {
        VCRouter *router = (VCRouter *)self.navigationController.delegate;
        router.animated = flag;
        [self vc_presentViewController:viewControllerToPresent animated:flag completion:^{
            router.animated = NO;
            if (completion) {
                completion();
            }
        }];
    }
}

- (BOOL)vc_canPresentViewController
{
    if ([self.navigationController.delegate isKindOfClass:[VCRouter class]]) {
        VCRouter *router = (VCRouter *)self.navigationController.delegate;
        if (router.animated) {
            return NO;
        }
    }

    return YES;
}

- (void)vc_animationDidEnd
{
    NSLog(@"%s", __func__);
    VCRouter *router = (VCRouter *)self.navigationController.delegate;
    router.animated = NO;
}

@end

//
// UINavigationController
//
@interface UINavigationController (VCRouter)

@property (nonatomic, assign) id<UINavigationControllerDelegate> VCDelegate;

@end

@implementation UINavigationController (VCRouter)

static const char *VCRouterDelegateKey = "VCRouterDelegateKey";

+ (void)load
{
    VCSwizzleInstanceMethod([self class], @selector(setDelegate:), @selector(vc_setDelegate:));
    VCSwizzleInstanceMethod([self class], @selector(popViewControllerAnimated:), @selector(vc_popViewControllerAnimated:));
    VCSwizzleInstanceMethod([self class], @selector(popToViewController:animated:), @selector(vc_popToViewController:animated:));
    VCSwizzleInstanceMethod([self class], @selector(popToRootViewControllerAnimated:), @selector(vc_popToRootViewControllerAnimated:));
}

- (void)vc_setDelegate:(id<UINavigationControllerDelegate>)delegate
{
    if (self.delegate) {
        if ([[delegate class] isSubclassOfClass:[VCRouter class]]) {
            self.VCDelegate = self.delegate;
        }
    }
    [self vc_setDelegate:delegate];
}

- (id<UINavigationControllerDelegate>)VCDelegate
{
    return objc_getAssociatedObject(self, VCRouterDelegateKey);
}

- (void)setVCDelegate:(id<UINavigationControllerDelegate>)VCDelegate
{
    objc_setAssociatedObject(self, VCRouterDelegateKey, VCDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (UIViewController *)vc_popViewControllerAnimated:(BOOL)animated
{
    if (![self isAnimating]) {
        [self vc_configureWithAnimated:animated];
        return [self vc_popViewControllerAnimated:animated];
    }
    return nil;
}

- (NSArray *)vc_popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (![self isAnimating]) {
        [self vc_configureWithAnimated:animated];
        return [self vc_popToViewController:viewController animated:animated];
    }
    return nil;
}

- (NSArray *)vc_popToRootViewControllerAnimated:(BOOL)animated
{
    if (![self isAnimating]) {
        [self vc_configureWithAnimated:animated];
        return [self vc_popToRootViewControllerAnimated:animated];
    }
    return nil;
}

- (BOOL)isAnimating
{
    if ([self.delegate isKindOfClass:[VCRouter class]]) {
        VCRouter *delegate = (VCRouter *)self.delegate;
        return delegate.animated;
    }
    return NO;
}

- (void)vc_configureWithAnimated:(BOOL)animated
{
    if ([self.delegate isKindOfClass:[VCRouter class]] &&
        [self.viewControllers count] > 1) {
        VCRouter *delegate = (VCRouter *)self.delegate;
        delegate.animated = animated;
    }
}

@end

//
// VCRouter UINavigationControllerDelegate
//
@implementation VCRouter (UINavigationControllerDelegate)

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.animated = animated;
    if (navigationController.VCDelegate &&
        [navigationController.VCDelegate respondsToSelector:@selector(navigationController:willShowViewController:animated:)]) {
        [navigationController.VCDelegate navigationController:navigationController willShowViewController:viewController animated:animated];
    }
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.animated = NO;
    if (navigationController.VCDelegate &&
        [navigationController.VCDelegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)]) {
        [navigationController.VCDelegate navigationController:navigationController didShowViewController:viewController animated:animated];
    }
}

- (NSUInteger)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController
{
    if (navigationController.VCDelegate &&
        [navigationController.VCDelegate respondsToSelector:@selector(navigationControllerSupportedInterfaceOrientations:)]) {
        return [navigationController.VCDelegate navigationControllerSupportedInterfaceOrientations:navigationController];
    }
    return -1;
}

- (UIInterfaceOrientation)navigationControllerPreferredInterfaceOrientationForPresentation:(UINavigationController *)navigationController
{
    if (navigationController.VCDelegate &&
        [navigationController.VCDelegate respondsToSelector:@selector(navigationControllerPreferredInterfaceOrientationForPresentation:)]) {
        return [navigationController.VCDelegate navigationControllerPreferredInterfaceOrientationForPresentation:navigationController];
    }
    return -1;
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    if (navigationController.VCDelegate &&
        [navigationController.VCDelegate respondsToSelector:@selector(navigationController:interactionControllerForAnimationController:)]) {
        return [navigationController.VCDelegate navigationController:navigationController interactionControllerForAnimationController:animationController];
    }
    return nil;
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    if (navigationController.VCDelegate &&
        [navigationController.VCDelegate respondsToSelector:@selector(navigationController:animationControllerForOperation:fromViewController:toViewController:)]) {
        return [navigationController.VCDelegate navigationController:navigationController
                                     animationControllerForOperation:operation
                                                  fromViewController:fromVC
                                                    toViewController:toVC];
    }
    return nil;
}

@end

//
// VCRouter
//
@implementation VCRouter

static id _instance = nil;

+ (instancetype)mainRouter
{
    @synchronized(self) {
        if (!_instance) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

#pragma mark - accessor

- (UINavigationController *)navigationController
{
    if (!self.window || !self.window.rootViewController) {
        return nil;
    }

    Class class = [self.window.rootViewController class];

    // type UITabBarController
    if ([class isSubclassOfClass:[UITabBarController class]] ||
        [self.window.rootViewController respondsToSelector:@selector(selectedViewController)]) {
        UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
        return (UINavigationController *)tabBarController.selectedViewController;
    }

    // type UINavigationController
    if ([class isSubclassOfClass:[UINavigationController class]]) {
        return (UINavigationController *)self.window.rootViewController;
    }

    return nil;
}

- (void)setAnimated:(BOOL)animated
{
    NSLog(@"%s animated %d", __func__, animated);
    _animated = animated;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.navigationController.delegate != self) {
        self.navigationController.delegate = self;
    }

    if (![self canTransit]) {
        return;
    }

    self.animated = animated;

    if (![self canStackViewController:viewController]) {
        [self popViewControllerWithSameClass:[viewController class]];
    }
    [self.navigationController pushViewController:viewController animated:animated];
}

- (BOOL)canStackViewController:(UIViewController *)viewController
{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(vcRouter:canStackViewController:)]) {
        return [self.delegate vcRouter:self canStackViewController:viewController];
    }
    return NO;
}

- (BOOL)canTransit
{
    if (self.animated) {
        return NO;
    }

    UIViewController *viewController = [self.navigationController.viewControllers lastObject];
    if (viewController.presentedViewController) {
        return !viewController.presentedViewController.isBeingPresented;
    }

    return YES;
}

- (void)popViewControllerWithSameClass:(Class)aClass
{
    NSInteger index = [self.navigationController.viewControllers indexOfViewControllerWithClass:aClass];
    if (index != NSNotFound) {
        NSMutableArray *viewControllers = [self.navigationController.viewControllers mutableCopy];
        [viewControllers removeObjectAtIndex:index];
        self.navigationController.viewControllers = [viewControllers copy];
    }
}

@end
