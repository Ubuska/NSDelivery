//
//  IMRestarauntDetailController.m
//  Delivery
//
//  Created by Developer on 22.12.14.
//  Copyright (c) 2014 incodemobile. All rights reserved.
//

#import "IMAddressDetailController.h"
#import "IMCartManager.h"

@interface IMAddressDetailController ()

@end

@implementation IMAddressDetailController

@synthesize RestarauntLabel;
@synthesize RestarauntDescriptionLabel;
@synthesize RestarauntCityLabel;
@synthesize RestarauntAdressLabel;
@synthesize RestarauntPhoneButton;
@synthesize scroller;

- (void) SetDetailItem:(id)DetailItem ParentDelegate:(id<UpdateControllerView>)Delegate
{
    ParentViewDelegate = Delegate;
    if ([DetailItem isKindOfClass:[IMAddress class]])
    {
        AddressDetailItem = (IMAddress*) DetailItem;
        
        // Update the view.
        [self ConfigureView];
    }
}

// Delegate method
- (void) UpdateView
{
    [self ConfigureView];
    [_ButtonCart setTitle:[CartManager GetMoneyInCartString] forState:UIControlStateNormal];
    if ([CartManager IsEmpty]) [self.ButtonCart setEnabled:NO];
    else [self.ButtonCart setEnabled:YES];
}

- (IBAction)OnCartTransition:(UIButton *)sender
{
    UIViewController* centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Cart"];
    IMCartViewController* Cart = centerViewController.childViewControllers[0];
    Cart.delegate = self;
    
    // present
    [self presentViewController:centerViewController animated:YES completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [_ButtonCart setTitle:[CartManager GetMoneyInCartString] forState:UIControlStateNormal];
    [super viewDidLoad];
    if (scroller != nil)
    {
        [scroller setScrollEnabled:YES];
        [scroller setContentSize:(CGSizeMake(320, 624))];
    }
    [self UpdateView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)ConfigureView
{
    // Update the user interface for the detail item.
    NSLog(@"CconfigureView");
    RestarauntLabel.text = [AddressDetailItem GetName];
    RestarauntDescriptionLabel.text = AddressDetailItem.Description;

    NSString *buttonTitle = [AddressDetailItem GetPhone];
    [RestarauntPhoneButton setTitle:(buttonTitle) forState:UIControlStateNormal];
    
    RestarauntDescriptionLabel.numberOfLines = 0;
    [RestarauntDescriptionLabel sizeToFit];
    
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:_RestarauntImage];
    //[[AsyncImageLoader sharedLoader] loadImageWithURL:Product.picurl];
    //load the image
    
    _RestarauntImage.showActivityIndicator = YES;
    _RestarauntImage.activityIndicatorStyle = UIActivityIndicatorViewStyleGray;
    _RestarauntImage.imageURL = [NSURL URLWithString:AddressDetailItem.ImageURL];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController)
    {
        [ParentViewDelegate UpdateView];
    }
}

- (IBAction) PhoneCall:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://8005551212"]];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
