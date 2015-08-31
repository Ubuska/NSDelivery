//
//  IMProductViewCell.h
//  Delivery
//
//  Created by Developer on 10.12.14.
//  Copyright (c) 2014 incodemobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMStepper.h"
#import "AsyncImageView.h"

@interface IMProductViewCell : UITableViewCell
{
    UILabel *name;
    UIImageView *photo;
    UILabel *description;
    UIButton *price;
    UIButton *addbutton;
    AsyncImageView *image;
}

@property (nonatomic, retain) IBOutlet UILabel *name;
@property (nonatomic, retain) IBOutlet UIImageView *photo;
@property (nonatomic, retain) IBOutlet UILabel *description;
@property (nonatomic, retain) IBOutlet UIButton *price;
@property (nonatomic, retain) IBOutlet AsyncImageView *image;

@property (nonatomic, weak) IBOutlet UIButton *addbutton;
@property (nonatomic, strong) IBOutlet UIView *StepperView;

@property (nonatomic, strong) IBOutlet UIView *StatusView;
@property (nonatomic, strong) IBOutlet UILabel *StatusTextView;

@property (nonatomic, strong) IBOutlet UILabel *Weight;
@property (nonatomic, strong) IBOutlet UILabel *OptionName;
@property (nonatomic, strong) IBOutlet UILabel *OptionUnit;
@end
