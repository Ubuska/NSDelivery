//
//  IMDiscount.h
//  Delivery
//
//  Created by Peter on 11/08/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMDiscount : NSObject
{
    NSUInteger Outsum;
    NSUInteger DiscountPercent;
}

- (void) SetOutsum:(NSUInteger)OutsumAmount;
- (void) SetDiscountPercent:(NSUInteger)Discount;

- (NSUInteger) GetOutsum;
- (NSUInteger) GetDiscountPercent;

@end
