//
//  IMProductsViewPagerController.h
//  Delivery
//
//  Created by Peter on 15/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "Protocols.h"

@interface IMProductsViewPagerController: UIViewController <UIPageViewControllerDataSource>

@property (nonatomic, strong) UIPageViewController* PageViewController;

@property (nonatomic, weak) id <UpdateControllerView> delegate;

@end
