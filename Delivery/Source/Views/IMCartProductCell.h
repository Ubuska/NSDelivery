//
//  IMCartProductCell.h
//  Delivery
//
//  Created by Developer on 15.12.14.
//  Copyright (c) 2014 incodemobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface IMCartProductCell : UITableViewCell
{
        AsyncImageView *image;
}

@property (nonatomic, retain) IBOutlet UILabel *ProductName;
@property (nonatomic, retain) IBOutlet UILabel *ProductQuantity;
@property (nonatomic, retain) IBOutlet AsyncImageView *image;
@property (nonatomic, strong) IBOutlet UILabel *PriceLabel;
@property IBOutlet UIStepper* Stepper;
@end
