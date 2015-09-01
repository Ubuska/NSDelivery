//
//  IMSecondViewController.m
//  Delivery
//
//  Created by Developer on 12.12.14.
//  Copyright (c) 2014 incodemobile. All rights reserved.
//

#import "IMEventViewController.h"

#import "MMDrawerBarButtonItem.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"

#import "IMEventManager.h"
#import "Tools.h"
#import "IMCartManager.h"

@interface IMEventViewController ()

@end

@implementation IMEventViewController

IMAppDelegate *appDelegate;

@synthesize tableView;


- (void) UpdateView
{
    [_ButtonCart setTitle:[CartManager GetMoneyInCartString] forState:UIControlStateNormal];
    if ([CartManager GetItemsCount] == 0) [self.ButtonCart setEnabled:NO];
}

- (IBAction)OnCartTransition:(UIButton *)sender
{
    UIViewController* centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Cart"];
    IMCartViewController* Cart = centerViewController.childViewControllers[0];
    Cart.delegate = self;
    // present
    [self presentViewController:centerViewController animated:YES completion:nil];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    float rd = 255.00/255.00;
    float gr = 255.00/255.00;
    float bl = 255.00/255.00;
    appDelegate = (IMAppDelegate*) [[UIApplication sharedApplication] delegate];
    if ([Tools CanCreateDrawerButton])[self setupLeftMenuButton];
    
    if ([CartManager GetItemsCount] == 0) [self.ButtonCart setEnabled:NO];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    
    
    if ([CartManager GetItemsCount] == 0) [self.ButtonCart setEnabled:NO];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"Lobster" size:26], NSFontAttributeName,
      [UIColor colorWithRed:rd green:gr blue:bl alpha:1.0], UITextAttributeTextColor,
      nil]];
    
    self.navigationController.navigationBar.barTintColor = appDelegate.MainAppColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self UpdateView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [EventManager GetItemsCount];

}


- (void)setupLeftMenuButton
{
    
    NSLog(@"seup bitton");
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton];
}

- (void)leftDrawerButtonPress:(id)leftDrawerButtonPress
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    // STYLE OF DRAWER TRANSITION
    [self.mm_drawerController setDrawerVisualStateBlock:[MMDrawerVisualState slideAndScaleVisualStateBlock]];
    //self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModePanningCenterView;
    self.mm_drawerController.closeDrawerGestureModeMask = MMOpenDrawerGestureModePanningCenterView;
}

- (IMEventViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
        static NSString *CellIdentifier = @"EventCell";
    IMEvent *Event = [EventManager GetItemByIndex:indexPath.row];
    IMEventViewCell *cell = (IMEventViewCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        //IMEventViewCell *cell = (IMEventViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell != nil)
    {
        cell.name.text = [Event GetName];
        cell.description.text = Event.Description;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:cell.photo];
        //[[AsyncImageLoader sharedLoader] loadImageWithURL:Product.picurl];
        //load the image
        cell.photo.showActivityIndicator = YES;
        cell.photo.activityIndicatorStyle = UIActivityIndicatorViewStyleGray;
        cell.photo.imageURL = [NSURL URLWithString:Event.ImageURL];
        
      
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EventDetailSegue"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        IMEvent* ChosenEvent = [EventManager GetItemByIndex:indexPath.row];
        id <DetailView> DestViewController = segue.destinationViewController;
        [DestViewController SetDetailItem:ChosenEvent ParentDelegate:self];

    }
    
    
    
}


@end
