//
//  DetailViewController.h
//  Delivery
//
//  Created by Peter on 16/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "IMProduct.h"
#import "IMStepper.h"
#import "Protocols.h"

#define TILE_ROWS    4
#define TILE_COLUMNS 3
#define TILE_COUNT   (TILE_ROWS * TILE_COLUMNS)

#define TILE_WIDTH  225
#define TILE_HEIGHT 320
#define TILE_MARGIN 23

@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UpdateControllerView>
{
    
    IMProduct* Product;
    CGRect tileFrame[TILE_COUNT];

}

@property (nonatomic, strong) IBOutlet UILabel *ProductLabel;
@property (nonatomic, strong) IBOutlet UILabel *QuantityLabel;
@property (nonatomic, strong) IBOutlet UILabel *ProductDescriptionLabel;

@property (nonatomic, strong) IBOutlet UILabel *ProductPrice;
@property (nonatomic, strong) IBOutlet UILabel *Option;

@property (nonatomic, strong) IBOutlet AsyncImageView *ProductImage;
@property (nonatomic, strong) IBOutlet IMStepper *Stepper;

- (void) SetDetails:(IMProduct*)DetailItem;
@property (nonatomic, retain) id <UpdateControllerView> UpdateViewDelegate;

@end
