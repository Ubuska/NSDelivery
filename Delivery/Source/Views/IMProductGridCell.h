//
//  IMProductGridCell.h
//  Delivery
//
//  Created by Peter on 16/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "IMStepper.h"

@interface IMProductGridCell : UICollectionViewCell

@property (nonatomic, retain) IBOutlet UILabel *Name;
@property (nonatomic, retain) IBOutlet UILabel *Description;
@property (nonatomic, retain) IBOutlet AsyncImageView *ImageView;

@property (nonatomic, weak) IBOutlet UIButton *addbutton;
@property (nonatomic, strong) IBOutlet IMStepper *StepperView;

@property (nonatomic, strong) IBOutlet UIView *StatusView;
@property (nonatomic, strong) IBOutlet UILabel *StatusTextView;

@property (nonatomic, strong) IBOutlet UILabel *Weight;
@property (nonatomic, strong) IBOutlet UILabel *Price;
@property (nonatomic, strong) IBOutlet UILabel *Quantity;

@end
