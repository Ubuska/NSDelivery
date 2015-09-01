//
//  IMSecondViewController.h
//  Delivery
//
//  Created by Developer on 12.12.14.
//  Copyright (c) 2014 incodemobile. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MMDrawerBarButtonItem.h"
#import "MMDrawerVisualState.h"
#import "IMAppDelegate.h"
#import "IMEventViewCell.h"
#import "IMEvent.h"
#import "IMEventDetailController.h"
#import "Protocols.h"

@interface IMEventViewController : UITableViewController <UpdateControllerView>

@property (nonatomic, strong) NSMutableArray *Events;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property IBOutlet UIButton* ButtonCart;

@end
