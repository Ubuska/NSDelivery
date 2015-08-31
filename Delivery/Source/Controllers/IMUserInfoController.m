//
//  IMUserInfoController.m
//  Delivery
//
//  Created by Peter on 30/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMUserInfoController.h"
#import "IMAppDelegate.h"
#import "MMDrawerBarButtonItem.h"
#import "MMDrawerVisualState.h"
#import "UIViewController+MMDrawerController.h"
#import "IMDrawerController.h"
#import "IMCartManager.h"
#import "IMBonusManager.h"

@implementation IMUserInfoController

@synthesize PhoneNumber;
@synthesize RootView;
@synthesize ButtonConfirm;

IMAppDelegate* AppDelegate;

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

- (void) UpdateView
{
   [_ButtonCart setTitle:[CartManager GetMoneyInCartString] forState:UIControlStateNormal];
   if ([CartManager GetItemsCount] == 0) [self.ButtonCart setEnabled:NO];
   
   NSUserDefaults* Defaults = [NSUserDefaults standardUserDefaults];
   NSString *UserPhoneNumber = [Defaults objectForKey:@"UserPhoneNumber"];
   
   NSLog(UserPhoneNumber);
   if (UserPhoneNumber.length > 0)
   {
      PhoneNumber.text = UserPhoneNumber;
   }
   
   // Switch
   if (nil != [Defaults objectForKey:@"InitializedDefaults"])
   {
      BOOL bIsAutofillCardInfoEnabled = [Defaults boolForKey:@"PaymentAutoFill"];
      BOOL bIsAutofillEnabled = [Defaults boolForKey:@"UserInfoAutoFill"];
      [_SwitchAutofill setOn:bIsAutofillEnabled];
      [_SwitchAutofillCardInfo setOn:bIsAutofillCardInfoEnabled];
   }
   else
   {
      [Defaults setObject:@"Initialized" forKey:@"InitializedDefaults"];
      [_SwitchAutofill setOn:YES];
      [_SwitchAutofillCardInfo setOn:YES];
      [Defaults synchronize];
   }
}

- (IBAction)OnCartTransition:(UIButton *)sender
{
   UIViewController* centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Cart"];
   IMCartViewController* Cart = centerViewController.childViewControllers[0];
   Cart.delegate = self;
   // present
   [self presentViewController:centerViewController animated:YES completion:nil];
}

- (void) viewDidLoad
{
   
    [super viewDidLoad];
    AppDelegate = (IMAppDelegate*) [[UIApplication sharedApplication] delegate];
   
    [self UpdateView];
    
    if ([Tools CanCreateDrawerButton])[self SetupLeftMenuButton];
    
   self.navigationController.navigationBar.barTintColor = AppDelegate.MainAppColor;
   self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [_SwitchAutofill setOnTintColor:AppDelegate.MainAppColor];
    [_SwitchAutofillCardInfo setOnTintColor:AppDelegate.MainAppColor];
    [ButtonConfirm setTintColor:AppDelegate.MainAppColor];
    
    [RootView.layer setCornerRadius:10.0f];
    // drop shadow
    [RootView.layer setShadowColor:[UIColor blackColor].CGColor];
    [RootView.layer setShadowOpacity:0.8];
    [RootView.layer setShadowRadius:7.0];
    [RootView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    //[RootView setBackgroundColor:AppDelegate.MainAppColor];
    
    keyboardIsShown = NO;
    //make contentSize bigger than your scrollSize (you will need to figure out for your own use case)
    CGSize scrollContentSize = CGSizeMake(320, 345);
    self.ScrollView.contentSize = scrollContentSize;
    
}

- (IBAction)backgroundTap:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)OnUserInfoChange:(id)sender
{
   // Reset User Bonuses
   [CartManager ClearBonuses];
   [BonusManager ResetBonuses];
    [self.view endEditing:YES];
    if (PhoneNumber.text.length > 0)
    {
        NSUserDefaults* Defaults = [NSUserDefaults standardUserDefaults];
        [Defaults setObject:PhoneNumber.text forKey:@"UserPhoneNumber"];
        [Defaults synchronize];
        
        UIAlertView *Alert = [[UIAlertView new] initWithTitle:@"" message:@"Номер телефона изменен" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [Alert show];
    }
    else
    {
        UIAlertView *Alert = [[UIAlertView new] initWithTitle:@"" message:@"Заполните номер телефона" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [Alert show];
        return;
    }
   
   
}

- (IBAction)OnAutoFillSwitch:(id)sender
{
    UISwitch *Switch = (UISwitch *)sender;
    
    NSUserDefaults* Defaults = [NSUserDefaults standardUserDefaults];
    [Defaults setBool:Switch.isOn forKey:@"UserInfoAutoFill"];
    [Defaults synchronize];
}

- (IBAction)OnAutoFillCardInfoSwitch:(id)sender
{
    UISwitch *Switch = (UISwitch *)sender;
    
    NSUserDefaults* Defaults = [NSUserDefaults standardUserDefaults];
    [Defaults setBool:Switch.isOn forKey:@"PaymentAutoFill"];
    [Defaults synchronize];
}

BOOL keyboardIsShown;

#pragma mark - keyboard offset stuff
#define kOFFSET_FOR_KEYBOARD 180.0
#define kTabBarHeight 50.0
- (void)keyboardWillHide:(NSNotification *)n
{
   if (_ScrollView) _ScrollView.scrollEnabled = NO;
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
    if (_ScrollView) _ScrollView.scrollEnabled = YES;
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
    viewFrame.size.height -= (keyboardSize.height);
    
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

#pragma mark - Drawer stuff (iPhone only)

- (void)SetupLeftMenuButton
{
    
    self.navigationController.navigationBar.barTintColor = AppDelegate.MainAppColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(LeftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton];
    self.mm_drawerController.centerHiddenInteractionMode = MMDrawerOpenCenterInteractionModeFull;
    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeTapNavigationBar;
}

- (void)LeftDrawerButtonPress:(id)leftDrawerButtonPress
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


@end
