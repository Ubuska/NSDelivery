//
//  IMOrderSendingController.h
//  Delivery
//
//  Created by Peter on 23/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMUserData.h"
#import "Protocols.h"

@interface IMOrderSendingController : UIViewController <UpdateProgress,PaymentInstigator, UIAlertViewDelegate>
{
    NSOperationQueue *OrderQueue;
    UIAlertView *Alert;
}

@property id<PaymentSystem> PaymentSystemDelegate;
@property IMUserData* UserData;
@property IBOutlet UIProgressView* ProgressView;
@property BOOL bOrderOnly;

@end
