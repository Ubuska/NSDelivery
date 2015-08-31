//
//  IMCartViewController.h
//  Delivery
//
//  Created by Developer on 11.12.14.
//  Copyright (c) 2014 incodemobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMCartProductCell.h"
#import "IMCartAdditionViewCell.h"
#import "IMProduct.h"
#import "IMAddition.h"
#import "IMAppDelegate.h"
#import "IMStepper.h"
#import "IMFormViewController.h"
#import "AsyncImageView.h"
#import "Protocols.h"


@interface IMCartViewController : UIViewController
    {
            //create a delegate instance
            NSMutableArray *DataArray;
    }

// define delegate instance
@property (nonatomic, retain) id <UpdateControllerView> delegate;


@property (nonatomic, strong) IBOutlet UIButton *MakeOrder;
@property (nonatomic, strong) IBOutlet UIButton *ClearCart;

@property (nonatomic, strong) IBOutlet UILabel *EmptyCartLabel;

@property (nonatomic, strong) IBOutlet AsyncImageView *productImage;
@property (nonatomic, strong) NSString *PicURL;

@property (nonatomic, strong) IBOutlet UILabel *Summary;
@property (nonatomic, strong) IBOutlet UIView *SummaryView;

@property (nonatomic, strong) IBOutlet UIView *StatusBar;
@property (nonatomic, strong) IBOutlet UINavigationBar *NavigationBar;

@property IBOutlet UIView* CartEmptyView;
@property IBOutlet UIView* DiscountView;
@property IBOutlet UITableView* tableView;

@property IBOutlet UILabel* OldPrice;
@property IBOutlet UILabel* DiscountLabel;

@property IBOutlet NSLayoutConstraint* DiscountViewHeight;
@property IBOutlet NSLayoutConstraint* LineWidth;
@property IBOutlet NSLayoutConstraint* TableBottomConstraint;

@property IBOutlet UIView* NavView;

@end
