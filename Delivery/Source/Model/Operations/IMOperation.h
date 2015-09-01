//
//  IMOperation.h
//  Delivery
//
//  Created by Peter on 10/08/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Protocols.h"

@interface IMOperation : NSOperation

@property id<OperationNotifyReceiver> NotificationsRecieverDelegate;

@end
