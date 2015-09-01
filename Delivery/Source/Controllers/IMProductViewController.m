//
//  IMProductViewController.m
//  Delivery
//
//  Created by Developer on 10.12.14.
//  Copyright (c) 2014 incodemobile. All rights reserved.
//

#import "IMProductViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "MMDrawerVisualState.h"
#import "UIViewController+MMDrawerController.h"
#import "IMDrawerController.h"

#import "IMCartManager.h"
#import "IMSectionManager.h"
#import "IMProductManager.h"
#import "IMProductParser.h"
#import "ViewController.h"
#import "Protocols.h"


@implementation IMProductViewController

NSCache *ImagesCache;
IMAppDelegate *appDelegate;


@synthesize tableView;
@synthesize NavigationButton;




- (IBAction)OnCartTransition:(UIButton *)sender
{
    // Instantitate and set the center view controller.
    UIViewController* centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Cart"];
    IMCartViewController* Cart = centerViewController.childViewControllers[0];
    Cart.delegate = self;
    
    // present
    [self presentViewController:centerViewController animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([CartManager IsEmpty]) [self.ButtonCart setEnabled:NO];
    else [self.ButtonCart setEnabled:YES];
}

/** This function called when we need to update Stepper Value.
    Also we call UpdateCartMoney method because we want actual money information on Stepper Value Update.
 
    @param StepperToUpdate is required to update stepper value
 */
- (void) UpdateStepperValue:(IMStepper *)StepperToUpdate
{
    
    [_ButtonCart setTitle:[CartManager GetMoneyInCartString] forState:UIControlStateNormal];
    NSLog(@"UpdateStepperValue");
    NSNumber *StepperVal = [NSNumber numberWithDouble:StepperToUpdate.value];
    StepperToUpdate.StepperValue.text = [StepperVal stringValue];
    //[self UpdateCartMoney];
}

/** 
 Method requesting CalculateCartMoney execution from App Delegate.
 Then it assignes CartMoney value from App Delegate (Model) to MoneySum Outlet (View).
 */


- (void) UpdateCartMoney
{
    //[appDelegate CalculateCartMoney];

    //NSString *Money = [NSString stringWithFormat: @"%d", appDelegate.CartMoney];
   // NSMutableString *CartSummary = [NSMutableString stringWithFormat:Money];
   // [CartSummary appendString: @" P."];
    //_MoneySum.titleLabel.text = CartSummary;


}

/**
 IBAction tightened with IMStepper. Called on IMStepper use.
@param UsedStepper Stepper that called this method.
 */
- (IBAction)StepperUse:(IMStepper *)UsedStepper
{
    CGPoint buttonPosition = [UsedStepper convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *IndexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];

    Section* CurrentSection = [SectionManager GetActiveSection];
    NSMutableArray* Products = [SectionManager FilterChildrenByType:CurrentSection FilterClass:[IMProduct class]];
    IMProduct *Product = Products[IndexPath.row];
    
    if (UsedStepper.plusMinusState == JLTStepperPlus)
    {
        double valueD = [UsedStepper value];
        int valI = (int)valueD;
        Product.Quantity = valI;
        
        // iPad simply adds Product in Cart (if Cart doesn't have this product already)
        // iPad doesn't use AddProduct method since we have simplier UI on iPad.
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            if (valI > 0)
            {
                
                //if (![appDelegate.ProductsInCart containsObject:Product])
                //{
                   // [appDelegate.ProductsInCart addObject:Product];
                
                [self.ButtonCart setEnabled:YES];
                
                [[IMCartManager SharedInstance] AddItem:Product];
                //}
            }
        }

    }
    
    else if (UsedStepper.plusMinusState == JLTStepperMinus)
    {
        double valueD = [UsedStepper value];
        int valI = (int)valueD;
        Product.Quantity = valI;

        // If we have zero Product Quantity, delete it from Cart.
        if (Product.Quantity <= 0) [[IMCartManager SharedInstance] RemoveItem:Product];
        if ([CartManager IsEmpty]) [self.ButtonCart setEnabled:NO];
        else [self.ButtonCart setEnabled:YES];
        [self RemoveProduct:UsedStepper];

    }
    [self UpdateStepperValue:UsedStepper];
}

                     
// iPhone only method
- (void)AddProduct:(UIButton*)sender
{
    if ([CartManager GetItemsCount] == 0) [self.ButtonCart setEnabled:YES];
    // Just in case, check if we use iPhone.
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) return;
    for(UIView *view in sender.superview.subviews)
    {
        if ([view isKindOfClass:[UIView class]] && view.tag == 128)
        {
            for(IMStepper *stepper in view.subviews)
            {
                if ([stepper isKindOfClass:[IMStepper class]])
                {
                    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
                    NSIndexPath *IndexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
                    Section* CurrentSection = [SectionManager GetActiveSection];
                    NSMutableArray* Products = [SectionManager FilterChildrenByType:CurrentSection FilterClass:[IMProduct class]];
                    IMProduct *Product = Products[IndexPath.row];
                    Product.Quantity = 1;
                    stepper.value += 1.0f;
                    [[IMCartManager SharedInstance] AddItem:Product];
                    [self UpdateStepperValue:stepper];
                    [self AnimationFadeIn:view];
                    
                }
            }
           

  
        }

    [UIView animateWithDuration:0.5
                          delay: 0.1
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         sender.alpha = 1.0;
                     }
                     completion:^(BOOL finished)
                        {
                         [UIView animateWithDuration:1.0 animations:^
                          {
                             sender.alpha = 0.0;
                         }];
                     }];
    
    }
    
}

- (void)RemoveProduct:(IMStepper*)UsedStepper
{
    UIView *Currentview = UsedStepper.superview.superview;
    
    for(UIView *view in Currentview.subviews)
    {
        if ([view isKindOfClass:[UIView class]] && view.tag == 128)
        {
            if (UsedStepper.value < 1)
                [self AnimationFadeOut:view];
        }
    }
    
}


- (void) AnimationFadeIn: (UIView*) view
{
    view.hidden = NO;
    [view setAlpha:0.0f];
    
    //fade in
    [UIView animateWithDuration:0.5f animations:^
     {
         [view setAlpha:1.0f];
         
         
     } completion:^(BOOL finished)
     {
         
         UIView *v = view.superview;
         UIButton *b = v.subviews[2];
         
         CGPoint buttonPosition = [b convertPoint:CGPointZero toView:self.tableView];
         NSIndexPath *IndexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
         IMProduct *product = [ProductManager GetItemByIndex:IndexPath.row];
         
         NSMutableString *ProductPrice = [NSMutableString stringWithFormat:product.ProductPrice];
         [ProductPrice appendString: @" P."];
         
         b.titleLabel.text = ProductPrice;
         
     }];

}

- (void) AnimationFadeOut: (UIView*) view
{
    view.hidden = NO;
    [view setAlpha:1.0f];
    
    //fade out
    [UIView animateWithDuration:0.5f animations:^
     {
         [view setAlpha:0.0f];
         UIView *v = view.superview;
         UIButton *b = v.subviews[2];
         [b setAlpha:1.0f];
         b.hidden = NO;
         
     } completion:^(BOOL finished)
     {
         view.hidden = YES;
     }];

}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

-(void) viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound)
    {
        NSLog(@"Back");
        Section* CurrentSection = [SectionManager GetActiveSection];
        Section* ParentSection = (Section*)[CurrentSection GetParent];
        if (ParentSection) [SectionManager SetActiveSection:ParentSection];
    }
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{

    [super viewDidAppear:animated];

    if ([Tools CanCreateDrawerButton])[self SetupLeftMenuButton];
    
}


- (void)SetupLeftMenuButton
{
    [self.mm_drawerController setDrawerVisualStateBlock:[MMDrawerVisualState slideAndScaleVisualStateBlock]];
    
    if ([SectionManager GetActiveSection])
    {
        
        
        Section* ActiveSection = [SectionManager GetActiveSection];
        
        if ([ActiveSection GetItemIndex] == 0)
        {
            MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
            [self.navigationItem setLeftBarButtonItem:leftDrawerButton];

        }
    }
    else
    {
        MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
        [self.navigationItem setLeftBarButtonItem:leftDrawerButton];

    }
        //[self.mm_drawerController setCenterHiddenInteractionMode:(MMDrawerOpenCenterInteractionModeNavigationBarOnly)];
    
    self.mm_drawerController.centerHiddenInteractionMode = MMDrawerOpenCenterInteractionModeNone;
    [self.mm_drawerController setMaximumLeftDrawerWidth:250];
    
    [self.mm_drawerController setDrawerVisualStateBlock:[MMDrawerVisualState slideAndScaleVisualStateBlock]];
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModePanningCenterView;
    self.mm_drawerController.closeDrawerGestureModeMask = MMOpenDrawerGestureModePanningCenterView;

   // super.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.PanningCenterView | MMCloseDrawerGestureMode.TapCenterView

}

- (void)leftDrawerButtonPress:(id)leftDrawerButtonPress
{
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    // STYLE OF DRAWER TRANSITION
    [self.mm_drawerController setDrawerVisualStateBlock:[MMDrawerVisualState slideAndScaleVisualStateBlock]];
    //
    
    [self.mm_drawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible)
    {
         UIViewController * sideDrawerViewController;
         if(drawerSide == MMDrawerSideLeft)
         {
             sideDrawerViewController = drawerController.leftDrawerViewController;
         }
         else if(drawerSide == MMDrawerSideRight)
         {
             sideDrawerViewController = drawerController.rightDrawerViewController;
         }
         [sideDrawerViewController.view setAlpha:percentVisible];
     }];
    
    
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
    appDelegate.ControllerDelegate = self;
    
    [super viewDidLoad];
    [self UpdateView];
    
   // Spinner = [UIActivityIndicatorView new];
    //[Spinner startAnimating];
    //Spinner.center = tableView.center;
    //[tableView addSubview:Spinner];
    
    
    
    // Create image cache.
    ImagesCache = [[NSCache alloc] init];

    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self setNeedsStatusBarAppearanceUpdate];

    self.navigationController.navigationBar.barTintColor = appDelegate.MainAppColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];


    // Initialize the refresh control.
   // self.refreshControl = [[UIRefreshControl alloc] init];
   // self.refreshControl.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.0];
   // self.refreshControl.tintColor = [UIColor whiteColor];
   // [self.refreshControl addTarget:self
    //                        action:@selector(UpdateProductDataFromServer)
    //              forControlEvents:UIControlEventValueChanged];
    
    
    
    
    // Temporary?
    //if ([SectionManager GetActiveSection] == nil)
   // {
   // IMSection* ActiveSection = [SectionManager GetItemByIndex:0];
   // [SectionManager SetActiveSection:ActiveSection];
   // }

}


- (void) ReloadDataFailed
{
    // End the refreshing
    if (self.refreshControl)
    {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Обновление не состоялось: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        
        [self.refreshControl endRefreshing];
    }

}

- (void) UpdateView
{
    [_ButtonCart setTitle:[CartManager GetMoneyInCartString] forState:UIControlStateNormal];
    //[Spinner stopAnimating];
     if ([SectionManager GetActiveSection] == NULL)
     {
         Section* StartSection = [SectionManager GetItemByIndex:0];
         [tableView numberOfRowsInSection:[ProductManager GetItemsCount]];
         [SectionManager SetActiveSection:StartSection];
     }
    
    if ([CartManager IsEmpty]) [self.ButtonCart setEnabled:NO];
    else [self.ButtonCart setEnabled:YES];
    
    [self performSelectorOnMainThread:@selector(ReloadData) withObject:nil waitUntilDone:YES];
    //[tableView reloadData];
}


- (void)ReloadData
{
   
    // Reload table data
    [self.tableView reloadData];
    return;
    // End the refreshing
    if (self.refreshControl)
    {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Последнее обновление: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        
        [self.refreshControl endRefreshing];
    }
    
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Section* CurrentSection = [SectionManager GetActiveSection];
    //NSUInteger test = [SectionManager GetProductsCountInSection:CurrentSection];
    
    // Sections count
    if (section == 0)
    {
        //return 1;
        return [SectionManager GetItemCountInSection:CurrentSection FilterClass:[Section class]];
    }
    // Products count
    else if (section == 1)
    {
        //return 1;
        NSUInteger test = [SectionManager GetItemCountInSection:CurrentSection FilterClass:[IMProduct class]];
        return [SectionManager GetItemCountInSection:CurrentSection FilterClass:[IMProduct class]];
    }
    return 0;
   
    
}


- (void) RemoveLeftButton
{
    NavigationButton.leftBarButtonItem = nil;
    NavigationButton.leftItemsSupplementBackButton = YES;
    
}


- (void) SectionPressed
{
    
    [self RemoveLeftButton];
    UIStoryboard *Storyboard = self.storyboard;
    IMProductViewController *dest = [Storyboard instantiateViewControllerWithIdentifier:@"Products"];
    [self.navigationController pushViewController:dest animated:YES];
    //[tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectedIndex = indexPath.row;
    if (indexPath.section == 0)
    {
        Section* CurrentActiveSection = [SectionManager GetActiveSection];
        NSMutableArray* Sections = [NSMutableArray arrayWithCapacity:0];
        Sections = [SectionManager FilterChildrenByType:CurrentActiveSection FilterClass:[Section class]];
        Section* NewActiveSection = Sections[indexPath.row];
        [SectionManager SetActiveSection:NewActiveSection];
        [self SectionPressed];
    }
    else
    {
        [self performSegueWithIdentifier:@"DetailSegue" sender:self];
    }



}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *NormalCellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NormalCellIdentifier ];
    
    // Configure the cell...
    if (cell != nil)
    {
        // SECTIONS SECTION
        if (indexPath.section == 0)
        {
            NSLog(@"Section");
            Section* CurrentSection = [SectionManager GetActiveSection];
            NSMutableArray* Sections = [NSMutableArray arrayWithCapacity:0];
            Sections = [SectionManager FilterChildrenByType:CurrentSection FilterClass:[Section class]];
            if ([Sections count] == 0) return cell;
            
            Section* SectionsInThisRow = Sections[indexPath.row];
            NSString *SectionCellIdentifier = @"SectionCell";
            IMSectionViewCell *cell = (IMSectionViewCell *)[tableView dequeueReusableCellWithIdentifier:SectionCellIdentifier];
            cell.SectionName.text = [SectionsInThisRow GetName];
            cell.SectionName.textColor = appDelegate.MainAppColor;
            
            if ([SectionsInThisRow GetChildCount] > 0)
            {
                cell.userInteractionEnabled = YES;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                //[cell.sup addTarget:self action:@selector(AddProduct:) forControlEvents:UIControlEventTouchUpInside];
                    
                    // Selection Style
               //     cell.selectionStyle = UITableViewCellSelectionStyleGray;
                
            }
            
            return cell;

        }
        
        // PRODUCTS SECTION
        else if (indexPath.section == 1)
        {
            
        //IMProduct *Product = (appDelegate.Products)[indexPath.row];
        Section* CurrentSection = [SectionManager GetActiveSection];
            NSMutableArray* Products = [SectionManager FilterChildrenByType:CurrentSection FilterClass:[IMProduct class]];
            IMProduct* Product = Products[indexPath.row];
                IMProductViewCell *cell = (IMProductViewCell *)[tableView dequeueReusableCellWithIdentifier:NormalCellIdentifier];
                
                if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
                    {
                        cell.addbutton.tag = indexPath.row;
                        [cell.addbutton addTarget:self action:@selector(AddProduct:) forControlEvents:UIControlEventTouchUpInside];
            
                        // Selection Style
                        cell.selectionStyle = UITableViewCellSelectionStyleGray;
                    }
                
                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:cell.image];
                //Load the image
                cell.image.showActivityIndicator = YES;
                cell.image.activityIndicatorStyle = UIActivityIndicatorViewStyleGray;
                cell.image.imageURL = [NSURL URLWithString:Product.ImageURL];
                cell.name.text = [Product GetName];
                cell.description.text = Product.Description;
                Money ProductPriceD = [Product.ProductPrice doubleValue];
                NSMutableString *ProductPrice = [NSMutableString stringWithFormat:@"%.2f", ProductPriceD];
                [ProductPrice appendString: @" P."];
                [cell.addbutton setTitle:ProductPrice forState:UIControlStateNormal];
                cell.addbutton.titleLabel.text = ProductPrice;
            
            IMStepper *stepperview = cell.StepperView;
            cell.StepperView.tintColor = appDelegate.MainAppColor;
            stepperview.StepperValue.textColor = appDelegate.MainAppColor;
            
                if (![Product.Status isEqualToString:@"0"])
                {
                    [cell.StatusView setHidden:NO];
                    cell.StatusTextView.text = Product.Status;
                    
                }
            
                IMProduct* CheckedProduct = [[IMCartManager SharedInstance] GetItemById:[Product GetId]];
                if (CheckedProduct)
                {
                        UIView *view = cell.subviews[0];
                         NSArray *vComp = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
                        if ([[vComp objectAtIndex:0] intValue] == 7)
                        {
                            // iOS-7 code[current] or greater
                            view = view.subviews[1];
                        }
                    
                        IMStepper *stepperview = cell.StepperView;

                        // iPhone behavior
                        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
                            {
  
  
                                    stepperview.superview.alpha = 100.0f;
                                    stepperview.superview.hidden = NO;

                                    UIButton *b = cell.addbutton;
                                    [b setAlpha:0.0f];
                                    b.hidden = true;

                                    int valI = CheckedProduct.Quantity;
                                    double value = (double)valI;
                                    stepperview.value = value;

                                    [self UpdateStepperValue:stepperview];
                        
                            }
                        
                        // iPad behavior
                        else
                        {
                            IMStepper *stepper = (IMStepper *)stepperview;
                            int valI = CheckedProduct.Quantity;
                            double value = (double)valI;
                            stepper.value = value;
                            [self UpdateStepperValue:stepper];
                        }
                    }
            
                
                return cell;
            
        /*else if ([Product isKindOfClass:[IMSection class]])
            {
                IMSection *Product = (appDelegate.Products)[indexPath.row];
                NSString *SectionCellIdentifier = @"SectionCell";
                IMSectionViewCell *cell = (IMSectionViewCell *)[tableView dequeueReusableCellWithIdentifier:SectionCellIdentifier];
                cell.SectionName.text = Product.name;
                cell.SectionName.textColor = appDelegate.MainAppColor;
                return cell;
            
            }*/
        }
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            // iPad Section
            if (indexPath.section == 0)
            {
                return 100;
            }
             //iPad Cell
            else
            {
                return 120;
            }

        }
    else
        {
            // iPhone Section
            if (indexPath.section == 0)
                {
                    return 48;
                }
             //iPhone Cell
            else
                {
                    return 96;
                }
        }
    return 40;
    }



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DetailSegue"])
        {
           
            
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            IMProduct* DesiredProduct = (IMProduct*)[[SectionManager GetActiveSection] GetChildByIndex:indexPath.row];
            ViewController* DestViewController = segue.destinationViewController;
            DestViewController.PageUpdateDelegate = self;
            DestViewController.PageIndex = SelectedIndex;
            DestViewController.Products = [SectionManager FilterChildrenByType:[SectionManager GetActiveSection] FilterClass:[IMProduct class]];
            //IMProductDetailController* DetailController = (IMProductDetailController*) DestViewController;
            //DetailController.MasterViewDelegate = self;
            //DestViewController.DetailItem = DesiredProduct;
            
        }
    
    
        
}

@end
