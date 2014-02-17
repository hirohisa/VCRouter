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
