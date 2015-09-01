//
//  IMSlideDrawerController.h
//  Delivery
//
//  Created by Developer on 12.12.14.
//  Copyright (c) 2014 incodemobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMAppDelegate.h"
#import "IMProductViewController.h"
#import "IMEventViewController.h"

@interface IMSlideDrawerController : UITableViewController
{
    int CurrentIndex;
}
@property (nonatomic, strong) NSMutableArray *Sections;

- (int) GetIndex;

@end
