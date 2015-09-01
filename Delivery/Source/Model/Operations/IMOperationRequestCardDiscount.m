//
//  IMOperationRequestCardDiscount.m
//  Delivery
//
//  Created by Peter on 10/08/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMOperationRequestCardDiscount.h"
#import "Tools.h"

@implementation IMOperationRequestCardDiscount

- (void)main
{
    NSString* UserPhone = [Tools GetUserPhoneNumber];
    if (UserPhone)
    {
    Params = [[NSDictionary alloc] initWithObjectsAndKeys:
              @"query", @"discount",
              @"phone", UserPhone,
              @"application", @"1",nil];
    }
    
    [super main];
}

@end
