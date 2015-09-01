//
//  IMDeliveryInformationController.h
//  Delivery
//
//  Created by Developer on 23.12.14.
//  Copyright (c) 2014 incodemobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMDrawerBarButtonItem.h"
#import "MMDrawerVisualState.h"
#import "IMAppDelegate.h"
#import "IMEventViewCell.h"
#import "IMEvent.h"
#import "IMEventDetailController.h"
#import "IMCartViewController.h"

@interface IMDeliveryInformationController : UIViewController <UpdateControllerView>

@property (weak, nonatomic) IBOutlet UIScrollView *DelieveryInformationScrollView;
@property (nonatomic, strong) IBOutlet UILabel *Label;
@property (nonatomic, strong) IBOutlet UILabel *DeliveryConditionsLabel;
@property (nonatomic, strong) IBOutlet UIButton* ButtonCart;
@end
