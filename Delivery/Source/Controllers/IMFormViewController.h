//
//  IMFormViewController.h
//  Delivery
//
//  Created by Developer on 23.12.14.
//  Copyright (c) 2014 incodemobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMAppDelegate.h"
#import "SCRFTPRequest.h"
#import "Protocols.h"
#import "IMPaymentFormViewController.h"

#define ACCEPTABLE_CHARECTERS @"0123456789."

@interface IMFormViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *OrderSelection;

// define delegate instance
@property (nonatomic, retain) id <UpdateControllerView> delegate;

// Form Data
@property (nonatomic, retain) IBOutlet UITextField *Email;
@property (nonatomic, retain) IBOutlet UITextField *Name;
@property (nonatomic, retain) IBOutlet UITextField *Street;
@property (nonatomic, retain) IBOutlet UITextField *House;
@property (nonatomic, retain) IBOutlet UITextField *Apartment;
@property (nonatomic, retain) IBOutlet UITextField *LabelSection;
@property (nonatomic, retain) IBOutlet UITextField *Floor;
@property (nonatomic, retain) IBOutlet UITextField *PhoneNumber;
@property (nonatomic, retain) IBOutlet UITextField *Comment;
@property IBOutlet UIView* FormView;
@property IBOutlet UIButton* SendButton;
@property IBOutlet UIButton* CancelButton;
@property IBOutlet UIScrollView* ScrollView;
@property IBOutlet UISwitch* SwitchAutoFill;

- (IBAction)UploadFile:(id)sender;
- (IBAction)SaveForm:(id)sender;
- (BOOL) NSStringIsValidEmail:(NSString*) checkString;



@end
