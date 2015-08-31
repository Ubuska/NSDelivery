//
//  IMDiscount.m
//  Delivery
//
//  Created by Peter on 11/08/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMDiscount.h"

@implementation IMDiscount

- (void) SetOutsum:(NSUInteger)OutsumAmount
{
    Outsum = OutsumAmount;
}
- (void) SetDiscountPercent:(NSUInteger)Discount
{
    DiscountPercent = Discount;
}

- (NSUInteger) GetOutsum
{
    return Outsum;
}
- (NSUInteger) GetDiscountPercent
{
    return DiscountPercent;
}

@end
