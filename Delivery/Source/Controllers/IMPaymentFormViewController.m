//
//  IMPaymentFormViewController.m
//  Delivery
//
//  Created by Peter on 09/07/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMPaymentFormViewController.h"
#import "IMPaymentSystemPayOnline.h"
#import "Tools.h"
#import "ActionSheetDatePicker.h"
#import "ActionSheetPicker.h"
#import "IMCartManager.h"
#import "IMOrderSendingController.h"
#import "PayOnlinePayRequest.h"
#import "IMAppDelegate.h"

IMAppDelegate* AppDelegate;

@implementation IMPaymentFormViewController

int CardExpirationDateMonth;

- (IBAction)backgroundTap:(id)sender
{
    [self.view endEditing:YES];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    AppDelegate = (IMAppDelegate*) [[UIApplication sharedApplication] delegate];
    [self SelectPaymentSystem:[IMPaymentSystemPayOnline new]];
    
    [_FormView.layer setCornerRadius:10.0f];
    // drop shadow
    [_FormView.layer setShadowColor:[UIColor blackColor].CGColor];
    [_FormView.layer setShadowOpacity:0.8];
    [_FormView.layer setShadowRadius:7.0];
    [_FormView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    NSMutableString* Summary = [NSMutableString stringWithString:@"Покупка на сумму "];
    [Summary appendString:[NSString stringWithFormat:@"%d", [CartManager GetMoneyInCart]]];
    [Summary appendString:@" руб."];
    _Summary.text = Summary;
    
    [_SwitchSaveCardInfo setOnTintColor:AppDelegate.MainAppColor];
    if (_ButtonCancel)[_ButtonCancel setTintColor:AppDelegate.MainAppColor];
    if (_ButtonSend)[_ButtonSend setTintColor:AppDelegate.MainAppColor];
    
    // Set autofill option from UserDefaults
    NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
    BOOL bIsAutoFillEnabled = [Defaults boolForKey:@"PaymentAutoFill"];
    [_SwitchSaveCardInfo setOn:bIsAutoFillEnabled animated:NO];
    if (bIsAutoFillEnabled) [self AutoFill];
    

    
}

- (IBAction)OnBackButtonPress:(id)sender
{
    [self AttemptAutoFillSave];
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    // Dismiss modal view
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)Purchase:(id)sender
{
    PayOnlinePayRequest* Request = [self CommitAssemble];
    if (Request)
    {
        [PaymentSystemDelegate Initialize];
        
        IMPaymentSystemPayOnline* PaymentSystem = (IMPaymentSystemPayOnline*) PaymentSystemDelegate;
        PaymentSystem.Request = Request;
        IMOrderSendingController* OrderSendingController = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderSendingController"];
        OrderSendingController.PaymentSystemDelegate = PaymentSystemDelegate;
        
        // present
        
        [self presentViewController:OrderSendingController animated:NO completion:nil ];
        // Transition to Loading View
    }
}


- (PayOnlinePayRequest*) CommitAssemble
{
    // Создать объект платежа PayOnlinePayRequest:
    PayOnlinePayRequest *PayRequest = [[PayOnlinePayRequest alloc] init];
    if ([Tools IsEmailValid:_Email.text]) PayRequest.email = _Email.text;
    else
    {
        UIAlertView* Alert = [[UIAlertView new] initWithTitle:@"" message:@"Введите корректный email" delegate:nil cancelButtonTitle:@"ОК" otherButtonTitles:nil, nil];
        [Alert show];
        return NULL;
    }
    PayRequest.cardNumber = _CardNumber.text;

    if ([_CardNumber.text length] != 16)
    {
        UIAlertView* Alert = [[UIAlertView new] initWithTitle:@"" message:@"Введите корректный номер карты" delegate:nil cancelButtonTitle:@"ОК" otherButtonTitles:nil, nil];
        [Alert show];
        return NULL;
    }
    PayRequest.ip = [Tools GetIPAddress];
    if (CardExpirationDateMonth == 0) CardExpirationDateMonth = 1;
    PayRequest.cardExpMonth = CardExpirationDateMonth;
    PayRequest.cardExpYear = [_CardExpireDateYear.text intValue];
    
    if ([_CardExpireDateYear.text length] == 0 || [_CardExpireDateMonth.text length] == 0)
    {
        UIAlertView* Alert = [[UIAlertView new] initWithTitle:@"" message:@"Введите дату окончания срока действия карты" delegate:nil cancelButtonTitle:@"ОК" otherButtonTitles:nil, nil];
        [Alert show];
        return NULL;
    }
    
    PayRequest.cardHolderName = _CardHolder.text;
    if ([_CardHolder.text length] < 3)
    {
        UIAlertView* Alert = [[UIAlertView new] initWithTitle:@"" message:@"Введите корректные имя и фамилию держателя карты" delegate:nil cancelButtonTitle:@"ОК" otherButtonTitles:nil, nil];
        [Alert show];
        return NULL;
    }
    PayRequest.cardCvv = [_CardCVV.text intValue];
    if ([_CardCVV.text length] < 3)
    {
        UIAlertView* Alert = [[UIAlertView new] initWithTitle:@"" message:@"Введите корректный защитный код" delegate:nil cancelButtonTitle:@"ОК" otherButtonTitles:nil, nil];
        [Alert show];
        return NULL;
    }
    PayRequest.amount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d",[CartManager GetMoneyInCart]]];
    PayRequest.currency = PayOnlineCurrencyRub;
    PayRequest.orderId = [Tools GenerateUniqueUUID];
    
    [self AttemptAutoFillSave];

    
    
    
    return PayRequest;
}

- (void) AutoFill
{
    NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
    _Email.text = [Defaults stringForKey:@"PaymentEmail"];
    _CardNumber.text = [Defaults stringForKey:@"PaymentCardNumber"];
    _CardExpireDateYear.text = [Defaults stringForKey:@"PaymentCardYear"];
    _CardExpireDateMonth.text = [Defaults stringForKey:@"PaymentCardMonth"];
    _CardHolder.text = [Defaults stringForKey:@"PaymentCardHolder"];
    _CardCVV.text = [Defaults stringForKey:@"PaymentCardCVV"];
}

- (void) AttemptAutoFillSave
{
    if ([_SwitchSaveCardInfo isOn])
    {
        // Save user Card Info if needed
        NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
        
        [Defaults setBool:YES forKey:@"PaymentAutoFill"];
        
        [Defaults setObject:_Email.text forKey:@"PaymentEmail"];
        [Defaults setObject:_CardNumber.text forKey:@"PaymentCardNumber"];
        [Defaults setObject:_CardExpireDateYear.text forKey:@"PaymentCardYear"];
        [Defaults setObject:_CardExpireDateMonth.text forKey:@"PaymentCardMonth"];
        [Defaults setObject:_CardHolder.text forKey:@"PaymentCardHolder"];
        [Defaults setObject:_CardCVV.text forKey:@"PaymentCardCVV"];
        
        [Defaults synchronize];
    }
}

- (IBAction)ToggleAutoSaveOption:(id)sender
{
    UISwitch* Switcher = (UISwitch*) sender;
    NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
    
    if ([Switcher isOn])
    {
        [self AttemptAutoFillSave];
    }
    else
    {
        [Defaults setBool:NO forKey:@"PaymentAutoFill"];
    }
}

- (IBAction)ShowListBox:(id)sender
{
    [[_FormView window] endEditing:YES];
    NSArray* Months = [NSArray arrayWithObjects:
                      @"Январь",
                      @"Февраль",
                      @"Март",
                      @"Апрель",
                      @"Май",
                      @"Июнь",
                      @"Июль",
                      @"Август",
                      @"Сентябрь",
                      @"Октябрь",
                      @"Ноябрь",
                      @"Декабрь",
                      
                       nil];
    //[[_FormView window] endEditing:YES];
    [ActionSheetStringPicker showPickerWithTitle:@"" rows: Months
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker,
                                                   NSInteger selectedIndex,
                                                   id selectedValue)
     {
         CardExpirationDateMonth = selectedIndex + 1;
         _CardExpireDateMonth.text = Months[selectedIndex];
     }
                                     cancelBlock:^(ActionSheetStringPicker *picker)
     {
        NSLog(@"Отмена");
     }
                                          origin:sender];
    /*
    [ActionSheetDatePicker showPickerWithTitle:@"Введите дату"
                                datePickerMode:UIDatePickerModeDate
                                  selectedDate:[NSDate date]
                                     doneBlock:
     ^(ActionSheetDatePicker *picker, id selectedDate, id origin)
    {
        //_CardExpireDate
     }
                                   cancelBlock:^(ActionSheetDatePicker *picker)
    {
                                       NSLog(@"Cancel");
                                   }
                                        origin:sender];
     
*/
    /*
    NSLog(@"Test");
    
        UIViewController* DateController = [self.storyboard instantiateViewControllerWithIdentifier: @"DateController"];
    
    DateController.modalPresentationStyle = UIModalPresentationPopover;
    [self addChildViewController:DateController];

    UIView *ContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 120)];
    [ContainerView addSubview:DateController.view];
    [self.view addSubview:ContainerView];
    */
     
    //[self.navigationController presentViewController:DateController animated:YES completion:nil];
       // [self.navigationController pushViewController:DateController animated:YES];
    
}

- (IBAction)ShowListYear:(id)sender
{
    [[_FormView window] endEditing:YES];
    NSDate *Today = [[NSDate alloc] init];
    NSCalendar *Gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *OffsetComponents = [[NSDateComponents alloc] init];
    
    NSMutableArray* Years = [NSMutableArray arrayWithCapacity:0];
    
    for (int i=1; i < 7; i++)
    {
        [OffsetComponents setYear:i];
        NSDate *NextYear = [Gregorian dateByAddingComponents:OffsetComponents toDate:Today options:0];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy"];
        
        NSString *YearString = [formatter stringFromDate:NextYear];
        [Years addObject:YearString];
    }

    NSArray* YearsArray = [Years copy];
    
    [ActionSheetStringPicker showPickerWithTitle:@"" rows: YearsArray
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker,
                                                   NSInteger selectedIndex,
                                                   id selectedValue)
     {
         _CardExpireDateYear.text = YearsArray[selectedIndex];
     }
                                     cancelBlock:^(ActionSheetStringPicker *picker)
     {
         NSLog(@"Отмена");
     }
  
                                          origin:sender];
}



- (void) SelectPaymentSystem:(id<PaymentSystem>)System
{
    PaymentSystemDelegate = System;
}








- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}


BOOL keyboardIsShown;

#pragma mark - keyboard offset stuff
#define kOFFSET_FOR_KEYBOARD 200.0
#define kTabBarHeight 50.0
- (void)keyboardWillHide:(NSNotification *)n
{
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    // resize the scrollview
    CGRect viewFrame = self.ScrollView.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    viewFrame.size.height += (keyboardSize.height - kTabBarHeight);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.ScrollView setFrame:viewFrame];
    [UIView commitAnimations];
    
    keyboardIsShown = NO;
}

- (void)keyboardWillShow:(NSNotification *)n
{
    
    // This is an ivar I'm using to ensure that we do not do the frame size adjustment on the `UIScrollView` if the keyboard is already shown.  This can happen if the user, after fixing editing a `UITextField`, scrolls the resized `UIScrollView` to another `UITextField` and attempts to edit the next `UITextField`.  If we were to resize the `UIScrollView` again, it would be disastrous.  NOTE: The keyboard notification will fire even when the keyboard is already shown.
    if (keyboardIsShown)
    {
        return;
    }
    
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // resize the noteView
    CGRect viewFrame = self.ScrollView.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    viewFrame.size.height -= (keyboardSize.height - kTabBarHeight);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.ScrollView setFrame:viewFrame];
    [UIView commitAnimations];
    keyboardIsShown = YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    //if ([sender isEqual:PhoneNumber])
    //{
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    //}
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    
    return NO;  // Hide both keyboard and blinking cursor.
}
@end
