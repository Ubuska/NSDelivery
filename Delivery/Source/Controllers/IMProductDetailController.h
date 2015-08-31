//
//  IMProductDetailController.h
//  Delivery
//
//  Created by Developer on 11.12.14.
//  Copyright (c) 2014 incodemobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMProductViewController.h"
#import "IMFormViewController.h"
#import "Protocols.h"
#import "IMProductsViewPagerController.h"

@interface IMProductDetailController : UIPageViewController <UpdateControllerView, UIScrollViewDelegate>

@property (nonatomic) NSUInteger itemIndex;
@property (strong, nonatomic) id detailItem;

@property (nonatomic, strong) IBOutlet UILabel *productLabel;
@property (nonatomic, strong) NSString *productName;

@property (nonatomic, strong) IBOutlet UILabel *productDescriptionLabel;
@property (nonatomic, strong) NSString *productDescription;

@property (nonatomic, strong) IBOutlet AsyncImageView *productImage;
@property (nonatomic, strong) NSString *PicURL;

@property (nonatomic, strong) IBOutlet UIView *PriceView;
@property (nonatomic, strong) IBOutlet UILabel *PriceLabel;
@property (nonatomic, strong) NSString *PriceText;


@property (nonatomic, strong) NSString *QuantityText;
@property (nonatomic, strong) IBOutlet UILabel *QuantityLabel;

@property (nonatomic, strong) IBOutlet IMProduct *Product;
@property (nonatomic, strong) IBOutlet IMStepper *Stepper;
@property (nonatomic, strong) IBOutlet UIButton *Summary;

@property (nonatomic, retain) id <UpdateControllerView> MasterViewDelegate;





@end
