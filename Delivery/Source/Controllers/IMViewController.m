//
//  IMViewController.m
//  Delivery
//
//  Created by Developer on 12.12.14.
//  Copyright (c) 2014 incodemobile. All rights reserved.
//

#import "IMViewController.h"
#import "MMDrawerController.h"
#import "IMProductViewController.h"
#import "MMDrawerVisualState.h"

#import "IMAppDelegate.h"
#import "IMProductManager.h"
#import "IMProductParser.h"
#import "IMSplitViewController.h"



@interface IMViewController ()

@end

@implementation IMViewController

IMAppDelegate* AppDelegate;


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self performSegueWithIdentifier:@"DRAWER_SEGUE" sender:self];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   	// Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DRAWER_SEGUE"])
    {
        
        AppDelegate = (IMAppDelegate*) [[UIApplication sharedApplication] delegate];
        IMDrawerController *destinationViewController = (IMDrawerController *) segue.destinationViewController;
        
        // Instantitate and set the center view controller.
        UIViewController *centerViewController;
        
               
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUs"];
        }
        else if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)
        {
            centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StartController"];
            
           
        }

        //IMAppDelegate* AppDelegate = (IMAppDelegate*) [[UIApplication sharedApplication] delegate];
        //AppDelegate.ControllerDelegate = destinationViewController;
        //[AppDelegate UpdateDataFromServer:[IMProductManager SharedInstance] Parser:[IMProductParser new] URL:@"Products"];
        //centerViewController.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
        //UINavigationBar* navbar = centerViewController.navigationController.navigationBar;
        [destinationViewController setCenterViewController:centerViewController];

        // Instantiate and set the left drawer controller.
        UIViewController *leftDrawerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SIDE_DRAWER_CONTROLLER"];
        [destinationViewController setLeftDrawerViewController:leftDrawerViewController];
        
        // Use all gestures for closing the drawer
        //destinationViewController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeTapCenterView;
        // Open the drawer only when panning the center view from the edge
        //destinationViewController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
        // Set a parallax animation for opening drawer
        //[destinationViewController setDrawerVisualStateBlock:[MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:10]];
        
        
        

        
    }
}
@end
