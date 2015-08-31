//
//  IMProductDetailController.m
//  Delivery
//
//  Created by Developer on 11.12.14.
//  Copyright (c) 2014 incodemobile. All rights reserved.
//

#import "IMProductDetailController.h"
#import "IMProduct.h"
#import "IMSectionManager.h"
#import "IMCartManager.h"

@implementation IMProductDetailController

IMAppDelegate *appDelegate;

@synthesize productLabel;
@synthesize productName;

@synthesize productDescriptionLabel;
@synthesize productDescription;

@synthesize productImage;
@synthesize PicURL;

@synthesize PriceLabel;
@synthesize PriceView;
@synthesize PriceText;

@synthesize Product;

@synthesize QuantityText;
@synthesize QuantityLabel;
@synthesize Stepper;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
        {
            // Custom initialization
        }
    return self;
}


- (IBAction)OnCartTransition:(UIButton *)sender
{
    UIViewController* centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Cart"];
    IMCartViewController* Cart = centerViewController.childViewControllers[0];
    Cart.delegate = self;
    
    // present
    [self presentViewController:centerViewController animated:YES completion:nil];
}

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem)
        {
            _detailItem = newDetailItem;
        
            // Update the view.
            [self configureView];
        }
}

- (void)configureView
{
    
    appDelegate = (IMAppDelegate*)[[UIApplication sharedApplication] delegate];
    // Update the user interface for the detail item.
    
    productLabel.text = productName;
    productDescriptionLabel.text = productDescription;
    
    
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:self.productImage];
    productImage.showActivityIndicator = YES;
    productImage.activityIndicatorStyle = UIActivityIndicatorViewStyleGray;
    productImage.imageURL = [NSURL URLWithString:PicURL];
    PriceLabel.text = PriceText;

    [self UpdateStepperValue];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self UpdateView];
    //self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.barTintColor = appDelegate.MainAppColor;
    
    [PriceView.layer setCornerRadius:4.0f];
    
      
    // border
    //[PriceView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    //[PriceView.layer setBorderWidth:0.5f];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)StepperUse:(IMStepper *)sender
{
    NSLog(@"Stepper Use");
    if (sender.plusMinusState == JLTStepperPlus)
    {
        if ([[IMCartManager SharedInstance] GetItemById:[Product GetId]] == NULL)
        {
            [[IMCartManager SharedInstance] AddItem:Product];
        }
        double valueD = (double)Stepper.value;
        int valI = (int)valueD;
        Product.Quantity = valI;
        
    }
    else if (sender.plusMinusState == JLTStepperMinus)
    {
        double valueD = (double)sender.value;
        int valI = (int)valueD;
        Product.Quantity = valI;
        if (Product.Quantity <= 0) [[IMCartManager SharedInstance] RemoveItem:Product];
        
    }
    [self UpdateStepperValue];
}


// Delegate method
- (void) UpdateView
{
    
    [self configureView];
}


/*
- (void)RemoveProduct:(IMStepper*)sender
{
    UIView *currentview = sender.superview.superview;
    
    for(UIView *view in currentview.subviews)
    {
        if ([view isKindOfClass:[UIView class]] && view.tag == 128)
        {
            if (sender.value < 1)
                [self AnimationFadeOut:view];
        }
    }
    
}
*/
- (void) UpdateStepperValue
{
    QuantityLabel.text = [NSString stringWithFormat: @"%d", Product.Quantity];
    int valI = Product.Quantity;
    double value = (double)valI;
    Stepper.value = value;
    
    int TempSum = 0;
    NSLog(@"UpdateStepperValue");

    NSString *Money = [NSString stringWithFormat: @"%d", [CartManager GetMoneyInCart]];
    NSMutableString *CartSummary = [NSMutableString stringWithFormat:Money];
    [CartSummary appendString: @" P."];
    _Summary.titleLabel.text = CartSummary;
}

-(void) viewWillDisappear:(BOOL)animated
{
    //This is called when the user has clicked on the back button in the navigation bar.

    NSLog(@"Segue");
    [self.MasterViewDelegate UpdateView];
}

@end
