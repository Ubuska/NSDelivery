//
//  IMDrawerController.h
//  Delivery
//
//  Created by Developer on 11.12.14.
//  Copyright (c) 2014 incodemobile. All rights reserved.
//

#import "MMDrawerController.h"
#import "IMProductViewController.h"
#import "Protocols.h"

@interface IMDrawerController : MMDrawerController <NotificationRespondHandler>
{
    int SelectedRow;
}

- (void) SetSelectedRow:(int)Index;

@end
