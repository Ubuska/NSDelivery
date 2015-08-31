//
//  IMDrawerController.m
//  Delivery
//
//  Created by Developer on 11.12.14.
//  Copyright (c) 2014 incodemobile. All rights reserved.
//

#import "IMDrawerController.h"

#import "IMSectionManager.h"
#import "IMSlideDrawerController.h"
#import "IMSplitViewController.h"

#import "IMEventManager.h"
IMAppDelegate *appDelegate;

@interface IMDrawerController ()

@end

IMProductViewController *CenterController;

@implementation IMDrawerController


- (void) TransitionFromNotification
{
    IMEventViewController* EventsController = [self.storyboard instantiateViewControllerWithIdentifier:@"FOURTH_TOP_VIEW_CONTROLLER"];
IMEventDetailController* EventsDetailController = [self.storyboard instantiateViewControllerWithIdentifier:@"EventDetail"];
    //[self.navigationController pushViewController:EventsDetailController animated:NO];
    self.centerViewController = EventsController;
    //EventsController.view.window.rootViewController = EventsDetailController;
    //[EventsController.navigationController pushViewController:EventsDetailController animated:NO];
    //[DetailEventsController SetDetailItem:[EventManager GetItemByIndex:2] ParentDelegate:nil];

    //[self.centerViewController.childViewControllers[0] addChildViewController:PreviousController];
    //UpdateController = self.centerViewController.childViewControllers[0];

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = (IMAppDelegate*) [[UIApplication sharedApplication] delegate];
    appDelegate.NotificationResponderDelegate = self;
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
   // self.centerHiddenInteractionMode = MMDrawerOpenCenterInteractionModeNone;
   // self.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
    
    
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    id<UpdateControllerView> UpdateController;
    // Landscape
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        UIViewController* PreviousController = self.centerViewController;
        NSLog(@"Rotation");
        // Instantitate and set the center view controller.
        IMSplitViewController* NewCenterViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StartController"];
        [NewCenterViewController SetRightViewController:PreviousController];
        self.centerViewController = NewCenterViewController;
        UpdateController = NewCenterViewController;
        
    }
    
    else
    {
        UIViewController* PreviousController = self.centerViewController;
        UIViewController* NewCenterViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FIRST_TOP_VIEW_CONTROLLER"];
        self.centerViewController = NewCenterViewController;
        [self.centerViewController.childViewControllers[0] addChildViewController:PreviousController];
        UpdateController = self.centerViewController.childViewControllers[0];
        // Instantitate and set the center view controller.
       
    }
    
    
    [UpdateController UpdateView];
    
}

- (void) SetSelectedRow:(int)Index
{
    SelectedRow = Index;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) openDrawerSide:(MMDrawerSide)drawerSide animated:(BOOL)animated completion:(void (^)(BOOL))completion
{
    [super openDrawerSide:drawerSide animated:animated completion:completion];
    UITableViewController *cnt =self.leftDrawerViewController ;
    [[IMSectionManager SharedInstance] SetSectionIndex:0 ];
    [cnt.tableView reloadData];
    int Count = [[IMSectionManager SharedInstance] GetItemsCount];
    return;
}

- (void) closeDrawerAnimated:(BOOL)animated completion:(void (^)(BOOL))completion
{
    [super closeDrawerAnimated:animated completion:completion];
   
    NSArray* ChildViewControllers = self.centerViewController.childViewControllers;
    
    NSMutableArray* SectionsInCurrentIndex = [[IMSectionManager SharedInstance] FilterSectionsByIndex:0];
    Section *Section = SectionsInCurrentIndex[SelectedRow];

    //[[IMSectionManager SharedInstance] SetSectionIndex:0 ];
    [[IMSectionManager SharedInstance] SetActiveSection:Section];
    //[cnt.tableView reloadData];
    [appDelegate.ControllerDelegate UpdateView];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DRAWER_SEGUE"])
    {
        MMDrawerController *destinationViewController = (MMDrawerController *)segue.destinationViewController;
        
    }
    

    
}


@end
