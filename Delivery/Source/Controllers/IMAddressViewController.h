//
//  IMRestarauntViewController.h
//  Delivery
//
//  Created by Developer on 22.12.14.
//  Copyright (c) 2014 incodemobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMAppDelegate.h"
#import "MMDrawerBarButtonItem.h"
#import "MMDrawerVisualState.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "IMAddress.h"
#import "IMRestarauntViewCell.h"
#import "Protocols.h"

@interface IMAddressViewController : UITableViewController <UpdateControllerView>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property IBOutlet UIButton* ButtonCart;

@end
