//
//  GridController.h
//  Delivery
//
//  Created by Peter on 16/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "Protocols.h"
#import "DetailViewController.h"
#import "IMStepper.h"
#import "IMFormViewController.h"

@interface GridController : UIViewController <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UpdateControllerView, UITableViewDelegate, UITableViewDataSource>
{
    int TotalSectionsCount;
}
@property id<UpdateControllerView> SectionUpdateDelegate;
@property(nonatomic, weak) IBOutlet UICollectionView *CollectionView;
@property UITableView *HeadersView;
@property (nonatomic, strong) IBOutlet UIButton* ButtonCart;
@property (nonatomic, strong) UIPopoverController *ThePopoverController;
@property (nonatomic, strong) DetailViewController *PopoverViewController;

@property (nonatomic, weak) IBOutlet UIView *ContentView;

- (void) HeaderPress:(Section*)HeaderSection;
- (IBAction)StepperUse:(IMStepper *)UsedStepper;
- (IBAction)OnCartTransition:(UIButton *)sender;

@end
