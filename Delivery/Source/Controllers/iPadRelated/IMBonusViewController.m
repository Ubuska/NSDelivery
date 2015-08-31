//
//  IMBonusViewController.m
//  Delivery
//
//  Created by Peter on 26/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMBonusViewController.h"
#import "IMBonusManager.h"
#import "IMProductManager.h"
#import "IMBonus.h"
#import "IMProduct.h"
#import "IMBonusViewCell.h"
#import "AsyncImageView.h"
#import "IMAppDelegate.h"
#import "IMProductViewController.h"
#import "DetailViewController.h"
#import "IMOperationCheckBonuses.h"
#import "IMCartManager.h"
#import "Tools.h"
#import "MMDrawerBarButtonItem.h"
#import "MMDrawerVisualState.h"
#import "UIViewController+MMDrawerController.h"
#import "IMDrawerController.h"

@implementation IMBonusViewController

IMAppDelegate* AppDelegate;



#pragma mark - UIViewController methods

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
     
    /*
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if(!_TapBehindGesture)
            {
                _TapBehindGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapBehindDetected:)];
                [_TapBehindGesture setNumberOfTapsRequired:1];
                _TapBehindGesture.cancelsTouchesInView = NO; //So the user can still interact with controls in the modal view
                [self.view.window addGestureRecognizer:_TapBehindGesture];
                _TapBehindGesture.delegate = self;
            }
    }*/
}


- (void) viewDidLoad
{
    [super viewDidLoad];
    

    
    [_ButtonCart setTitle:[CartManager GetMoneyInCartString] forState:UIControlStateNormal];
    AppDelegate = (IMAppDelegate*) [[UIApplication sharedApplication] delegate];
    if ([Tools CanCreateDrawerButton])[self SetupLeftMenuButton];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.navigationController.navigationBar.barTintColor = AppDelegate.MainAppColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    NSLog(@"Bonus Controller View Loaded");
    NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
    NSString *UserPhoneNumber = [Defaults objectForKey:@"UserPhoneNumber"];
    if (UserPhoneNumber.length > 0)
    {
    
    Spinner = [UIActivityIndicatorView new];
    [Spinner startAnimating];

    Spinner.center = self.TableView.center;
    [self.TableView addSubview:Spinner];
   // [self RequestBonusesFromServer];
    
     RefreshControl = [[UIRefreshControl alloc] init];
     RefreshControl.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.0];
     RefreshControl.tintColor = [UIColor whiteColor];
     [RefreshControl addTarget:self
                            action:@selector(RequestBonusesFromServer)
                  forControlEvents:UIControlEventValueChanged];
    [self.TableView addSubview:RefreshControl];

    [self RequestBonusesFromServer];
    }
    
    if ([CartManager IsEmpty]) [self.ButtonCart setEnabled:NO];
    else [self.ButtonCart setEnabled:YES];
   
}

- (void) RequestBonusesFromServer
{
    NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
    NSString *UserPhoneNumber = [Defaults objectForKey:@"UserPhoneNumber"];
    if (UserPhoneNumber.length > 0)
    {
        Queue = [[NSOperationQueue alloc] init];
        IMOperationCheckBonuses* OperationCheck = [IMOperationCheckBonuses new];
        [OperationCheck InitializeWithNumber:UserPhoneNumber];
        OperationCheck.InstigatorUpdateDelegate = self;
        [Queue addOperation:OperationCheck];
    }
}

- (void) ReloadDataFailed
{
    // End the refreshing
    if (RefreshControl)
    {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Обновление не состоялось: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        RefreshControl.attributedTitle = attributedTitle;
        
        
        [RefreshControl endRefreshing];
    }
    
}
- (void) FinishLoading
{
    // Reload table data
    [self.TableView reloadData];
    
    // End the refreshing
    if (RefreshControl)
    {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Последнее обновление: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        RefreshControl.attributedTitle = attributedTitle;
        
        
        [RefreshControl endRefreshing];
    }

}

- (void) FailedLoading
{
    UIAlertView *Alert = [[UIAlertView new] initWithTitle:@"" message:@"Почтовый адрес пуст" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [Alert show];
    [self ReloadDataFailed];
}

- (void) UpdateView
{
    //[Spinner stopAnimating];
   
   // [self performSelectorOnMainThread:@selector(ReloadData) withObject:nil waitUntilDone:YES];
    [_ButtonCart setTitle:[CartManager GetMoneyInCartString] forState:UIControlStateNormal];
    if ([CartManager IsEmpty]) [self.ButtonCart setEnabled:NO];
    else [self.ButtonCart setEnabled:YES];
    [self.TableView reloadData];
}


- (void) viewWillDisappear:(BOOL)animated
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
    [self.view.window removeGestureRecognizer:_TapBehindGesture];
    }
}


- (void)TapBehindDetected:(UITapGestureRecognizer *)sender
{

    if (sender.state == UIGestureRecognizerStateEnded)
    {
        
        // passing nil gives us coordinates in the window
        CGPoint location = [sender locationInView:nil];
        
        // swap (x,y) on iOS 8 in landscape
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
        {
            if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
            {
                location = CGPointMake(location.y, location.x);
            }
        }
        
        // convert the tap's location into the local view's coordinate system, and test to see if it's in or outside. If outside, dismiss the view.
        if (![self.view pointInside:[self.view convertPoint:location fromView:self.view.window] withEvent:nil])
        {
            
            // remove the recognizer first so it's view.window is valid
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (IBAction)OnButtonCartTransitionPress:(id)sender
{
    UIViewController* centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Cart"];
    IMCartViewController* Cart = centerViewController.childViewControllers[0];
    Cart.delegate = self;
    
    // present
    [self presentViewController:centerViewController animated:YES completion:nil];
}

- (IBAction)OnCartTransitionPress:(id)sender
{
    CGPoint ButtonPosition = [sender convertPoint:CGPointZero toView:self.TableView];
    NSIndexPath *indexPath = [self.TableView indexPathForRowAtPoint:ButtonPosition];
    
    IMBonus* Bonus = [BonusManager GetItemByIndex:indexPath.row];
    
    // Instantitate and set the center view controller.
    UIViewController* centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Cart"];
    IMCartViewController* CartViewController = centerViewController.childViewControllers[0];
    if (![CartManager GetBonusById:[Bonus GetId]])
    {
       // [CartManager AddBonus:Bonus];
    }
    CartViewController.delegate = self;
    
    [self.view.window removeGestureRecognizer:_TapBehindGesture];
    
    // present
    [self presentViewController:centerViewController animated:YES completion:nil];
}

- (IBAction)OnProductPress:(id)sender
{
    CGPoint ButtonPosition = [sender convertPoint:CGPointZero toView:self.TableView];
    NSIndexPath *indexPath = [self.TableView indexPathForRowAtPoint:ButtonPosition];
    if (indexPath != nil)
    {
       
        UIStoryboard *Storyboard = self.storyboard;
        //IMProductViewController *Destination = [Storyboard instantiateViewControllerWithIdentifier:@"ProductsGrid"];
        DetailViewController* ProductDetail = [Storyboard instantiateViewControllerWithIdentifier:@"DetailPopoverViewController"];
        //[self.navigationController pushViewController:Destination animated:NO];
        
       // self.ThePopoverController.popoverContentSize = [self.PopoverViewController.view                                                     sizeThatFits:CGSizeMake(512.0, 618.0)];

        ProductDetail.modalPresentationStyle = UIModalPresentationFormSheet;
        ProductDetail.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:ProductDetail animated:YES completion:nil];
        ProductDetail.view.superview.frame = CGRectMake(0, 0, 540, 620); //it's important to do this after presentModalViewController
        ProductDetail.view.superview.center = self.view.center;
        
        ProductDetail.UpdateViewDelegate = self;
        
        IMBonus* Bonus = [BonusManager GetItemByIndex:indexPath.row];
        IMProduct* Product = [ProductManager GetItemById:[Bonus GetProductId]];
        [ProductDetail SetDetails:Product];
        
        //[V1 release];
        
    }
}
- (void) SetStepperValue:(NSObject*)Product ValueToSet:(int)Value
{
    [_ButtonCart setTitle:[CartManager GetMoneyInCartString] forState:UIControlStateNormal];
    if ([CartManager IsEmpty]) [self.ButtonCart setEnabled:NO];
    else [self.ButtonCart setEnabled:YES];
}

- (void)SetAppColorTo:(UIButton*)Button
{
    UIView *ColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    ColorView.backgroundColor = AppDelegate.MainAppColor;
    
    UIGraphicsBeginImageContext(ColorView.bounds.size);
    [ColorView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *ColorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIControlState State = UIControlStateNormal;
    
    [Button setBackgroundImage:ColorImage forState:State];
}

#pragma mark - Drawer stuff (iPhone only)

- (void)SetupLeftMenuButton
{
    [self.mm_drawerController setDrawerVisualStateBlock:[MMDrawerVisualState slideAndScaleVisualStateBlock]];
    self.navigationController.navigationBar.barTintColor = AppDelegate.MainAppColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(LeftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton];
    
    
    //self.mm_drawerController.centerHiddenInteractionMode = MMDrawerOpenCenterInteractionModeNone;
   // [self.mm_drawerController setMaximumLeftDrawerWidth:250];
    
    //[self.mm_drawerController setDrawerVisualStateBlock:[MMDrawerVisualState slideAndScaleVisualStateBlock]];
    //self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModePanningCenterView;
   // self.mm_drawerController.closeDrawerGestureModeMask = MMOpenDrawerGestureModePanningCenterView;
    
}

- (void)LeftDrawerButtonPress:(id)leftDrawerButtonPress
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


#pragma mark - UITableView Delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [BonusManager GetItemsCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BonusCell";
    
    IMBonusViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (Cell == nil)
    {
        Cell = (IMBonusViewCell*) [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Setting fields values
    IMBonus* Bonus = [BonusManager GetItemByIndex:indexPath.row];
    IMProduct* Product = [ProductManager GetItemById:[Bonus GetProductId]];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:Cell.BonusImage];
    
    Cell.BonusName.text = [Bonus GetName];
    Cell.BonusDescription.text = Bonus.Description;
    Cell.BonusImage.showActivityIndicator = YES;
    Cell.BonusImage.activityIndicatorStyle = UIActivityIndicatorViewStyleGray;
    Cell.BonusImage.imageURL = [NSURL URLWithString:Bonus.ImageURL];
    
    NSUInteger BonusQuantity = [Bonus GetQuantity];
   
    //Cell.BonusProgressBar.progress = [Bonus GetQuantity] / [Bonus GetSum];
    float Quantity = [Bonus GetQuantity];
    if ([CartManager GetBonusById:[Bonus GetId]])
    {
        Quantity -= [Bonus GetSum];
        BonusQuantity -= [Bonus GetSum];
        Cell.BonusButton.enabled = NO;
        Cell.BonusAdvice.text = @"Бонус уже есть в корзине";
        
    }
    else
    {
        Cell.BonusAdvice.text = @"Продукт для получения бонуса";
        if ([Bonus GetQuantity] >= [Bonus GetSum])
        {
            Cell.BonusButton.enabled = YES;
        }
        else
        {
            Cell.BonusButton.enabled = NO;
        }

    }
    float Sum = [Bonus GetSum];
    float BonusProgress =  Quantity / Sum;
    [Cell.BonusProgressBar setProgress:BonusProgress animated:YES];
    
    NSMutableString *BonusStatus = [NSMutableString stringWithFormat:@"%lu", (unsigned long)BonusQuantity];
    [BonusStatus appendString: @"/"];
    [BonusStatus appendString: [NSMutableString stringWithFormat:@"%lu", (unsigned long)[Bonus GetSum]]];
     Cell.BonusQuantity.text = BonusStatus;
    [Cell.BonusProductLink setTitle:[Product GetName] forState:UIControlStateNormal];
    
    
    // Coloring elements
    Cell.BonusQuantity.textColor = AppDelegate.MainAppColor;
    Cell.BonusProgressBar.tintColor = AppDelegate.MainAppColor;
    if (Product)[Cell.BonusProductLink setTitleColor:AppDelegate.MainAppColor forState:UIControlStateNormal];
    [self SetAppColorTo:Cell.BonusButton];
    
    if (Product) [Cell.BonusProductLink addTarget:self action:@selector(OnProductPress:) forControlEvents:UIControlEventTouchUpInside];

    
    return Cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"BonusDetail"])
    {
        
        
        NSIndexPath *indexPath = [self.TableView indexPathForSelectedRow];
        IMBonus* DesiredBonus = [BonusManager GetItemByIndex:indexPath.row];

        id <DetailView> DestViewController = segue.destinationViewController;
        [DestViewController SetDetailItem:DesiredBonus ParentDelegate:self];
        
    }
    
    
    
}


#pragma mark - UIGestureRecognizer Delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{return YES;}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{return YES;}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{return YES;}



@end











