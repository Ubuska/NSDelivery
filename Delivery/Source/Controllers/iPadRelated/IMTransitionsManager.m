//
//  IMTransitionsManager.m
//  Delivery
//
//  Created by Peter on 19/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMTransitionsManager.h"
#import "GridController.h"

@implementation IMTransitionsManager

#pragma mark Singleton Methods

- (void) SetSplitController:(IMSplitViewController*)Controller
{
    SplitController = Controller;
}

- (void) SetRightView:(UIView*)View
{
    RightView = View;
    
}

- (void) MakeTransition:(UIViewController*) RightController
{
    
    // UINavigationItem* NavigationButton = RightViewController.navigationItem;
    // NavigationButton.leftBarButtonItem = nil;
    // NavigationButton.leftItemsSupplementBackButton = YES;
    
    [SplitController addChildViewController:RightController];
    
    
    // [ RightController.view setAutoresizingMask:( UIViewAutoresizingFlexibleWidth |
   // UIViewAutoresizingFlexibleHeight )];
    [ RightView setAutoresizesSubviews:YES ];
    RightController.view.frame = CGRectMake(0, 0, RightView.frame.size.width, RightView.frame.size.height);
    //RightController.view.bounds = RightView.bounds;
    //RightViewController.view.bounds = RightView.bounds;
    //GridController* CollectionViewController = (GridController*) Controller.childViewControllers[0];
    //[CollectionViewController.CollectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    //[CollectionViewController.CollectionView.superview setTranslatesAutoresizingMaskIntoConstraints:NO];
    //CollectionViewController.CollectionView.frame = CGRectMake(0, 0, RightView.frame.size.width, RightView.frame.size.height);
    
    //CollectionViewController.CollectionView.contentSize = CGSizeMake(RightView.frame.size.width, 3000);
    NSArray* Sub = RightView.subviews;
    //[CollectionViewController.CollectionView setNeedsUpdateConstraints];
    for (int i=RightView.subviews.count-1; i>=0; i--)
        [[RightView.subviews objectAtIndex:i] removeFromSuperview];
    
    [RightView addSubview:RightController.view];
   
        
    
    
    
}

+ (id)sharedManager
{
    static IMTransitionsManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init
{
    if (self = [super init])
    {
       //someProperty = [[NSString alloc] initWithString:@"Default Property Value"];
    }
    return self;
}

- (void)dealloc
{
    // Should never be called, but just here for clarity really.
}

@end
