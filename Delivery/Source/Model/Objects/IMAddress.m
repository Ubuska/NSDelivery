//
//  IMRestaraunt.m
//  Delivery
//
//  Created by Developer on 22.12.14.
//  Copyright (c) 2014 incodemobile. All rights reserved.
//

#import "IMAddress.h"

@implementation IMAddress

- (NSString*) GetAddress
{
    return Address;
}

- (void) SetAddress:(NSString*)AddressName
{
    Address = AddressName;
}

- (NSString*) GetPhone
{
    return Phone;
}
- (void) SetPhone:(NSString*)PhoneNumber
{
    Phone = PhoneNumber;
}

@end
