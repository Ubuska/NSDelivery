//
//  IMBonusDetailsViewController.h
//  Delivery
//
//  Created by Peter on 09/07/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMBonusManager.h"
#import "IMBonus.h"
#import "Protocols.h"
#import "AsyncImageView.h"

@interface IMBonusDetailsViewController : UIViewController <UpdateControllerView, DetailView>
{
    id<UpdateControllerView> MasterViewDelegate;
    IMBonus* Bonus;
}

@property IBOutlet AsyncImageView* BonusImage;
@property IBOutlet UILabel* BonusName;
@property IBOutlet UILabel* BonusDescription;
@property IBOutlet UILabel* BonusProgressText;
@property IBOutlet UILabel* BonusAdviceText;
@property IBOutlet UIProgressView* BonusProgressView;
@property IBOutlet UIButton* ButtonCart;
@property IBOutlet UIButton* ButtonProductLink;
@property IBOutlet UIButton* ButtonSendBonus;



@end
