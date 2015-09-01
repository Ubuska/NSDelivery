//
//  IMBonusDetailsViewController.m
//  Delivery
//
//  Created by Peter on 09/07/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMBonusDetailsViewController.h"
#import "IMCartViewController.h"
#import "IMCartManager.h"
#import "IMProductManager.h"
#import "IMProductDetailPageController.h"
#import "ViewController.h"
#import "IMAppDelegate.h"

@implementation IMBonusDetailsViewController

IMAppDelegate* AppDelegate;

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self ConfigureView];
}

- (void) ConfigureView
{
    AppDelegate = (IMAppDelegate*) [[UIApplication sharedApplication] delegate] ;
    if ([CartManager IsEmpty]) [self.ButtonCart setEnabled:NO];
    else [self.ButtonCart setEnabled:YES];
    [_ButtonCart setTitle:[CartManager GetMoneyInCartString] forState:UIControlStateNormal];
    _BonusName.text = [Bonus GetName];
    _BonusDescription.text = Bonus.Description;
    _BonusImage.imageURL = [NSURL URLWithString:Bonus.ImageURL];

    IMProduct* BonusProduct = [ProductManager GetItemById:[Bonus GetProductId]];

    
    [_ButtonProductLink setTitle:[BonusProduct GetName] forState:UIControlStateNormal];
    
    NSUInteger BonusQuantity = [Bonus GetQuantity];
    float Quantity = [Bonus GetQuantity];
    
    if ([CartManager GetBonusById:[Bonus GetId]])
    {
        Quantity -= [Bonus GetSum];
        BonusQuantity -= [Bonus GetSum];
        _ButtonSendBonus.enabled = NO;
        _BonusAdviceText.text = @"Бонус уже есть в корзине";
        
    }
    else
    {
        _BonusAdviceText.text = @"Продукт для получения бонуса";
        if ([Bonus GetQuantity] >= [Bonus GetSum])
        {
            _ButtonSendBonus.enabled = YES;
        }
        else
        {
            _ButtonSendBonus.enabled = NO;
        }
        
    }

    
    
    
    
    
    
    float Sum = [Bonus GetSum];
    float BonusProgress =  Quantity / Sum;
    [_BonusProgressView setProgress:BonusProgress animated:YES];
    
    
    NSMutableString *BonusStatus = [NSMutableString stringWithFormat:@"%lu", (unsigned long)BonusQuantity];
    [BonusStatus appendString: @"/"];
    [BonusStatus appendString: [NSMutableString stringWithFormat:@"%lu", (unsigned long)[Bonus GetSum]]];
    
    _BonusProgressText.text = BonusStatus;
    
    // Coloring elements
    _BonusProgressText.textColor = AppDelegate.MainAppColor;
    _BonusProgressView.tintColor = AppDelegate.MainAppColor;
    
    if (BonusProduct)[_ButtonProductLink setTitleColor:AppDelegate.MainAppColor forState:UIControlStateNormal];
    else [_ButtonProductLink setEnabled:NO];
    
    [self SetAppColorTo:_ButtonSendBonus];
    [_ButtonSendBonus setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if ([Bonus GetQuantity] < [Bonus GetSum]) [_ButtonSendBonus setEnabled:NO];
   // [self SetAppColorTo:Cell.BonusButton];
    
}

- (IBAction)OnProductPress:(UIButton *)sender
{

    IMProductDetailPageController* TargetViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemController"];
    //[self performSegueWithIdentifier:@"DetailSegue" sender:self];
    //id <DetailView> TargetViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailSegue"];
    IMProduct* BonusProduct = [ProductManager GetItemById:[Bonus GetProductId]];
    [TargetViewController SetDetailItem:BonusProduct ParentDelegate:self];
    //TargetViewController.delegate = self;
   //[TargetViewController setDetailItem:BonusProduct];
    [self.navigationController pushViewController:TargetViewController animated:YES];
    [TargetViewController CreateCartButton];
    //[self presentViewController:TargetViewController animated:YES completion:nil];

}

- (IBAction)OnBonusSend:(UIButton *)sender
{
    
    // Instantitate and set the center view controller.
    IMCartViewController *CartViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Cart"];
    if (![CartManager GetBonusById:[Bonus GetId]])
    {
        [CartManager AddBonus:Bonus];
    }
    
    [self OnCartTransition:nil];
}

- (IBAction)OnCartTransition:(UIButton *)sender
{
    UIViewController* centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Cart"];
    IMCartViewController* Cart = centerViewController.childViewControllers[0];
    Cart.delegate = self;
    
    // present
    [self presentViewController:centerViewController animated:YES completion:nil];
}


#pragma mark Update Controller Delegate Methods

- (void) UpdateView
{

    [_ButtonCart setTitle:[CartManager GetMoneyInCartString] forState:UIControlStateNormal];
    if ([CartManager IsEmpty]) [self.ButtonCart setEnabled:NO];
    else [self.ButtonCart setEnabled:YES];

    [self ConfigureView];
}

#pragma mark Detail View Delegate Methods

- (void) SetDetailItem:(id)DetailItem ParentDelegate:(id<UpdateControllerView>)Delegate
{
    MasterViewDelegate = Delegate;
    
    if ([DetailItem isKindOfClass:[IMBonus class]])
    {
        Bonus = (IMBonus*) DetailItem;
        
        // Update the view.
        [self UpdateView];
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
    [MasterViewDelegate UpdateView];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DetailSegueFromBonus"])
    {
        IMProduct* BonusProduct = [ProductManager GetItemById:[Bonus GetProductId]];
        
        IMProductDetailPageController* DestViewController = segue.destinationViewController;
        DestViewController.delegate = self;
        //DetailController.MasterViewDelegate = self;
        //DestViewController.DetailItem = BonusProduct;
        [DestViewController SetDetailItem:BonusProduct ParentDelegate:self];
    }
    
    
    
}

- (void)SetAppColorTo:(UIButton*)Button
{
    UIView *ColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    ColorView.backgroundColor = AppDelegate.MainAppColor;
    
    UIGraphicsBeginImageContext(ColorView.bounds.size);
    [ColorView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *ColorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIControlState State = UIControlStateNormal;
    
    [Button setBackgroundImage:ColorImage forState:State];
}


@end
