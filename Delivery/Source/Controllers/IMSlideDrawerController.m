//
//  IMSlideDrawerController.m
//  Delivery
//
//  Created by Developer on 12.12.14.
//  Copyright (c) 2014 incodemobile. All rights reserved.
//

#import "IMSlideDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "IMSectionViewCell.h"

#import "Section.h"
#import "IMEventManager.h"
#import "IMSectionManager.h"
#import "IMAddressManager.h"

#import "IMDrawerController.h"

@interface IMSlideDrawerController ()



@end

@implementation IMSlideDrawerController

IMAppDelegate *appDelegate;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {

        appDelegate = [[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    IMAppDelegate *IMAppDelegate = [[UIApplication sharedApplication] delegate];
    //_Sections = IMAppDelegate.Sections;
    CurrentIndex = 0;
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //self.mm_drawerController.centerHiddenInteractionMode = MMDrawerOpenCenterInteractionModeNone;
    //self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return [SectionManager GetItemsCount];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

/*
    if (CurrentIndex == indexPath.row)
    {
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
        return;
    }
*/
    
    IMDrawerController* IMDC = (IMDrawerController*) self.mm_drawerController;
    [IMDC SetSelectedRow:indexPath.row];
    
    NSMutableArray* Sections = [NSMutableArray arrayWithCapacity:0];
    Sections = [SectionManager FilterSectionsByIndex:0];
    Section* ActiveSection = [SectionManager GetActiveSection];
    Section* NewActiveSection = Sections[indexPath.row];
    
    if (ActiveSection == NewActiveSection)
    {
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
        return;
    }
    
    [SectionManager SetActiveSection:NewActiveSection];
    
    UIViewController *centerViewController;
    //self.mm_drawerController.forceUpdateDelegate = centerViewController;
    //appDelegate.SelectedSection = indexPath.row;
    /*
        // Events
        if (indexPath.row == 0)
        {
            centerViewController = (UITableViewController*) centerViewController;
            centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FOURTH_TOP_VIEW_CONTROLLER"];    
        }
    
        // Restaraunts
        else if (indexPath.row == 1)
        {
            centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"THIRD_TOP_VIEW_CONTROLLER"];
            centerViewController = (UITableViewController*) centerViewController;
            
        }
    
        // Delivery Conditions
        else if(indexPath.row == 2)
        {
            centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SECOND_TOP_VIEW_CONTROLLER"];
            //[centerViewController showData];
                //centerViewController.ScrollToThisRow = indexPath.row;
            
        }
    
        // Products
        else
        {
            NSLog(@"FIRST_TOP_VIEW_CONTROLLER");
            centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FIRST_TOP_VIEW_CONTROLLER"];
        }
    
    */
   /* if ([NewActiveSection GetSectionManagerHandler] == [ActiveSection GetSectionManagerHandler] || !ActiveSection)
    {
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
        return;
    }*/
    IMAppDelegate* AppDelegate = [[UIApplication sharedApplication] delegate];
    
    centerViewController = [AppDelegate GetDestinationViewController:NewActiveSection Storyboard:self.storyboard];
    
    if (centerViewController)
    {
       // appDelegate.bIsScrollingAllowed = YES;
        CurrentIndex = indexPath.row;
        //[self.mm_drawerController setCenterViewController:centerViewController];
        //
        [self.mm_drawerController setCenterViewController:centerViewController withCloseAnimation:YES completion:nil];
        //[self.mm_drawerController setCenterViewController:centerViewController];
        //[self.mm_drawerController closeDrawerAnimated:YES completion:nil];
                        // Animate to certain row
        //[centerViewController ScrollTo
    }
    
}

- (int) GetIndex
{
    return CurrentIndex;
}

- (IMSectionViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DrawerSectionCell";
    IMSectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    // Configure the cell...
    if (cell != nil)
    {
        NSMutableArray* SectionsInCurrentIndex = [[IMSectionManager SharedInstance] FilterSectionsByIndex:0];
        Section *Section = SectionsInCurrentIndex[indexPath.row];
       // Section *Section = [[IMSectionManager SharedInstance]GetItemByIndex:indexPath.row];
        cell.SectionName.text = [Section GetName];
        //cell.SectionName.text = Section.name;
    }
    
    return cell;
}


@end
