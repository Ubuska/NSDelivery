//
//  IMBonus.h
//  Delivery
//
//  Created by Peter on 26/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMItem.h"

@interface IMBonus : IMItem
{
    NSUInteger ProductId;
    NSUInteger Sum;
    NSUInteger Quantity;
    NSString* Award;
}

- (void) SetProductId:(NSUInteger) IdToSet;
- (void) SetQuantity:(NSUInteger) QuantityToSet;
- (void) SetSum:(NSUInteger) SumToSet;
- (void) SetAward:(NSString*)AwardToSet;

- (NSUInteger) GetProductId;
- (NSUInteger) GetQuantity;
- (NSUInteger) GetSum;
- (NSString*) GetAward;

@end
