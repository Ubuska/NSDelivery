//
//  IMSplitViewController.m
//  Delivery
//
//  Created by Peter on 18/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMSplitViewController.h"

// Managers
#import "IMSectionManager.h"
#import "IMProductManager.h"
#import "IMEventManager.h"

#import "IMTransitionsManager.h"
#import "GridController.h"
#import "IMAppDelegate.h"
#import "IMAppDelegate.h"

@implementation IMSplitViewController

@synthesize LeftView;
@synthesize RightView;

IMAppDelegate* AppDelegate;

- (void) MakeTransition:(UIViewController*) Controller
{
    
    
}
- (void) SetRightViewController:(UIViewController*)RightController
{
    RightViewController = RightController;
    //[TransitionsManager SetSplitController:self];
    //[TransitionsManager SetRightView:RightView];
    //[TransitionsManager MakeTransition:RightController];
}

- (void) UpdateView
{
    Section* CurrentActiveSection = [SectionManager GetActiveSection];
    NSMutableArray* Sections = [NSMutableArray arrayWithCapacity:0];
    Sections = [SectionManager FilterSectionsByIndex:0];
   // NSUInteger IndexOfSection = [[Sections indexOfObject:CurrentActiveSection];
   
    IMAppDelegate* AppDelegate = (IMAppDelegate*)[[UIApplication sharedApplication] delegate];
                                 
    UIViewController* TransitionController = [AppDelegate GetDestinationViewController:CurrentActiveSection Storyboard:self.storyboard];
    [TransitionsManager MakeTransition:TransitionController];
                                 
}

- (void) viewDidLoad
{
    AppDelegate = (IMAppDelegate*) [[UIApplication sharedApplication] delegate];
    [TransitionsManager SetSplitController:self];
    [TransitionsManager SetRightView:RightView];
    
    if (!RightViewController)
    {
        
        RightViewController = [self.storyboard instantiateViewControllerWithIdentifier: @"AboutUs"];
        
    }
    //GridController* Grid = (GridController*) RightViewController.childViewControllers[0];
    [TransitionsManager MakeTransition:RightViewController];
    /*if ([Grid isKindOfClass:[GridController class]])
    {
        
        Grid.SectionUpdateDelegate = self;
    
        
        [Grid UpdateView];
    }*/

    NSLog(@"landscape View Loaded");
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [SectionManager GetItemsCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SectionCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSMutableArray* SectionsInCurrentIndex = [[IMSectionManager SharedInstance] FilterSectionsByIndex:0];
    Section *Section = SectionsInCurrentIndex[indexPath.row];
    cell.textLabel.text = [Section GetName];
    return cell;
}

- (void) tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIView *ColorView = [[UIView alloc] init];
    ColorView.backgroundColor = AppDelegate.MainAppColor;
    UITableViewCell* Cell = [tableView cellForRowAtIndexPath:indexPath];
    [Cell setSelectedBackgroundView:ColorView];
   // [[UITableViewCell appearance]setSelectedBackgroundView:bgColorView];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIView *ColorView = [[UIView alloc] init];
    ColorView.backgroundColor = AppDelegate.MainAppColor;
    UITableViewCell* Cell = [tableView cellForRowAtIndexPath:indexPath];
    [Cell setSelectedBackgroundView:ColorView];
    
        Section* CurrentActiveSection = [SectionManager GetActiveSection];
        NSMutableArray* Sections = [NSMutableArray arrayWithCapacity:0];
        Sections = [SectionManager FilterSectionsByIndex:0];
        Section* NewActiveSection = Sections[indexPath.row];
        [SectionManager SetActiveSection:NewActiveSection];
    
        IMAppDelegate* AppDelegate = (IMAppDelegate*)[[UIApplication sharedApplication] delegate];
    
        UIViewController* TransitionController = [AppDelegate GetDestinationViewController:NewActiveSection Storyboard:self.storyboard];
        if ([[TransitionController class] isSubclassOfClass: [RightViewController class]])
            {
                [TransitionsManager MakeTransition:RightViewController];
            }
        else
            {
                [TransitionsManager MakeTransition:TransitionController];
            }
}







@end
