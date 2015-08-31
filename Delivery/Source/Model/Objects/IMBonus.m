//
//  IMBonus.m
//  Delivery
//
//  Created by Peter on 26/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMBonus.h"

@implementation IMBonus

// Setters

- (void) SetProductId:(NSUInteger) IdToSet;
{
    ProductId = IdToSet;
}
- (void) SetQuantity:(NSUInteger) QuantityToSet
{
    Quantity = QuantityToSet;
}
- (void) SetSum:(NSUInteger) SumToSet
{
    Sum = SumToSet;
}
- (void) SetAward:(NSString*)AwardToSet
{
    Award = AwardToSet;
}

// Getters

- (NSUInteger) GetProductId
{
    return ProductId;
}
- (NSUInteger) GetQuantity
{
    return Quantity;
}
- (NSUInteger) GetSum
{
    return Sum;
}
- (NSString*) GetAward
{
    return Award;
}

@end
