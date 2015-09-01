//
//  IMCartAdditionViewCell.h
//  Delivery
//
//  Created by Developer on 29.12.14.
//  Copyright (c) 2014 incodemobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface IMCartAdditionViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *AdditionName;
@property (nonatomic, retain) IBOutlet UILabel *AdditionQuantity;
@property (nonatomic, retain) IBOutlet AsyncImageView *AdditionImage;
@property (nonatomic, strong) IBOutlet UILabel *AdditionDescription;
@property (nonatomic, strong) IBOutlet UILabel *PriceLabel;


@end
