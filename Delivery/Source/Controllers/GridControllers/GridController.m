//
//  GridController.m
//  Delivery
//
//  Created by Peter on 16/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//
#import "MMDrawerBarButtonItem.h"
#import "MMDrawerVisualState.h"
#import "UIViewController+MMDrawerController.h"
#import "IMDrawerController.h"

#import "GridController.h"
#import "IMAppDelegate.h"
#import "IMSectionManager.h"
#import "IMProductManager.h"
#import "IMProductGridCell.h"
#import "IMProductParser.h"
#import "IMHeaderViewCell.h"

#import "IMCartManager.h"





@implementation GridController


@synthesize PopoverViewController;

NSCache *ImagesCache;

// Delegate method


- (IBAction)OnCartTransition:(UIButton *)sender
{
    // Instantitate and set the center view controller.
    UIViewController* centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Cart"];
    IMCartViewController* Cart = centerViewController.childViewControllers[0];
    Cart.delegate = self;
    
    // present
    [self presentViewController:centerViewController animated:YES completion:nil];
}

/**
 IBAction tightened with IMStepper. Called on IMStepper use.
 @param UsedStepper Stepper that called this method.
 */
- (IBAction)StepperUse:(IMStepper *)UsedStepper
{
    NSIndexPath *IndexPath = [self.CollectionView indexPathForCell:UsedStepper.StepperCellContainer];
    
    Section* CurrentSection = [SectionManager GetActiveSection];
    NSMutableArray* Products = [SectionManager FilterChildrenByType:CurrentSection FilterClass:[IMProduct class]];
    IMProduct *Product = Products[IndexPath.row];
    
    if (UsedStepper.plusMinusState == JLTStepperPlus)
    {
        double valueD = [UsedStepper value];
        int valI = (int)valueD;
        Product.Quantity = valI;
        
            if (valI > 0)
            {
                [self.ButtonCart setEnabled:YES];
                [CartManager AddItem:Product];
            }
        
        
    }
    
    else if (UsedStepper.plusMinusState == JLTStepperMinus)
    {
        double valueD = [UsedStepper value];
        int valI = (int)valueD;
        Product.Quantity = valI;
        
        // If we have zero Product Quantity, delete it from Cart.
        if (Product.Quantity <= 0) [[IMCartManager SharedInstance] RemoveItem:Product];
        if ([CartManager GetItemsCount] == 0) [self.ButtonCart setEnabled:NO];
        //[self RemoveProduct:UsedStepper];
        
    }
    [self UpdateStepperValue:UsedStepper];
}


/** This function called when we need to update Stepper Value.
 Also we call UpdateCartMoney method because we want actual money information on Stepper Value Update.
 
 @param StepperToUpdate is required to update stepper value
 */
- (void) UpdateStepperValue:(IMStepper *)StepperToUpdate
{
    
    [_ButtonCart setTitle:[CartManager GetMoneyInCartString] forState:UIControlStateNormal];
    NSNumber *StepperVal = [NSNumber numberWithDouble:StepperToUpdate.value];
    StepperToUpdate.StepperValue.text = [StepperVal stringValue];
    //[self UpdateCartMoney];
}


- (void)viewDidLoad
{
    [_ButtonCart setTitle:[CartManager GetMoneyInCartString] forState:UIControlStateNormal];
    //CGRect fr = CGRectMake(101, 45, 300, 416);
    //_HeadersView.frame = CGRectMake(0, 0, 200, 100);
   // _HeadersView= [[UITableView alloc] initWithFrame:fr
                                                           //style:UITableViewStylePlain];
    
   /* _HeadersView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _HeadersView.delegate = self;
    _HeadersView.dataSource = self;
    [_HeadersView reloadData];
    
    [self.ContentView addSubview:_HeadersView];
    */
    
    
    
    
    IMAppDelegate* AppDelegate = [[UIApplication sharedApplication] delegate];
    AppDelegate.ControllerDelegate = self;
   // [AppDelegate UpdateDataFromServer:[IMProductManager SharedInstance] URL:@"Products"];
    // Create image cache.
    ImagesCache = [[NSCache alloc] init];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.navigationController.navigationBar.barTintColor = AppDelegate.MainAppColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    

    UIStoryboard *Storyboard = self.storyboard;
   
    self.PopoverViewController = [Storyboard instantiateViewControllerWithIdentifier:@"DetailPopoverViewController"];

    
    self.ThePopoverController.popoverContentSize = [self.PopoverViewController.view
                                                    sizeThatFits:CGSizeMake(512.0, 618.0)];

    self.PopoverViewController.UpdateViewDelegate = self;
    // Popover stuff
    //PopoverViewController = [[DetailPopoverViewController alloc]
                                  //initWithNibName:@"DetailPopoverViewController" bundle:nil];
    
    //PopoverViewController.popoverContentSize = [self.popoverViewController.view
                                                    //sizeThatFits:CGSizeMake(512.0, 618.0)];
    
    
    //[appDelegate UpdateDataFromServer:[IMProductManager SharedInstance] URL:@"Products"];
    
    
  
  
    
    if ([CartManager GetItemsCount] == 0) [self.ButtonCart setEnabled:NO];
    [super viewDidLoad];
    
}

- (void) HeaderPress:(Section*)HeaderSection
{
    [SectionManager SetActiveSection:HeaderSection];
    UIStoryboard *Storyboard = self.storyboard;
    IMProductViewController *dest = [Storyboard instantiateViewControllerWithIdentifier:@"ProductsGrid"];
    [self.navigationController pushViewController:dest animated:YES];
    
}

- (void) SetStepperValue:(NSObject*)Product ValueToSet:(int)Value
{
    // Get visible cell for data item
    IMProduct* CurrentProduct = (IMProduct*) Product;
    NSInteger Row = [ProductManager GetIndexOfItem:Product];
    NSIndexPath *IndexPath = [NSIndexPath indexPathForRow:Row inSection:0];
    IMProductGridCell *Cell = [_CollectionView cellForItemAtIndexPath:IndexPath];
    double valueD = (double)Value;
    Cell.StepperView.value = valueD;
    Cell.Quantity.text = [NSString stringWithFormat: @"%d", CurrentProduct.Quantity];
    
    [_ButtonCart setTitle:[CartManager GetMoneyInCartString] forState:UIControlStateNormal];
    if ([CartManager GetItemsCount]) [_ButtonCart setEnabled:YES];
    else [_ButtonCart setEnabled:NO];
}


- (void) UpdateView
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        [self SetupLeftMenuButton];
    }
    else if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)
    {
        self.mm_drawerController.centerHiddenInteractionMode = MMDrawerOpenCenterInteractionModeNone;
        self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
        self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeNone;
        if (self.mm_drawerController.openSide == MMDrawerSideLeft)
        {
            
            [self.mm_drawerController closeDrawerAnimated:NO completion:nil];
            [_SectionUpdateDelegate UpdateView];
        }
    }

    
    
    [_ButtonCart setTitle:[CartManager GetMoneyInCartString] forState:UIControlStateNormal];
    if ([CartManager GetItemsCount] == 0) [self.ButtonCart setEnabled:NO];
    if ([[IMSectionManager SharedInstance] GetActiveSection] == NULL)
    {
        Section* ASection = [[IMSectionManager SharedInstance] GetItemByIndex:0];
        [[IMSectionManager SharedInstance] SetActiveSection:ASection];
    }
    
    Section* CurrentSection = [SectionManager GetActiveSection];
    
    NSMutableArray* Products = [[IMSectionManager SharedInstance] FilterChildrenByType:CurrentSection FilterClass:[IMProduct class]];
    
    //[self.CollectionView reloadItemsAtIndexPaths:[self.CollectionView indexPathsForVisibleItems]];
    //[self.CollectionView numberOfItemsInSection:0];
    
    /*
    CGRect CollectionFrame = _CollectionView.frame;
    _CollectionView.pagingEnabled = NO;
    //CollectionFrame.origin.y += _HeadersView.frame.size.height;
    CollectionFrame.origin.y += 300;
    //_CollectionView.frame = CollectionFrame;
    CGPoint Offset = CGPointMake(0, 60);
    [_CollectionView setContentOffset:Offset];
    */
    
    [self.CollectionView reloadData];

    //NSMutableArray* ChildrenSections = [SectionManager FilterChildrenByType:CurrentSection FilterClass:[Section class]];
    //if ([ChildrenSections count] == 0) [self.CollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    //else [self.CollectionView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [ChildrenSections count])]];
    
}


- (void) PostUpdateView
{
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
   // NSString *searchTerm = self.searches[section];
    //return [self.searchResults[searchTerm] count];
   if (section == TotalSectionsCount)
    {
            Section* CurrentSection = [[IMSectionManager SharedInstance] GetActiveSection];
            if (CurrentSection)
                {
                        NSMutableArray* Products = [[IMSectionManager SharedInstance] FilterChildrenByType:CurrentSection FilterClass:[IMProduct class]];
                        return [Products count];
                }
    }
    return 0;
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    //return [self.searches count];
    Section* CurrentSection = [SectionManager GetActiveSection];
    
    // Sections count

        //return 1;
    int SectionsCount = [SectionManager GetItemCountInSection:CurrentSection FilterClass:[Section class]] ;
    TotalSectionsCount = SectionsCount;
    if (SectionsCount == 0)
    {
        return 1;
    }
    return SectionsCount + 1;

}

// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IMProductGridCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"GridCell" forIndexPath:indexPath];
    //cell.backgroundColor = [UIColor whiteColor];
    NSUInteger i = indexPath.section;
    Section* CurrentSection = [[IMSectionManager SharedInstance] GetActiveSection];
    if (CurrentSection)
    {
        NSMutableArray* Products = [[IMSectionManager SharedInstance] FilterChildrenByType:CurrentSection FilterClass:[IMProduct class]];
        IMProduct* CurrentProduct = Products[indexPath.row];
    
        NSURL *URL = [NSURL URLWithString:CurrentProduct.ImageURL];
        cell.ImageView.showActivityIndicator = YES;
        cell.ImageView.activityIndicatorStyle = UIActivityIndicatorViewStyleGray;
        cell.ImageView.imageURL = URL;
        cell.Name.text = [CurrentProduct GetName];
        
        NSMutableString* PriceStringAppended = [@"Цена: " mutableCopy];
        [PriceStringAppended appendString: [CurrentProduct.ProductPrice mutableCopy]];
        [PriceStringAppended appendString:@" Р."];
//        cell.Price.text = CurrentProduct.ProductPrice;
        cell.Price.text = PriceStringAppended;
        
        IMAppDelegate* Appdelegate = (IMAppDelegate*) [[UIApplication sharedApplication] delegate];
        cell.StepperView.tintColor = Appdelegate.MainAppColor;
        
        if (![CurrentProduct.Status isEqualToString:@"0"])
        {
            [cell.StatusView setHidden:NO];
            cell.StatusTextView.text = CurrentProduct.Status;
            [cell.StatusView.superview.layer setCornerRadius:8.0f];


            
        }
        
        NSMutableString* Options = [NSMutableString string];
        if (CurrentProduct.OptionName != nil) [Options appendString:CurrentProduct.OptionName];
        [Options appendString:@": "];
        if (CurrentProduct.Weight != nil) [Options appendString:CurrentProduct.Weight];
        [Options appendString:@" "];
        if (CurrentProduct.OptionUnit != nil) [Options appendString:CurrentProduct.OptionUnit];
        cell.Weight.text = Options;
        
        
        cell.Quantity.textColor = Appdelegate.MainAppColor;
        
        IMProduct* CheckedProduct = [CartManager GetItemById:[CurrentProduct GetId]];
        if (CheckedProduct)
        {
            
            UIView *stepperview = cell.StepperView;

            
            IMStepper *stepper = (IMStepper *)stepperview;
            int valI = CheckedProduct.Quantity;
            double value = (double)valI;
            stepper.value = value;
            cell.Quantity.text = [NSString stringWithFormat: @"%d", CheckedProduct.Quantity];
            [self UpdateStepperValue:stepper];
            
        }
        else
        {
            cell.Quantity.text = @"0";
        }

        
        
    }
    
    
    //NSURL *URL = [NSURL URLWithString:@"http://test.inuwa.ru/img/photo/9whbkua6dwyuvqt9.jpg"];
    //cell.ImageView.imageURL = URL;
    return cell;
}


// 4
- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
     
     UICollectionReusableView *reusableview = nil;
     
     if (kind == UICollectionElementKindSectionHeader)
     {
         
         IMHeaderViewCell *HeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderCell" forIndexPath:indexPath];
         
         Section* CurrentSection = [SectionManager GetActiveSection];
         NSMutableArray* ChildrenSections = [SectionManager FilterChildrenByType:CurrentSection FilterClass:[Section class]];
         //if ([ChildrenSections count] == 0) return HeaderView;
         if (CurrentSection)
         {
             //Section* SectionsInThisRow = ChildrenSections[indexPath.row];
             
             // If Active Section haven't any Section children, we just hide it's view and desable any interaction.
             if ([ChildrenSections count] == 0)
             {
                // CGSize Size = CGSizeMake(0, 0);
                 //CGRect Rect = HeaderView.frame;
                // Rect.size = Size;
                // [HeaderView setFrame:Rect];
                 //[HeaderView autoresizesSubviews];
                 HeaderView.hidden = YES;
                 HeaderView.userInteractionEnabled = NO;
             }
             
             // If Active section have Section children
             else
             {
                 // We have visible non-container row, setting it's name and assosiate it with actual Section object from Data Model.
                 // Also, we are working with indexPath.sections instead of indexPath.rows because we deal sith Sections.
                 int i = indexPath.section;
                 if (i < [ChildrenSections count])
                 {
                     Section* ChildrenSection = ChildrenSections[indexPath.section];
                     HeaderView.HeaderSection = ChildrenSection;
                     HeaderView.Label.text = [ChildrenSection GetName];
                     IMAppDelegate* AppDelegate = [[UIApplication sharedApplication] delegate];
                     HeaderView.Label.textColor = AppDelegate.MainAppColor;
                 }
                 // Wea are working with last container row, we don't want to do anything with it, no interaction. Just contain
                 // grid elements and stay hidden
                 else
                 {
                     HeaderView.hidden = YES;
                     HeaderView.userInteractionEnabled = NO;
                     return HeaderView;
                 }
                 
             }
         }
         
         // add gesture recognition for tapping on a UIlabel within the header (UICollectionView supplementary view)
         UITapGestureRecognizer *bioTap = [[UITapGestureRecognizer alloc] initWithTarget:HeaderView action:@selector(OnHeaderPress)];
         // make your gesture recognizer priority
         bioTap.delaysTouchesBegan = YES;
         bioTap.numberOfTapsRequired = 1;
         [HeaderView addGestureRecognizer:bioTap];
         
         
         return HeaderView;
     }
     
     return [[UICollectionReusableView alloc] init];
 }



#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    Section* CurrentSection = [[IMSectionManager SharedInstance] GetActiveSection];
    NSMutableArray* Products = [[IMSectionManager SharedInstance] FilterChildrenByType:CurrentSection FilterClass:[IMProduct class]];
    IMProduct* CurrentProduct = Products[indexPath.row];
    [self.PopoverViewController SetDetails:CurrentProduct];
    
    // create and present popover
    UIPopoverController *aPopoverController = [[UIPopoverController alloc] initWithContentViewController:self.PopoverViewController];
     self.ThePopoverController = aPopoverController;

    self.PopoverViewController.UpdateViewDelegate = self;
    
    
    
     //self.ThePopoverController.delegate = self;
     //self.ThePopoverController.popoverContentSize = self.popoverViewController.view.bounds.size;
     
     // setup the frame in which the popover can be presented slightly smaller its view frame
     //CGRect rect = gestureRecognizer.view.frame;
    CGRect rect = [collectionView layoutAttributesForItemAtIndexPath:indexPath].frame;
    //CGRect rect = CGRectMake(10, 10, 300, 300);
     CGRect finalRect = CGRectInset(rect, 80.0, 80.0);
     
    //self.PopoverViewController.SavedPopoverRect = finalRect;
     [self.ThePopoverController presentPopoverFromRect:finalRect
                                                inView:self.ContentView
                              permittedArrowDirections:UIPopoverArrowDirectionAny
                                              animated:YES];
    
    
    

    // TODO: Select Item
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Deselect item
}

#pragma mark – UICollectionViewDelegateFlowLayout

// 1
/*- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSString *searchTerm = self.searches[indexPath.section]; FlickrPhoto *photo =
   // self.searchResults[searchTerm][indexPath.row];
    // 2
    CGSize retval = CGSizeMake(100, 100);
    retval.height += 35; retval.width += 35; return retval;
}*/

// 3



- (void) RemoveLeftButton
{
    //[self.mm_drawerController closeDrawerAnimated:NO completion:nil];
    [self.navigationItem setLeftBarButtonItem:nil];
    
}


- (void)SetupLeftMenuButton
{
    [self.mm_drawerController setDrawerVisualStateBlock:[MMDrawerVisualState slideAndScaleVisualStateBlock]];
    
    if ([[IMSectionManager SharedInstance] GetActiveSection])
    {
        Section* ActiveSection = [[IMSectionManager SharedInstance]GetActiveSection];
       // if ([ActiveSection GetItemIndex] == 0)
       // {
            MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
            [self.navigationItem setLeftBarButtonItem:leftDrawerButton];
            
       // }
    }
    else
    {
        MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
        [self.navigationItem setLeftBarButtonItem:leftDrawerButton];
        
    }
    //[self.mm_drawerController setCenterHiddenInteractionMode:(MMDrawerOpenCenterInteractionModeNavigationBarOnly)];
    
    self.mm_drawerController.centerHiddenInteractionMode = MMDrawerOpenCenterInteractionModeNone;
    [self.mm_drawerController setMaximumLeftDrawerWidth:400];
    
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


#pragma mark - Table View Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //NSMutableArray* SectionsInCurrentIndex = [[IMSectionManager SharedInstance] FilterSectionsByIndex:0];
    //Section *Section = SectionsInCurrentIndex[indexPath.row];
    cell.textLabel.text = @"TEST";
    return cell;
}


@end
