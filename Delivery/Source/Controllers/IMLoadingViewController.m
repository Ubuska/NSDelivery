//
//  IMLoadingViewController.m
//  Delivery
//
//  Created by Peter on 17/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMLoadingViewController.h"
#import "IMAppDelegate.h"

#import "IMProductParser.h"
#import "IMEventParser.h"
#import "IMAddressParser.h"
#import "IMBonusParser.h"
#import "IMInfoParser.h"
#import "IMAboutUsParser.h"

#import "IMProductManager.h"
#import "IMEventManager.h"
#import "IMAddressManager.h"
#import "IMBonusManager.h"
#import "IMOperationParse.h"
#import "IMSectionManager.h"
#import "IMInfoManager.h"
#import "IMAboutUsManager.h"
#import "IMDiscountManager.h"

#import "IMOperationRequestDiscount.h"


@implementation IMLoadingViewController
IMAppDelegate* AppDelegate;

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    AppDelegate = (IMAppDelegate*)[[UIApplication sharedApplication] delegate];
    [_ProgressBar setProgressTintColor:AppDelegate.MainAppColor];
    
    
    [self LoadData];
    //[self FinishLoading];
    //[Operations removeAllObjects];
   // [_Spinner startAnimating];
    
    
}

- (void) UpdateProgress:(float)ProgressPercent
{
    [_ProgressBar setProgress:ProgressPercent animated:YES];
    //ProgressBar.progress = actual + ((float)0.02/(float)OverallProgress);
    
    //ProgressBar.progress = 1.0f;
    //[_ProgressBar setProgress:ProgressPercent animated:YES];
    //ProgressBar.progress = ProgressPercent;
    //[ProgressBar setProgress:ProgressPercent animated:YES];
}

- (void) LoadData
{
    
    AppDelegate.ProgressUpdateDelegate = self;
    
    IMOperationRequestDiscount* DiscountOperation = [IMOperationRequestDiscount new];
    //[DiscountOperation Initialize:self];
    NSMutableArray* Operations = [NSMutableArray arrayWithCapacity:0];
    
    [Operations addObject:[AppDelegate CreateUpdateOperation:AboutUsManager Parser:[IMAboutUsParser new] URL:@"AboutUs"]];
    [Operations addObject:DiscountOperation];
    [Operations addObject:[AppDelegate CreateUpdateOperation:EventManager Parser:[IMEventParser new] URL:@"Events"]];
    [Operations addObject:[AppDelegate CreateUpdateOperation:AddressManager Parser:[IMAddressParser new] URL:@"Places"]];
    [Operations addObject:[AppDelegate CreateUpdateOperation:BonusManager Parser:[IMBonusParser new] URL:@"Bonuses"]];
    [Operations addObject:[AppDelegate CreateUpdateOperation:InfoManager Parser:[IMInfoParser new] URL:@"Info"]];
    [Operations addObject:[AppDelegate CreateUpdateOperation:ProductManager Parser:[IMProductParser new] URL:@"Products"]];
    
    [AppDelegate UpdateDataFromServer:[Operations copy]];
    

}

- (void) FinishLoading
{
    // MAYBE HERE
    //[ProgressBar setHidden:YES];
    //[Spinner stopAnimating];
    
    Section* AddedSection = [Section new];
    [AddedSection SetName:@"Настройки"];
    [AddedSection SetId:1111111];
    [SectionManager AddItem:AddedSection];
    
    NSMutableArray* ProductSections = [SectionManager FilterSectionsByHandler:[ProductManager class]];
    
    // Try to modify Product Prices with discount (if we have EDT_Card active)
    [ProductManager ModifyPricesWithDiscount];
    
    if (![AppDelegate IsRegularStartup]) return;
    
    /*
    if ([ProductSections count] > 0)
    {
        Section* ActiveSection;
        for (Section* CurrentSection in ProductSections)
        {
            if ([CurrentSection GetItemIndex] == 0)
            {
                ActiveSection = CurrentSection;
                break;
            }
        }
        
        if (ActiveSection)
        {
            [SectionManager SetActiveSection:ActiveSection];
        }
     */
    Section* ActiveSection = [SectionManager GetItemByIndex:0];
    [SectionManager SetActiveSection:ActiveSection];
        
        [self performSegueWithIdentifier:@"LoginMainSegue" sender:self];
   // }

}

- (void) FailedLoading
{
    [self LoadData];
}



@end
