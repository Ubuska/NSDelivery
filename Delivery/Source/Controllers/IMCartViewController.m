//
//  IMCartViewController.m
//  Delivery
//
//  Created by Developer on 11.12.14.
//  Copyright (c) 2014 incodemobile. All rights reserved.
//

#import "IMCartViewController.h"
#import "IMCartManager.h"
#import "IMBonusManager.h"
#import "IMBonus.h"
#import "IMEventViewCell.h"
#import "IMDiscountManager.h"

@interface IMCartViewController ()

@end
IMAppDelegate *appDelegate;


@implementation IMCartViewController
@synthesize delegate;
@synthesize MakeOrder;
@synthesize ClearCart;

@synthesize EmptyCartLabel;
@synthesize PicURL;
@synthesize productImage;

@synthesize NavigationBar;
@synthesize StatusBar;

NSMutableArray *Additions;

float AnimationDuration = 0.6f;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // iPad Cart Cell
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        
            return 100;
        
    }
    // iPhone Cart Cell
    else
    {

            return 100;

    }
    return 83;
}

- (void) FillWithColor
{
    [NavigationBar setTranslucent:NO];
    [NavigationBar setBarTintColor:appDelegate.MainAppColor];
    StatusBar.backgroundColor = appDelegate.MainAppColor;
    self.DiscountView.backgroundColor = appDelegate.MainAppColor;

}

- (void) ActivateDiscount
{
    // Step 1, update your constraint
    self.DiscountViewHeight.constant = 80;
    self.LineWidth.constant = 80;// New height (for example)
    
    // Step 2, trigger animation
    [UIView animateWithDuration:AnimationDuration animations:^{
        
        // Step 3, call layoutIfNeeded on your animated view's parent
        [self.view layoutIfNeeded];
        
        
    }];
}

- (void) DeactivateDiscount
{
    // Step 1, update your constraint
    self.DiscountViewHeight.constant = 0; // New height (for example)
    self.LineWidth.constant = 0;
    // Step 2, trigger animation
    [UIView animateWithDuration:AnimationDuration animations:^{
        
        // Step 3, call layoutIfNeeded on your animated view's parent
        [self.view layoutIfNeeded];
        
    }];
}

- (IBAction)OnFormTransition:(UIButton *)sender
{
    // Instantitate and set the center view controller.
    //IMFormViewController *centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Form"];
    if ([CartManager IsOrderSumEnough])
    {
        [self flipToNext];
    }
    else
    {
        UIAlertView *Alert = [[UIAlertView new] initWithTitle:@"" message:@"Сумма заказа не превышает минимальной" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [Alert show];
    }
    // present
    //[self presentViewController:centerViewController animated:YES completion:nil];
    
}

-(IBAction)flipToNext
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {

    IMFormViewController *centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Form"];
    
    UIViewController *src = (UIViewController *) self;
    UIViewController *dst = (UIViewController *) centerViewController;
    
    [UIView beginAnimations:@"LeftFlip" context:nil];
    [UIView setAnimationDuration:0.8];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:src.view.superview cache:YES];
    [UIView commitAnimations];
    
    [src presentViewController:dst animated:YES completion:nil];
    
    }
    else
    {
    [self performSegueWithIdentifier: @"FormBlurSegue" sender: self];
        
    }
    
}

- (IBAction)OnBackButtonPress:(id)sender
{
    [self.delegate UpdateView];
    // Dismiss modal view
    //[self dismissViewControllerAnimated:YES completion:nil];
    if (![self isBeingDismissed])
    {
        
        [self dismissViewControllerAnimated:YES completion:^{
            //[self.delegate PostUpdateView];
        }];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = (IMAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    _NavView.backgroundColor = appDelegate.MainAppColor;
    NavigationBar.backgroundColor = appDelegate.MainAppColor;
    [self FillWithColor];
    
    // Initialize the Data Array
    DataArray = [NSMutableArray new];
    
   [self.view layoutIfNeeded];
    
    [self CheckForDiscount];
    // First Section (Products)
    //NSArray *FirstSectionArray = appDelegate.ProductsInCart;
   // NSDictionary *FirstItemsArrayDict = [NSDictionary dictionaryWithObject:appDelegate.ProductsInCart forKey:@"data"];
   // [DataArray addObject:FirstItemsArrayDict];
   // Additions = appDelegate.AdditionsInCart;
    
       //NSDictionary *SecondItemsArrayDict = [NSDictionary dictionaryWithObject:Additions forKey:@"data"];
   // NSLog(@"Dictionary length: %i", SecondItemsArrayDict.count);
   // [DataArray addObject:SecondItemsArrayDict];

    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    [self setNeedsStatusBarAppearanceUpdate];
    
    if ([[IMCartManager SharedInstance] GetItemsCount] == 0)
    {
        MakeOrder.hidden = true;
        ClearCart.hidden = true;
        _SummaryView.hidden = true;
        
    }
    else
    {
        EmptyCartLabel.hidden = true;
    }
    
     [self setNeedsStatusBarAppearanceUpdate];
    self.navigationController.navigationBar.barTintColor = appDelegate.MainAppColor;
   }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
    //return [DataArray count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
       return @"";
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

}

- (IBAction)ClearAll:(id)sender
{
    
    NSMutableArray* indexPathsToDelete = [[NSMutableArray alloc] init];
    self.Summary.text = @"";
    for(unsigned int i = 0; i < [CartManager GetItemsCount]; i++)
    {
        IMProduct *Product = [CartManager GetItemByIndex:i];
        Product.Quantity = 0;
        [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    for(int i = 0; i < [ CartManager GetBonusesCount]; i++)
    {
        
        //IMAddition *CurrentAddition = Additions[i];
        [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:1]];
    }

    
    [self.tableView beginUpdates];
    [[IMCartManager SharedInstance] ClearAll];

    [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView endUpdates];

        MakeOrder.hidden = true;
        ClearCart.hidden = true;
        EmptyCartLabel.hidden = false;
        _SummaryView.hidden = true;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        //return _ProductsInCart.count;
    
    //Number of rows it should expect should be based on the section
    //NSDictionary *dictionary = [DataArray objectAtIndex:section];
    //NSArray *array = [dictionary objectForKey:@"data"];
    //NSLog(@"Array Count = %i", [array count]);
    //return [array count];
    [self CheckForDiscount];
    if (section == 0) return [[IMCartManager SharedInstance] GetItemsCount];
    // If not products, then bonuses count
    return [CartManager GetBonusesCount];
}

- (IBAction)OnBonusRemove:(UIButton *)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *IndexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    NSMutableArray* IndexPathsToDelete = [[NSMutableArray alloc] init];
    [IndexPathsToDelete addObject:[NSIndexPath indexPathForRow:IndexPath.row inSection:1]];
    IMBonus* BonusToRemove = [CartManager GetBonusByIndex:IndexPath.row];
        [self.tableView beginUpdates];
            [CartManager RemoveBonus:BonusToRemove];
            [self.tableView deleteRowsAtIndexPaths:IndexPathsToDelete withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView endUpdates];
    
    [self.tableView reloadData];
}

- (IBAction)OnStepperPressed:(IMStepper *)sender 
{
   
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *IndexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    IMProduct *product = [CartManager GetItemByIndex:IndexPath.row];
    
    if (sender.plusMinusState == JLTStepperPlus)
    {
        
        double valueD = (double)sender.value;
        int valI = (int)valueD;
        product.quantity = valI;
        [self UpdateStepperValue:sender];
        
        
    }
    else if (sender.plusMinusState == JLTStepperMinus)
    {
        double valueD = (double)sender.value;
        int valI = (int)valueD;
        product.Quantity = valI;
        if (product.Quantity <= 0)
            {
                [self UpdateStepperValue:sender];
                [CartManager RemoveItem:product];
                NSMutableArray* indexPathsToDelete = [[NSMutableArray alloc] init];
                
                    [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:IndexPath.row inSection:0]];

                    [self.tableView beginUpdates];
                    [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationLeft];
                    [self.tableView endUpdates];
                
                
                if ([CartManager IsEmpty])
                {
                    [self ClearAll:sender];
                    MakeOrder.hidden = true;
                    ClearCart.hidden = true;
                    EmptyCartLabel.hidden = false;
                    _SummaryView.hidden = true;
                }
                
                
                
                
            }
        else
        {
            [self UpdateStepperValue:sender];
        }
    }
    [self CheckForDiscount];
}


- (void) CheckForDiscount
{
    // Check if discounts active
    if ([DiscountManager IsDiscountActive])
    {
        //self.DiscountLabel.text = @"";
        //self.OldPrice.text = @"";
        [self ActivateDiscount];
    }
    else [self DeactivateDiscount];
    
    // Update strings
    // Generate discount string
    NSMutableString* DiscountString = [NSMutableString stringWithString:@"Скидка "];
    IMDiscount* Discount = [DiscountManager GetCurrentDiscount];
    if (Discount)
    {
        [DiscountString appendString:[NSString stringWithFormat:@"%i", [Discount GetDiscountPercent]]];
        [DiscountString appendString:@"% ("];
        Money Discounted = [CartManager GetMoneyInCartWithoutDiscount] - [CartManager GetMoneyInCart];
        //int DiscountedSum = [CartManager GetMoneyInCart] - Discounted;
        [DiscountString appendString:[NSString stringWithFormat:@"%.2f", Discounted]];
        [DiscountString appendString:@")"];
        
        self.DiscountLabel.text = [DiscountString copy];
        
        NSMutableString* OldPrice = [NSMutableString stringWithFormat:@"%.2f", [CartManager GetMoneyInCartWithoutDiscount]];
        [OldPrice appendString:@" Р."];
        self.OldPrice.text = OldPrice;
    }
    
    
}

- (IBAction)UpdateStepperValue:(IMStepper *)stepper AndUpdateProduct:(IMProduct* )Product
{
    
    UIView *view = stepper.superview;
    UILabel *PriceLabel = view.subviews[1];
    
    Money ProductPrice = [Product.ProductPrice doubleValue];
    int ProductQuantity = Product.Quantity;
    Money ProductSummaryPrice = ProductPrice * stepper.value;
    
    NSString *Money = [NSString stringWithFormat: @"%.2f", ProductSummaryPrice];
    NSMutableString *ProductSummary = [NSMutableString stringWithFormat:Money];
    [ProductSummary appendString: @" P."];
    PriceLabel.text = ProductSummary;
    
    NSNumber *stepperVal = [NSNumber numberWithDouble:stepper.value];
    stepper.StepperValue.text = [stepperVal stringValue];

    
}

- (void) UpdateStepperValue:(IMStepper *)stepper
{
    CGPoint buttonPosition = [stepper convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *IndexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];

    //IMProduct *Product = appDelegate.ProductsInCart[IndexPath.row];
    IMProduct *Product = [[IMCartManager SharedInstance] GetItemByIndex:IndexPath.row];
    
    NSNumber *stepperVal = [NSNumber numberWithDouble:stepper.value];
    stepper.StepperValue.text = [stepperVal stringValue];
    

    UIView *view = stepper.superview;
    UILabel *PriceLabel = view.subviews[1];
    
    
    int valueI = Product.Quantity;
    double valueD = (double) valueI;
    stepper.value = valueD;

    Money ProductPrice = [Product.ProductPrice intValue];
    int ProductQuantity = Product.Quantity;
    Money ProductSummaryPrice = ProductPrice * valueI;

    NSString *Money = [NSString stringWithFormat: @"%.2f", ProductSummaryPrice];
    NSMutableString *ProductSummary = [NSMutableString stringWithFormat:Money];
    [ProductSummary appendString: @" P."];
    PriceLabel.text = ProductSummary;

    NSString *SummaryMoney = [NSString stringWithFormat: @"%.2f", [CartManager GetMoneyInCart]];
    ProductSummary = [NSMutableString stringWithFormat:SummaryMoney];
    [ProductSummary appendString: @" P."];
    _Summary.text = ProductSummary;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CartCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    // Configure the cell...
    if (cell != nil)
    {
        
       // NSDictionary *Dictionary = [DataArray objectAtIndex:indexPath.section];
        NSLog(@"%d", indexPath.section);
        //NSArray *array = [Dictionary objectForKey:@"data"];
        switch (indexPath.section)
        {
                // Products
            case 0:
            {
                IMProduct *Product = [CartManager GetItemByIndex:indexPath.row];
                
                 IMCartProductCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
                 cell.ProductName.text = [Product GetName];
                 cell.ProductQuantity.text = [NSString stringWithFormat:@"%d", Product.Quantity];
                [cell.Stepper setTintColor:appDelegate.MainAppColor];
                 // Set product image
                 [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:cell.image];
                 //[[AsyncImageLoader sharedLoader] loadImageWithURL:Product.picurl];
                 //load the image
                cell.image.showActivityIndicator = YES;
                cell.image.activityIndicatorStyle = UIActivityIndicatorViewStyleGray;

                 cell.image.imageURL = [NSURL URLWithString:Product.ImageURL];

                 IMStepper *stepper = (IMStepper*) cell.Stepper;
                 int valueI = Product.Quantity;
                 double valueD = (double) valueI;
                 stepper.value = valueD;
                 
                 
                 
                [self UpdateStepperValue:stepper AndUpdateProduct:Product];
                return cell;

            }
                break;
            
            case 1:
            {
                IMBonus *Bonus = [[IMCartManager SharedInstance] GetBonusByIndex:indexPath.row];
                IMEventViewCell* BonusCell = [tableView dequeueReusableCellWithIdentifier:@"BonusCell" ];
                BonusCell.photo.imageURL = [NSURL URLWithString:Bonus.ImageURL];
                BonusCell.name.text = [Bonus GetName];
                [BonusCell.RemoveButton setTintColor:appDelegate.MainAppColor];
                return BonusCell;
            }
                
                
        }

        

        //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        
                //NSString *cellValue = [array objectAtIndex:indexPath.row];
        
        
        
    }
    
    return cell;
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
