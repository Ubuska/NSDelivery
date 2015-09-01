//
//  IMEventDetailController.m
//  Delivery
//
//  Created by Developer on 22.12.14.
//  Copyright (c) 2014 incodemobile. All rights reserved.
//

#import "IMEventDetailController.h"
#import "IMEvent.h"
#import "IMCartManager.h"

@interface IMEventDetailController ()

@end

@implementation IMEventDetailController

@synthesize EventLabel;
@synthesize EventDescriptionLabel;
@synthesize EventImage;

- (void) SetDetailItem:(id)DetailItem ParentDelegate:(id<UpdateControllerView>)Delegate
{
    ParentViewDelegate = Delegate;
    if ([DetailItem isKindOfClass:[IMEvent class]])
    {
        EventDetailItem = (IMEvent*) DetailItem;
        
        // Update the view.
        [self ConfigureView];
    }
}

- (void) UpdateView
{
    [_ButtonCart setTitle:[CartManager GetMoneyInCartString] forState:UIControlStateNormal];
    if ([CartManager IsEmpty]) [self.ButtonCart setEnabled:NO];
    else [self.ButtonCart setEnabled:YES];
}

- (IBAction)OnCartTransition:(UIButton *)sender
{
    UIViewController* centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Cart"];
    IMCartViewController* Cart = centerViewController.childViewControllers[0];
    Cart.delegate = self;
    
    // present
    [self presentViewController:centerViewController animated:YES completion:nil];
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
    [self UpdateView];
    [self ConfigureView];
    
    if ([CartManager IsEmpty]) [self.ButtonCart setEnabled:NO];
    else [self.ButtonCart setEnabled:YES];
    [_ButtonCart setTitle:[CartManager GetMoneyInCartString] forState:UIControlStateNormal];
    IMAppDelegate* AppDelegate = (IMAppDelegate*) [[UIApplication sharedApplication] delegate];

    self.navigationController.navigationBar.barTintColor = AppDelegate.MainAppColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController)
    {
        [ParentViewDelegate UpdateView];
    }
}

- (void)ConfigureView
{
    
    // Update the user interface for the detail item.
    EventLabel.text = [EventDetailItem GetName];
    EventDescriptionLabel.text = EventDetailItem.Description;
    
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:self.EventImage];
    EventImage.showActivityIndicator = YES;
    EventImage.activityIndicatorStyle = UIActivityIndicatorViewStyleGray;
    EventImage.imageURL = [NSURL URLWithString:EventDetailItem.ImageURL];
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
