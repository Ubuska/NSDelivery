//
//  IMProductViewController.h
//  Delivery
//
//  Created by Developer on 10.12.14.
//  Copyright (c) 2014 incodemobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMProductViewCell.h"
#import "IMProduct.h"
#import "IMAppDelegate.h"
#import "IMStepper.h"
#import "IMLabel.h"
#import "AsyncImageView.h"

#import "IMSectionViewCell.h"
#import "IMCartViewController.h"

#import "IMProductDetailController.h"
#import "Protocols.h"
#import "Section.h"

@interface IMProductViewController : UITableViewController <UpdateControllerView>
{
    UIActivityIndicatorView *Spinner;
    int SelectedIndex;
}


@property (nonatomic, strong) NSMutableArray *Products;

@property (nonatomic, strong) IMProduct *Product;

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) IBOutlet UIStepper *Stepper;
@property (nonatomic, strong) IBOutlet UILabel *Price;
@property (nonatomic, strong) IBOutlet UIButton *MoneySum;
@property (nonatomic, strong) IBOutlet UINavigationItem* NavigationButton;


@property (nonatomic, strong) NSMutableArray *SectionRows;

@property (nonatomic, strong) IBOutlet UIButton* ButtonCart;


@end
