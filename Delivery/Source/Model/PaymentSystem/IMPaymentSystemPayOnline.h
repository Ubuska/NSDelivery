//
//  IMPaymentSystemPayOnline.h
//  Delivery
//
//  Created by Peter on 06/07/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PayOnlineDelegate.h"
#import "Protocols.h"
#import "PayOnlinePayRequest.h"

@interface IMPaymentSystemPayOnline : NSObject <PaymentSystem, PayOnlineDelegate>
{
    id<PaymentInstigator> PaymentInstigatorDelegate;
}
@property PayOnlinePayRequest* Request;

@end
