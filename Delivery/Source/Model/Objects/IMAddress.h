//
//  IMRestaraunt.h
//  Delivery
//
//  Created by Developer on 22.12.14.
//  Copyright (c) 2014 incodemobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMItem.h"

@interface IMAddress : IMItem
{
    NSString* Address;
    NSString* Phone;
}

- (NSString*) GetAddress;
- (void) SetAddress:(NSString*)AddressName;

- (NSString*) GetPhone;
- (void) SetPhone:(NSString*)PhoneNumber;
@end
