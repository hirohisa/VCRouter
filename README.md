VCRouter
========

VCRouter is UINavigationController's manager.


Usage
----------

### Setup UIWindow, and delegate

```objective-c
    [VCRouter mainRouter].window = self.window;
    [VCRouter mainRouter].delegate = self;
```

### Control to push UIViewController

```objective-c
    UIViewController *viewController = [[UIViewController alloc]initWithNibName:nil bundle:nil];
    [[VCRouter mainRouter] pushViewController:viewController animated:YES];
```


### Control to UINavigationController's viewControllers

```objective-c
- (BOOL)vcRouter:(VCRouter *)router canStackViewController:(UIViewController *)viewController
{
    Class aClass = [viewController class];

    int countOfSameClass = 0;
    for (UIViewController *vc in router.navigationController.viewControllers) {
        if ([vc isMemberOfClass:aClass]) {
            countOfSameClass++;
        }
    }
    return countOfSameClass < 3;
}
```
