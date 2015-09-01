//
//  IMRestarauntViewController.m
//  Delivery
//
//  Created by Developer on 22.12.14.
//  Copyright (c) 2014 incodemobile. All rights reserved.
//

#import "IMAddressViewController.h"
#import "IMAddressManager.h"
#import "IMCartManager.h"
#import "IMCartViewController.h"

@interface IMAddressViewController ()

@end
IMAppDelegate *appDelegate;

@implementation IMAddressViewController

@synthesize tableView;

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
    [_ButtonCart setTitle:[CartManager GetMoneyInCartString] forState:UIControlStateNormal];
    if ([CartManager IsEmpty]) [self.ButtonCart setEnabled:NO];
    else [self.ButtonCart setEnabled:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_ButtonCart setTitle:[CartManager GetMoneyInCartString] forState:UIControlStateNormal];
    appDelegate = [[UIApplication sharedApplication] delegate];
    if ([Tools CanCreateDrawerButton])[self setupLeftMenuButton];
    
    float rd = 255.00/255.00;
    float gr = 95.00/255.00;
    float bl = 63.00/255.00;
    
    self.navigationController.navigationBar.barTintColor = appDelegate.MainAppColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    [self setNeedsStatusBarAppearanceUpdate];
    
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"Lobster" size:26], NSFontAttributeName,
      [UIColor colorWithRed:rd green:gr blue:bl alpha:1.0], UITextAttributeTextColor,
      nil]];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [AddressManager GetItemsCount];
}


- (void)setupLeftMenuButton
{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton];
    //self.mm_drawerController.centerHiddenInteractionMode = MMDrawerOpenCenterInteractionModeFull;
   // self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeTapNavigationBar;
}

- (void)leftDrawerButtonPress:(id)leftDrawerButtonPress
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    // STYLE OF DRAWER TRANSITION
   // [self.mm_drawerController setDrawerVisualStateBlock:[MMDrawerVisualState slideAndScaleVisualStateBlock]];
    //self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModePanningCenterView;
    //self.mm_drawerController.closeDrawerGestureModeMask = MMOpenDrawerGestureModePanningCenterView;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"RestarauntCell";
    IMAddress *Restaraunt = [AddressManager GetItemByIndex:indexPath.row];
    IMRestarauntViewCell *cell = (IMRestarauntViewCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    //IMEventViewCell *cell = (IMEventViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell != nil)
    {
        if (cell.Name) cell.Name.text = [Restaraunt GetName];
        if (cell.Address) cell.Address.text = [Restaraunt GetAddress];
        if (cell.Description) cell.Description.text = Restaraunt.Description;
        cell.Photo.showActivityIndicator = YES;
        cell.Photo.activityIndicatorStyle = UIActivityIndicatorViewStyleGray;
        if (cell.Photo) cell.Photo.imageURL = [NSURL URLWithString:Restaraunt.ImageURL];
        if (cell.Phone)
        {
            cell.Phone.text = [Restaraunt GetPhone];
            cell.Phone.textColor = appDelegate.MainAppColor;
        }
        //cell.name.text = Restaraunt.name;
       // cell.description.text = Restaraunt.desctiptionText;
       // cell.adress.text = Restaraunt.adress;
       // cell.city.text = Restaraunt.city;
        
        
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"RestarauntDetailSegue"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        IMAddress* ChosenAddress = [AddressManager GetItemByIndex:indexPath.row];
        id <DetailView> DestViewController = segue.destinationViewController;
        
        [DestViewController SetDetailItem:ChosenAddress ParentDelegate:self];
    }
    
    
    
}
@end
