//
//  IMDeliveryInformationController.m
//  Delivery
//
//  Created by Developer on 23.12.14.
//  Copyright (c) 2014 incodemobile. All rights reserved.
//

#import "IMDeliveryInformationController.h"
#import "MMDrawerBarButtonItem.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "IMCartManager.h"
#import "IMInfoManager.h"

@interface IMDeliveryInformationController ()

@end
IMAppDelegate *appDelegate;
@implementation IMDeliveryInformationController

- (IBAction)OnCartTransition:(UIButton *)sender
{
    UIViewController* centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Cart"];
    IMCartViewController* Cart = centerViewController.childViewControllers[0];
    Cart.delegate = self;
    
    // present
    [self presentViewController:centerViewController animated:YES completion:nil];
}

- (void) UpdateView
{
    
}

- (void)viewDidLoad
{
    appDelegate = [[UIApplication sharedApplication] delegate];
    [super viewDidLoad];
    
    [_ButtonCart setTitle:[CartManager GetMoneyInCartString] forState:UIControlStateNormal];
    if ([CartManager GetItemsCount] == 0) [self.ButtonCart setEnabled:NO];
    
//    _DelieveryInformationScrollView.bounces = NO;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        if ([Tools CanCreateDrawerButton])[self setupLeftMenuButton];
    }
    
    float rd = 255.00/255.00;
    float gr = 255.00/255.00;
    float bl = 255.00/255.00;
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    [self setNeedsStatusBarAppearanceUpdate];
    

    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"Lobster" size:21], NSFontAttributeName,
      [UIColor colorWithRed:rd green:gr blue:bl alpha:1.0], NSForegroundColorAttributeName,
      nil]];
    
    self.navigationController.navigationBar.barTintColor = appDelegate.MainAppColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    IMItem* DeliveryConditionsInfo = [InfoManager GetItemByIndex:0];
    _DeliveryConditionsLabel.text = DeliveryConditionsInfo.Description;
    
    
    self.mm_drawerController.centerHiddenInteractionMode = MMDrawerOpenCenterInteractionModeNone;

}

- (void)setupLeftMenuButton
{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton];
}

- (void)leftDrawerButtonPress:(id)leftDrawerButtonPress
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    // STYLE OF DRAWER TRANSITION
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
