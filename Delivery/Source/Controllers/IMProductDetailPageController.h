//
//  IMProductDetailPageController.h
//  Delivery
//
//  Created by Peter on 16/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageItemController.h"
#import "IMProductViewController.h"
#import "IMFormViewController.h"
#import "IMProductsViewPagerController.h"
#import "IMAppDelegate.h"
#import "Protocols.h"

@interface IMProductDetailPageController : PageItemController <UpdateControllerView, DetailView>
{
    IMProduct* CurrentProduct;
    UIBarButtonItem *BonusCartButton;
    id<UpdateControllerView> ParentDelegate;
}
@property (strong, nonatomic) id DetailItem;

@property IMAppDelegate* AppDelegate;

@property (nonatomic, strong) IBOutlet UILabel *ProductLabel;
@property (nonatomic, strong) IBOutlet UILabel *QuantityLabel;
@property (nonatomic, strong) IBOutlet UILabel *ProductDescriptionLabel;
@property (nonatomic, strong) IBOutlet AsyncImageView *ProductImage;

@property (nonatomic, strong) IBOutlet UIView *PriceView;
@property (nonatomic, strong) IBOutlet UILabel *PriceLabel;

@property (nonatomic, strong) IBOutlet IMStepper *Stepper;
@property (nonatomic, strong) IBOutlet UIButton *Summary;

@property (nonatomic, weak) id <UpdateControllerView> delegate;

@property IBOutlet UIScrollView* ScrollView;

@property ViewController* Parent;

- (void) CreateCartButton;

@end
