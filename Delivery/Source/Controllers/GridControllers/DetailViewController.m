//
//  DetailViewController.m
//  Delivery
//
//  Created by Peter on 16/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "DetailViewController.h"
#import "IMProduct.h"
#import "IMSectionManager.h"
#import "IMProductManager.h"
#import "IMCartManager.h"
#import "IMAppDelegate.h"

@implementation DetailViewController

IMAppDelegate* AppDelegate;

- (void) viewDidLoad
{
    [super viewDidLoad];
    AppDelegate = (IMAppDelegate*) [[UIApplication sharedApplication]delegate];
    
}

- (IBAction)OnClose:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Dissmissed");
    }];
}

- (void) SetDetails:(IMProduct*)DetailItem
{
  
    Product = DetailItem;
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:self.ProductImage];
    
    
    // Setting values

    _ProductImage.showActivityIndicator = YES;
    _ProductImage.activityIndicatorStyle = UIActivityIndicatorViewStyleGray;
    _ProductImage.imageURL = [NSURL URLWithString:DetailItem.ImageURL];
    _ProductLabel.text = [DetailItem GetName];
    _ProductDescriptionLabel.text = DetailItem.Description;
    [_ProductDescriptionLabel sizeToFit];
    _QuantityLabel.text = [NSString stringWithFormat: @"%d", DetailItem.Quantity];
    
    
  
    NSMutableString* ProductPriceStringAppended = [@"Цена: " mutableCopy];
    [ProductPriceStringAppended appendString: [DetailItem.ProductPrice mutableCopy]];
    [ProductPriceStringAppended appendString:@" Р."];
    _ProductPrice.text = ProductPriceStringAppended;

    
    int valI = Product.Quantity;
    double value = (double)valI;
    [_Stepper setValue:value];
    

    NSMutableString* Options = [NSMutableString string];
    [Options appendString:DetailItem.OptionName];
    [Options appendString:@": "];
    [Options appendString:DetailItem.Weight];
    [Options appendString:@" "];
    [Options appendString:DetailItem.OptionUnit];
    _Option.text = Options;
}

- (IBAction)StepperUse:(IMStepper *)sender
{
    int valI;
    NSLog(@"Stepper Use");
    if (sender.plusMinusState == JLTStepperPlus)
    {
        if ([[IMCartManager SharedInstance] GetItemById:[Product GetId]] == NULL)
        {
            [[IMCartManager SharedInstance] AddItem:Product];
        }
        double valueD = (double)_Stepper.value;
        valI = (int)valueD;
        Product.Quantity = valI;
        
    }
    else if (sender.plusMinusState == JLTStepperMinus)
    {
        double valueD = (double)sender.value;
        valI = (int)valueD;
        Product.Quantity = valI;
        if (Product.Quantity <= 0) [[IMCartManager SharedInstance] RemoveItem:Product];
        
    }
    [self UpdateStepperValue];
    [_UpdateViewDelegate SetStepperValue:Product ValueToSet:valI];
    //[_UpdateViewDelegate UpdateView];
}

- (void) UpdateStepperValue
{
    _QuantityLabel.text = [NSString stringWithFormat: @"%d", Product.Quantity];
    int valI = Product.Quantity;
    double value = (double)valI;
    _Stepper.value = value;
    
    NSString *Money = [NSString stringWithFormat: @"%d", [CartManager GetMoneyInCart]];
    NSMutableString *CartSummary = [NSMutableString stringWithFormat:Money];
    [CartSummary appendString: @" P."];
    //_Summary.titleLabel.text = CartSummary;
}



@end
