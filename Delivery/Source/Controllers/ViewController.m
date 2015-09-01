//
//  ViewController.m
//  HandOff_ObjC
//
//  Created by Olga Dalton on 23/10/14.
//  Copyright (c) 2014 Olga Dalton. All rights reserved.
//

#import "ViewController.h"
#import "PageItemController.h"
#import "IMCartViewController.h"
#import "IMProductDetailPageController.h"
#import "IMCartManager.h"

@interface ViewController () <UIPageViewControllerDataSource>

@property (nonatomic, strong) NSArray *contentImages;
@property (nonatomic, strong) UIPageViewController *pageViewController;

@end

@implementation ViewController
@synthesize contentImages;

#pragma mark -
#pragma mark View Lifecycle

// IMProductDetailPageController

- (void) UpdateView
{
    [self.ButtonCart setTitle:[CartManager GetMoneyInCartString] forState:UIControlStateNormal];
    if ([CartManager GetItemsCount] == 0) [self.ButtonCart setEnabled:NO];
    else [self.ButtonCart setEnabled:YES];
}

-(void) viewWillDisappear:(BOOL)animated
{

    [self.PageUpdateDelegate UpdateView];
    [super viewWillDisappear:animated];
}

- (IBAction)OnCartTransition:(id)sender
{
    // Instantitate and set the center view controller.
    UIViewController* centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Cart"];
    IMCartViewController* Cart = centerViewController.childViewControllers[0];
    Cart.delegate = self;
    
    // present
    [self presentViewController:centerViewController animated:YES completion:nil];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self createPageViewController];
    [self setupPageControl];

    [self UpdateView];
    
}

- (void) createPageViewController
{

    
    UIPageViewController *pageController = [self.storyboard instantiateViewControllerWithIdentifier: @"PageController"];
    pageController.dataSource = self;
    
    
    if([self.Products count])
    {
        NSArray *startingViewControllers = @[[self itemControllerForIndex: self.PageIndex]];
        [pageController setViewControllers: startingViewControllers
                                 direction: UIPageViewControllerNavigationDirectionForward
                                  animated: NO
                                completion: nil];
    }
    
    self.pageViewController = pageController;
    [self addChildViewController: self.pageViewController];
    [self.view addSubview: self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController: self];
}

- (void) setupPageControl
{
    [[UIPageControl appearance] setPageIndicatorTintColor: [UIColor grayColor]];
    [[UIPageControl appearance] setCurrentPageIndicatorTintColor: [UIColor whiteColor]];
    [[UIPageControl appearance] setBackgroundColor: [UIColor darkGrayColor]];
}

#pragma mark -
#pragma mark UIPageViewControllerDataSource

- (UIViewController *) pageViewController: (UIPageViewController *) pageViewController viewControllerBeforeViewController:(UIViewController *) viewController
{
    PageItemController *itemController = (PageItemController *) viewController;
    
    if (itemController.itemIndex > 0)
    {
        return [self itemControllerForIndex: itemController.itemIndex-1];
    }
    
    return nil;
}

- (UIViewController *) pageViewController: (UIPageViewController *) pageViewController viewControllerAfterViewController:(UIViewController *) viewController
{
    PageItemController *itemController = (PageItemController *) viewController;
    
    if (itemController.itemIndex+1 < [self.Products count])
    {
        PageItemController *PageItemController = [self itemControllerForIndex: itemController.itemIndex+1] ;
        return PageItemController;
    }
    
    return nil;
}

- (PageItemController *) itemControllerForIndex: (NSUInteger) itemIndex
{
    if (itemIndex < [self.Products count])
    {
        IMProductDetailPageController *pageItemController = [self.storyboard instantiateViewControllerWithIdentifier: @"ItemController"];
        pageItemController.DetailItem = self.Products[itemIndex];
        pageItemController.itemIndex = itemIndex;
        pageItemController.delegate = self;
        //pageItemController.imageName = self.Products[itemIndex];
        return pageItemController;
    }
    return nil;
}

#pragma mark -
#pragma mark Page Indicator

- (NSInteger) presentationCountForPageViewController: (UIPageViewController *) pageViewController
{
    return [self.Products count];
}

- (NSInteger) presentationIndexForPageViewController: (UIPageViewController *) pageViewController
{
    return self.PageIndex;
}

@end
