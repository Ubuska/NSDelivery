//
//  IMPaymentFormViewController.h
//  Delivery
//
//  Created by Peter on 09/07/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Protocols.h"
#import "IMUserData.h"

@interface IMPaymentFormViewController : UIViewController <UITextViewDelegate>
{
    id<PaymentSystem> PaymentSystemDelegate;

}

- (void) SelectPaymentSystem:(id<PaymentSystem>)System;

@property IBOutlet UITextField* Email;
@property IBOutlet UITextField* CardNumber;
@property IBOutlet UITextField* CardExpireDateYear;
@property IBOutlet UITextField* CardExpireDateMonth;
@property IBOutlet UITextField* CardHolder;
@property IBOutlet UITextField* CardCVV;
@property IBOutlet UIScrollView* ScrollView;
@property IBOutlet UIView* FormView;

@property IBOutlet UIButton* ButtonSend;
@property IBOutlet UIButton* ButtonCancel;

@property IBOutlet UILabel* Summary;
@property IBOutlet UISwitch* SwitchSaveCardInfo;
@end
