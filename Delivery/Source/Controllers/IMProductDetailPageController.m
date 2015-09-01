//
//  IMProductDetailPageController.m
//  Delivery
//
//  Created by Peter on 16/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMProductDetailPageController.h"
#import "IMProductManager.h"
#import "IMSectionManager.h"
#import "IMCartManager.h"

@implementation IMProductDetailPageController

@synthesize ProductLabel;
@synthesize ProductDescriptionLabel;
@synthesize ProductImage;
@synthesize DetailItem;
@synthesize QuantityLabel;
@synthesize Stepper;
@synthesize AppDelegate;
@synthesize PriceView;

-(void) viewWillDisappear:(BOOL)animated
{
    [ParentDelegate UpdateView];
}

- (void) SetDetailItem:(id)DetailItem ParentDelegate:(id<UpdateControllerView>)Delegate
{
    ParentDelegate = Delegate;
    if ([DetailItem isKindOfClass:[IMProduct class]])
    {
        CurrentProduct = (IMProduct*) DetailItem;

        // Update the view.
        //[self ConfigureView];
    }

}

- (void) CreateCartButton
{
     BonusCartButton = [[UIBarButtonItem alloc]
                                   initWithTitle:[CartManager GetMoneyInCartString]
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(OnCartTransition)];
    self.navigationItem.rightBarButtonItem = BonusCartButton;
}
- (void) RemoveCartButton
{
    
    self.navigationItem.rightBarButtonItem = NULL;
}

- (IBAction) OnCartTransition
{
    UIViewController* centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Cart"];
    IMCartViewController* Cart = centerViewController.childViewControllers[0];
    Cart.delegate = self;
    
    // present
    [self presentViewController:centerViewController animated:YES completion:nil];
}



- (void)configureView
{
    _Parent.PageUpdateDelegate = self;
    AppDelegate = [[UIApplication sharedApplication] delegate];
    
    CurrentProduct = DetailItem;
    
    // Update the user interface for the detail item.
    
    ProductLabel.text = [CurrentProduct GetName];
    ProductDescriptionLabel.text = CurrentProduct.Description;
    
    
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:self.ProductImage];
    ProductImage.imageURL = [NSURL URLWithString:CurrentProduct.ImageURL];
    //PriceLabel.text = PriceText;
    
    
    [self UpdateStepperValue];
    
}

- (void)viewDidLoad
{
        self.automaticallyAdjustsScrollViewInsets = NO;
    [super viewDidLoad];
    
    
   	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    //self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.barTintColor = AppDelegate.MainAppColor;
    
    //[PriceView.layer setCornerRadius:4.0f];
    
    
    // border
    [PriceView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [PriceView.layer setBorderWidth:0.5f];
    [self UpdateView];
    
}

- (void) UpdateStepperValue
{
    QuantityLabel.text = [NSString stringWithFormat: @"%d", CurrentProduct.Quantity];
    int valI = CurrentProduct.Quantity;
    double value = (double)valI;
    Stepper.value = value;

    NSString *Money = [NSString stringWithFormat: @"%d", [[IMCartManager SharedInstance ] GetMoneyInCart]];
    NSMutableString *CartSummary = [NSMutableString stringWithFormat:Money];
    [CartSummary appendString: @" P."];
    _Summary.titleLabel.text = CartSummary;

}

- (IBAction)StepperUse:(IMStepper *)sender
{
    if (sender.plusMinusState == JLTStepperPlus)
    {
        if ([[IMCartManager SharedInstance] GetItemById:[CurrentProduct GetId]] == NULL)
        {
            [[IMCartManager SharedInstance] AddItem:CurrentProduct];
        }
        double valueD = (double)Stepper.value;
        int valI = (int)valueD;
        CurrentProduct.Quantity = valI;
        
    }
    else if (sender.plusMinusState == JLTStepperMinus)
    {
        double valueD = (double)sender.value;
        int valI = (int)valueD;
        CurrentProduct.Quantity = valI;
        if (CurrentProduct.Quantity <= 0) [[IMCartManager SharedInstance] RemoveItem:CurrentProduct];
        
    }
    [self UpdateStepperValue];
    [self UpdateView];
    [_delegate UpdateView];
}

- (void) UpdateView
{
    ProductLabel.text = [CurrentProduct GetName];
    ProductDescriptionLabel.text = CurrentProduct.Description;
    if (BonusCartButton)
    {
        BonusCartButton.title = [CartManager GetMoneyInCartString];
        if ([CartManager IsEmpty])
            {
                //[BonusCartButton setEnabled:NO];
                [self RemoveCartButton];

            }
        else [self CreateCartButton];
    }
    
    [self UpdateStepperValue];
}



@end
