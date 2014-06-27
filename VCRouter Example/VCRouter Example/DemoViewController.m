//
//  DemoViewController.m
//  VCRouter Example
//
//  Created by Hirohisa Kawasaki on 2014/02/12.
//  Copyright (c) 2014年 Hirohisa Kawasaki. All rights reserved.
//

#import "DemoViewController.h"
#import "EXVCRouter.h"

@interface DemoViewController ()

@end

@implementation DemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self renderButtons];
}

- (void)renderButtons
{
    UIButton *pushButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [pushButton setTitle:@"push" forState:UIControlStateNormal];
    [pushButton addTarget:self action:@selector(pushVC:) forControlEvents:UIControlEventTouchUpInside];
    [pushButton sizeToFit];
    pushButton.center = (CGPoint) {
        .x = 240,
        .y = 80
    };
    [self.view addSubview:pushButton];

    UIButton *doublePushButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [doublePushButton setTitle:@"double push" forState:UIControlStateNormal];
    [doublePushButton addTarget:self action:@selector(pushVCs:) forControlEvents:UIControlEventTouchUpInside];
    [doublePushButton sizeToFit];
    doublePushButton.center = (CGPoint) {
        .x = 240,
        .y = 120
    };
    [self.view addSubview:doublePushButton];

    UIButton *popAndPushButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [popAndPushButton setTitle:@"pop/push" forState:UIControlStateNormal];
    [popAndPushButton addTarget:self action:@selector(popAndPush:) forControlEvents:UIControlEventTouchUpInside];
    [popAndPushButton sizeToFit];
    popAndPushButton.center = (CGPoint) {
        .x = 240,
        .y = 160
    };
    [self.view addSubview:popAndPushButton];

    UIButton *pushAndPopButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [pushAndPopButton setTitle:@"push/pop" forState:UIControlStateNormal];
    [pushAndPopButton addTarget:self action:@selector(pushAndPop:) forControlEvents:UIControlEventTouchUpInside];
    [pushAndPopButton sizeToFit];
    pushAndPopButton.center = (CGPoint) {
        .x = 240,
        .y = 200
    };
    [self.view addSubview:pushAndPopButton];
}

- (void)pushVC:(id)sender
{
    int index = [self.navigationController.viewControllers count];

    DemoViewController *viewController = [[DemoViewController alloc]initWithNibName:nil bundle:nil];
    viewController.title = [NSString stringWithFormat:@"%d", index];
    [[EXVCRouter mainRouter] pushViewController:viewController animated:YES];
}

- (void)pushVCs:(id)sender
{
    int index = [self.navigationController.viewControllers count];

    DemoViewController *viewController = [[DemoViewController alloc]initWithNibName:nil bundle:nil];
    viewController.title = [NSString stringWithFormat:@"%d", index];
    [[EXVCRouter mainRouter] pushViewController:viewController animated:YES];

    // dont push
    DemoViewController *viewController1 = [[DemoViewController alloc]initWithNibName:nil bundle:nil];
    viewController1.title = [NSString stringWithFormat:@"%d", index+1];
    [[EXVCRouter mainRouter] pushViewController:viewController1 animated:YES];
}

- (void)popAndPush:(id)sender
{
    int index = [self.navigationController.viewControllers count];

    // pop
    [self.navigationController popViewControllerAnimated:YES];

    DemoViewController *viewController = [[DemoViewController alloc]initWithNibName:nil bundle:nil];
    viewController.title = [NSString stringWithFormat:@"%d", index];
    [[EXVCRouter mainRouter] pushViewController:viewController animated:YES];
}

- (void)pushAndPop:(id)sender
{
    int index = [self.navigationController.viewControllers count];

    DemoViewController *viewController = [[DemoViewController alloc]initWithNibName:nil bundle:nil];
    viewController.title = [NSString stringWithFormat:@"%d", index];
    [[EXVCRouter mainRouter] pushViewController:viewController animated:YES];

    // pop
    [self.navigationController popViewControllerAnimated:YES];
}

@end
