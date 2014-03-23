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

Example
----------

- import `VCRouter.h`

```objective-c


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

License
----------

VCRouter is available under the MIT license.
