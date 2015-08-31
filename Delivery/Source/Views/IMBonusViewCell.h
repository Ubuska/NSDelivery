//
//  IMBonusViewCell.h
//  Delivery
//
//  Created by Peter on 26/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface IMBonusViewCell : UITableViewCell

@property IBOutlet UILabel* BonusName;
@property IBOutlet UILabel* BonusDescription;
@property IBOutlet UILabel* BonusAdvice;
@property IBOutlet UITextField* BonusQuantity;
@property IBOutlet AsyncImageView* BonusImage;
@property IBOutlet UIButton* BonusButton;
@property IBOutlet UIButton* BonusProductLink;
@property IBOutlet UIProgressView* BonusProgressBar;

@end
