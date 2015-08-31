//
//  IMUserInfoController.h
//  Delivery
//
//  Created by Peter on 30/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Protocols.h"

@interface IMUserInfoController : UIViewController <UpdateControllerView>

@property (nonatomic, retain) IBOutlet UITextField* PhoneNumber;
@property (nonatomic, retain) IBOutlet UIView* RootView;
@property (nonatomic, retain) IBOutlet UIButton* ButtonConfirm;
@property (nonatomic, retain) IBOutlet UISwitch* SwitchAutofill;
@property (nonatomic, retain) IBOutlet UISwitch* SwitchAutofillCardInfo;
@property (nonatomic, retain) IBOutlet UIScrollView* ScrollView;
- (IBAction)OnAutoFillSwitch:(id)sender;
- (IBAction)OnUserInfoChange:(id)sender;

@property IBOutlet UIButton* ButtonCart;
@end
