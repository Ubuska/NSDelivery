//
//  IMFormViewController.m
//  Delivery
//
//  Created by Developer on 23.12.14.
//  Copyright (c) 2014 incodemobile. All rights reserved.
//

#import "IMFormViewController.h"
#import "IMOrderSendingController.h"
#import "IMCartManager.h"
#import "IMPaymentFormViewController.h"

@implementation IMFormViewController
@synthesize delegate;
IMAppDelegate *appDelegate;

@synthesize Email;
@synthesize Name;
@synthesize Street;
@synthesize House;
@synthesize Apartment;
@synthesize LabelSection;
@synthesize Floor;
@synthesize PhoneNumber;
@synthesize Comment;

- (IBAction)OrderComplete:(id)sender
{
    if ([self FillUserData])
    {
       
        
      
        if (_OrderSelection.selectedSegmentIndex == 0)
        {
            [self performSegueWithIdentifier: @"PaymentForm" sender: self];
        }
        
        else
        {
            IMOrderSendingController* OrderSendingController = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderSendingController"];
            OrderSendingController.bOrderOnly = YES;
            [self presentViewController:OrderSendingController animated:NO completion:nil ];

        }
       
      

    }
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
#define kOFFSET_FOR_KEYBOARD 180.0
#define kTabBarHeight 50.0

- (IBAction)backgroundTap:(id)sender
{
    [self.view endEditing:YES];
}

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
    if ([sender isEqual:PhoneNumber])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
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



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (IBAction)OnBackButtonPress:(id)sender
{
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    // Dismiss modal view
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)ToggleAutoSaveOption:(id)sender
{
    UISwitch* Switcher = (UISwitch*) sender;
    NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
    
    if ([Switcher isOn])
    {
        [Defaults setBool:YES forKey:@"UserInfoAutoFill"];
    }
    else
    {
        [Defaults setBool:NO forKey:@"UserInfoAutoFill"];
    }
}


- (BOOL) FillUserData
{
    
    // Checking Name
    if (Name.text.length == 0)
    {
        UIAlertView *Alert = [[UIAlertView new] initWithTitle:@"" message:@"Напишите свое имя" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [Alert show];
        return NO;
    }
    
    
    // Checking Phone Number
    if (PhoneNumber.text.length == 0)
    {
        UIAlertView *Alert = [[UIAlertView new] initWithTitle:@"" message:@"Заполните номер телефона" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [Alert show];
        return NO;
    }
    
    IMUserData* UserData = [IMUserData new];
    UserData.UserName = Name.text;
    UserData.UserStreet = Street.text;
    UserData.UserHouse = House.text;
    UserData.UserApartment = Apartment.text;
    UserData.UserPhoneNumber = PhoneNumber.text;
    
    [CartManager SetUserData:UserData];
    
    [self EmptySandbox];
    
    return YES;
    
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    

    // Color SendButton
    [_SendButton setTintColor:appDelegate.MainAppColor];
    
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
    appDelegate = (IMAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [_FormView.layer setCornerRadius:10.0f];
    // drop shadow
    [_FormView.layer setShadowColor:[UIColor blackColor].CGColor];
    [_FormView.layer setShadowOpacity:0.8];
    [_FormView.layer setShadowRadius:7.0];
    [_FormView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
    NSString *UserPhoneNumber = [Defaults objectForKey:@"UserPhoneNumber"];
    
    [_SwitchAutoFill setOnTintColor:appDelegate.MainAppColor];
    [_OrderSelection setTintColor:appDelegate.MainAppColor];
    [_SendButton setTintColor:appDelegate.MainAppColor];
    [_CancelButton setTintColor:appDelegate.MainAppColor];
    
    BOOL bIsAutoFillEnabled = [Defaults boolForKey:@"UserInfoAutoFill"];
    [_SwitchAutoFill setOn:bIsAutoFillEnabled animated:YES];
    
    if (UserPhoneNumber.length > 0)
    {
        [PhoneNumber setText:UserPhoneNumber];
        PhoneNumber.userInteractionEnabled = NO;
    }
        //
    
    

    BOOL bIsAutofillEnabled = [Defaults boolForKey:@"UserInfoAutoFill"];
    if (bIsAutofillEnabled)
        {
            NSString *UserName = [Defaults objectForKey:@"UserName"];
            NSString *UserStreet = [Defaults objectForKey:@"UserStreet"];
            NSString *UserHouse = [Defaults objectForKey:@"UserHouse"];
            NSString *UserSection = [Defaults objectForKey:@"UserSection"];
            NSString *UserFloor = [Defaults objectForKey:@"UserFloor"];
            NSString *UserApartment = [Defaults objectForKey:@"UserApartment"];
    
            if (UserName.length > 0) Name.text = UserName;
            if (UserStreet.length > 0) Street.text = UserStreet;
            if (UserHouse.length > 0) House.text = UserHouse;
            if (UserSection.length > 0) LabelSection.text = UserSection;
            if (UserFloor.length > 0) Floor.text = UserFloor;
            if (UserApartment.length > 0) Apartment.text = UserApartment;
    
        }
    //delegate = self;
    // Do any additional setup after loading the view.
    [Email setKeyboardType:UIKeyboardTypeEmailAddress];

    [House setKeyboardType:UIKeyboardTypeNumberPad];
    [Apartment setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    //[Section setKeyboardType:UIKeyboardTypeNumberPad];
    [Floor setKeyboardType:UIKeyboardTypeNumberPad];
    [PhoneNumber setKeyboardType:UIKeyboardTypePhonePad];
    
    self.navigationController.navigationBar.barTintColor = appDelegate.MainAppColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

}


- (IBAction)SaveForm:(id)sender
{
    NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
    BOOL bIsAutofillEnabled = [Defaults boolForKey:@"UserInfoAutoFill"];
    //if ([_SwitchAutoFill isOn])
    if (bIsAutofillEnabled)
        {
            NSString* UserPhoneNumber = PhoneNumber.text;
            NSString *UserName = Name.text;
            NSString *UserStreet = Street.text;
            NSString *UserHouse = House.text;
            NSString *UserSection = LabelSection.text;
            NSString *UserFloor = Floor.text;
            NSString *UserApartment = Apartment.text;
    
            if (UserPhoneNumber.length) [Defaults setObject:UserPhoneNumber forKey:@"UserPhoneNumber"];
            if (UserName.length) [Defaults setObject:UserName forKey:@"UserName"];
            if (UserStreet.length) [Defaults setObject:UserStreet forKey:@"UserStreet"];
            if (UserHouse.length) [Defaults setObject:UserHouse forKey:@"UserHouse"];
            if (UserSection.length) [Defaults setObject:UserSection forKey:@"UserSection"];
            if (UserFloor.length) [Defaults setObject:UserFloor forKey:@"UserFloor"];
            if (UserApartment.length) [Defaults setObject:UserApartment forKey:@"UserApartment"];

            [Defaults synchronize];
        }
}


-(void)EmptySandbox
{
    NSFileManager *fileMgr = [[NSFileManager alloc] init];
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *files = [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:nil];
    
    while (files.count > 0) {
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSArray *directoryContents = [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error];
        if (error == nil) {
            for (NSString *path in directoryContents) {
                NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:path];
                BOOL removeSuccess = [fileMgr removeItemAtPath:fullPath error:&error];
                files = [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:nil];
                if (!removeSuccess) {
                    // Error
                }
            }
        } else {
            // Error
        }
    }
}
- (BOOL) NSStringIsValidEmail:(NSString*) checkString
    {
        BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/va ... l-address/
        NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
        NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
        NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        return [emailTest evaluateWithObject:checkString];
    }


// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    _ScrollView.contentInset = contentInsets;
    _ScrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, _FormView.frame.origin) )
    {
        CGPoint scrollPoint = CGPointMake(0.0, _FormView.frame.origin.y-kbSize.height);
        [_ScrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _ScrollView.contentInset = contentInsets;
    _ScrollView.scrollIndicatorInsets = contentInsets;
}

@end
