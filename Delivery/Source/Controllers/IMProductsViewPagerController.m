//
//  IMProductsViewPagerController.m
//  Delivery
//
//  Created by Peter on 15/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMProductsViewPagerController.h"
#import "IMSectionManager.h"
#import "IMProduct.h"
#import "IMProductDetailController.h"

@implementation IMProductsViewPagerController


- (void) viewDidLoad
{
    [super viewDidLoad];

    [self CreatePageViewController];
    [self SetupPageControl];
}



- (void) CreatePageViewController
{
    
    UIPageViewController *pageController = [self.storyboard instantiateViewControllerWithIdentifier: @"PageController"];
    pageController.dataSource = self;
    
    Section* CurrentSection = [[IMSectionManager SharedInstance] GetActiveSection];
    NSMutableArray* Products = [[IMSectionManager SharedInstance] FilterChildrenByType:CurrentSection FilterClass:[IMProduct class]];
    
    
    if([Products count])
    {
        NSArray *startingViewControllers = @[[self itemControllerForIndex: 0]];
        [pageController setViewControllers: startingViewControllers
                                 direction: UIPageViewControllerNavigationDirectionForward
                                  animated: NO
                                completion: nil];
    }
    
    self.PageViewController = pageController;
    [self addChildViewController: self.PageViewController];
    [self.view addSubview: self.PageViewController.view];
    [self.PageViewController didMoveToParentViewController: self];
}

- (void) SetupPageControl
{
    
    [[UIPageControl appearance] setPageIndicatorTintColor: [UIColor grayColor]];
    [[UIPageControl appearance] setCurrentPageIndicatorTintColor: [UIColor blackColor]];
    [[UIPageControl appearance] setBackgroundColor: [UIColor darkGrayColor]];
}

#pragma mark UIPageViewControllerDataSource

- (UIViewController *) pageViewController: (UIPageViewController *) pageViewController viewControllerBeforeViewController:(UIViewController *) viewController
{
    IMProductDetailController *itemController = (IMProductDetailController *) viewController;
    
    if (itemController.itemIndex > 0)
    {
        return [self itemControllerForIndex: itemController.itemIndex-1];
    }
    
    return nil;
}

- (UIViewController *) pageViewController: (UIPageViewController *) pageViewController viewControllerAfterViewController:(UIViewController *) viewController
{
    Section* CurrentSection = [[IMSectionManager SharedInstance] GetActiveSection];
    NSMutableArray* Products = [[IMSectionManager SharedInstance] FilterChildrenByType:CurrentSection FilterClass:[IMProduct class]];
    IMProductDetailController *itemController = (IMProductDetailController *) viewController;
    
    if (itemController.itemIndex+1 < [Products count])
    {
        return [self itemControllerForIndex: itemController.itemIndex+1];
    }
    
    return nil;
}

- (IMProductDetailController *) itemControllerForIndex: (NSUInteger) itemIndex
{
    Section* CurrentSection = [[IMSectionManager SharedInstance] GetActiveSection];
    NSMutableArray* Products = [[IMSectionManager SharedInstance] FilterChildrenByType:CurrentSection FilterClass:[IMProduct class]];
    if (itemIndex < [Products count])
    {
        IMProductDetailController *pageItemController = [self.storyboard instantiateViewControllerWithIdentifier: @"ItemController"];
        pageItemController.itemIndex = itemIndex;
        //pageItemController.imageName = contentImages[itemIndex];
        return pageItemController;
    }
    
    return nil;
}

#pragma mark Page Indicator

- (NSInteger) presentationCountForPageViewController: (UIPageViewController *) pageViewController
{
    Section* CurrentSection = [[IMSectionManager SharedInstance] GetActiveSection];
    NSMutableArray* Products = [[IMSectionManager SharedInstance] FilterChildrenByType:CurrentSection FilterClass:[IMProduct class]];

    return [Products count];
}

- (NSInteger) presentationIndexForPageViewController: (UIPageViewController *) pageViewController
{
    return 0;
}
@end
