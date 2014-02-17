//
//  VCRouterTests.m
//  VCRouterTests
//
//  Created by Hirohisa Kawasaki on 2014/02/16.
//  Copyright (c) 2014年 Hirohisa Kawasaki. All rights reserved.
//

#import <XCTest/XCTest.h>
@import UIKit;

@interface NSArray (VCRouter)

- (NSUInteger)indexOfViewControllerWithClass:(Class)aClass;

@end

@interface TestViewController : UIViewController
@end

@implementation TestViewController
@end

@interface VCRouterTests : XCTestCase

@end

@implementation VCRouterTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testIndexOfObjectWithClasstestViewControllers
{
    NSArray *array = @[
                       [[TestViewController alloc] init],
                       [[UITableViewController alloc] init],
                       [[UIViewController alloc] init]
                       ];
    Class klass;
    NSUInteger result;
    NSUInteger valid;

    klass = [TestViewController class];
    result = [array indexOfViewControllerWithClass:klass];
    valid = 0;
    XCTAssertTrue(result == valid,
                  @"%@ is fail, result is %d", NSStringFromClass(klass), result);

    klass = [UIViewController class];
    result = [array indexOfViewControllerWithClass:klass];
    valid = 2;
    XCTAssertTrue(result == valid,
                  @"%@ is fail, result is %d", NSStringFromClass(klass), result);

    klass = [UICollectionViewController class];
    result = [array indexOfViewControllerWithClass:klass];
    valid = NSNotFound;
    XCTAssertTrue(result == valid,
                  @"%@ is fail, result is %d", NSStringFromClass(klass), result);
}

@end
