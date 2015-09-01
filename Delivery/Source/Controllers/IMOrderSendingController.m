//
//  IMOrderSendingController.m
//  Delivery
//
//  Created by Peter on 23/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMOrderSendingController.h"
#import "IMOperationSendOrder.h"
#import "IMFormViewController.h"
#import "IMCartManager.h"

@implementation IMOrderSendingController


- (void) viewDidLoad
{
    IMAppDelegate* AppDelegate = (IMAppDelegate*)[[UIApplication sharedApplication] delegate];
    [_ProgressView setProgressTintColor:AppDelegate.MainAppColor];
    if (_bOrderOnly) [self SendOrder];
    else
    [self PayOrder];
}

- (void) TransitionHome
{
    UIViewController* StartController = [self.storyboard instantiateViewControllerWithIdentifier:@"StartController"];
    
    NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
    // to store
    [Defaults setObject:[CartManager GetUserData].UserPhoneNumber forKey:@"UserPhoneNumber"];
    [Defaults synchronize];
    // present
    [self presentViewController:StartController animated:YES completion:nil];
}

- (void) PayOrder
{
    [self UpdateProgress:0.1f];
    [_PaymentSystemDelegate CommitPurchase:self];
}

- (void) SendOrder
{
    if (OrderQueue) [OrderQueue cancelAllOperations];
    OrderQueue = [NSOperationQueue new];
    IMOperationSendOrder *OrderOperation = [[IMOperationSendOrder new] initWithData:[CartManager GetUserData]];
    OrderOperation.ProgressUpdateDelegate = self;
    [OrderQueue addOperation:OrderOperation];
}

#pragma mark - Payment System Delegate Methods

- (void) PaymentSuccess
{
    [self UpdateProgress:0.3f];
    [self SendOrder];
}

- (void) PaymentFail:(NSString *)Reason
{
    if (OrderQueue) [OrderQueue cancelAllOperations];
    Alert = [[UIAlertView new] initWithTitle:@"Ошибка оплаты" message:Reason delegate:self cancelButtonTitle:@"Назад" otherButtonTitles:@"Попробовать снова", nil];
    Alert.tag=0;
    [Alert show];
}

#pragma mark - Server Order Upload Delegate Methods


- (void) FinishLoading
{
  
    // HERE
    [self TransitionHome];
    Alert = [[UIAlertView new] initWithTitle:@"Спасибо за покупку" message:@"Наш менеджер свяжется с Вами в ближайшее время." delegate:nil cancelButtonTitle:@"Продолжить" otherButtonTitles:nil, nil];
    [Alert show];
    


}


- (void) FailedLoading
{
    if (OrderQueue) [OrderQueue cancelAllOperations];
    UIAlertView *Alert = [[UIAlertView new] initWithTitle:@"Ошибка" message:@"При подключении произошла ошибка" delegate:self cancelButtonTitle:@"Назад" otherButtonTitles:@"Попробовать снова", nil];
    Alert.tag=1;
    [Alert show];

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Payment fail
    if (alertView.tag == 0)
    {
        if (buttonIndex == 1)
            {
                [self PayOrder];
        
            }
        else
            {
                [self TransitionHome];
            }
    }
    
    // Upload fail
    else if (alertView.tag == 0)
    {
        if (buttonIndex == 1)
        {
            [self SendOrder];
            
        }
        else
        {
            [self TransitionHome];
        }
    }
}

- (void) UpdateProgress:(float)ProgressPercent
{
    NSLog(@"UpdateProgress: %f", ProgressPercent);
    [_ProgressView setProgress:ProgressPercent animated:YES];
}

@end
