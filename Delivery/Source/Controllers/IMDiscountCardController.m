//
//  IMDiscountCardController.m
//  Delivery
//
//  Created by Peter on 17/08/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMDiscountCardController.h"
#import "IMAppDelegate.h"
#import "Tools.h"
#import "MMDrawerBarButtonItem.h"
#import "MMDrawerVisualState.h"
#import "UIViewController+MMDrawerController.h"

@interface IMDiscountCardController ()
{
    IMAppDelegate* AppDelegate;
}
@end

@implementation IMDiscountCardController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate = (IMAppDelegate*) [[UIApplication sharedApplication] delegate];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.navigationController.navigationBar.barTintColor = AppDelegate.MainAppColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    if ([Tools CanCreateDrawerButton])[self SetupLeftMenuButton];
    // Do any additional setup after loading the view.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)LeftDrawerButtonPress:(id)LeftDrawerButtonPress
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    // STYLE OF DRAWER TRANSITION
    
}

- (void)SetupLeftMenuButton
{
    [self.mm_drawerController setDrawerVisualStateBlock:[MMDrawerVisualState slideAndScaleVisualStateBlock]];
    
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(LeftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton];
    //[self.mm_drawerController setCenterHiddenInteractionMode:(MMDrawerOpenCenterInteractionModeNavigationBarOnly)];
    
    self.mm_drawerController.centerHiddenInteractionMode = MMDrawerOpenCenterInteractionModeNone;
    [self.mm_drawerController setMaximumLeftDrawerWidth:250];
    
    [self.mm_drawerController setDrawerVisualStateBlock:[MMDrawerVisualState slideAndScaleVisualStateBlock]];
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModePanningCenterView;
    self.mm_drawerController.closeDrawerGestureModeMask = MMOpenDrawerGestureModePanningCenterView;
    
    // super.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.PanningCenterView | MMCloseDrawerGestureMode.TapCenterView
    
}

@end
