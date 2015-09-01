//
//  IMCartManager.m
//  Delivery
//
//  Created by Peter on 15/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMCartManager.h"
#import "IMProduct.h"
#import "IMDiscountManager.h"

@implementation IMCartManager


// Interface methods
- (void) InitializeManager
{
}

- (void) InsertItem:(NSObject*) ItemToInsert AtIndex:(NSUInteger)InsertIndex
{
    
}
- (void) AddItem:(NSObject*) ItemToAdd
{
    if (![DataContainer containsObject:ItemToAdd])
    [DataContainer addObject:ItemToAdd];
}

- (void) RemoveItem:(NSObject*) ItemToRemove
{
    if ([DataContainer containsObject:ItemToRemove])
    {
        [DataContainer removeObject:ItemToRemove];
    }
}

- (void) ClearAll
{
    [DataContainer removeAllObjects];
    [Bonuses removeAllObjects];
}

- (id) GetItemByName:(NSString*) ItemName
{
    return NULL;
}
- (id) GetItemById:(int) ItemId
{
    for (IMItem* CurrentItem in DataContainer)
    {
        if ([CurrentItem GetId] == ItemId)
        {
            return CurrentItem;
        }
    }
    return NULL;
}
- (id) GetItemByIndex:(int) ItemIndex
{
    return DataContainer[ItemIndex];

}
- (NSUInteger) GetItemsCount
{
    return [DataContainer count];
}

// Class-specific methods

/**
 This method calculates Money Sum in Cart.
 It loopes through ProductsInCart array and summarize each Product Sum, wich equals:
 ProductSum = Price * Quantity - DiscountAmount
 
 DiscountAmount corrects final money amount by discount, defined in DiscountManager.
 
 It returns final Sum for convinience.
 */
- (Money) GetMoneyInCart
{
    Money TempSum = 0;
    Money FinalSum = 0;
    
    Money DiscountPercent = [DiscountManager GetDiscountAmount];
    
    for (IMProduct* CurrentProduct in DataContainer)
    {
        Money ProductPrice = [CurrentProduct.ProductPrice doubleValue];
        int ProductQuantity = CurrentProduct.Quantity;
        TempSum += ProductPrice * ProductQuantity;
    }
    
    Money DiscountAmount = TempSum * DiscountPercent / 100;
    FinalSum = TempSum - DiscountAmount;
    MoneyInCart = FinalSum;
    return FinalSum;
}
- (Money) GetMoneyInCartWithoutDiscount
{
    Money TempSum = 0;
    
    for (IMProduct* CurrentProduct in DataContainer)
    {
        Money ProductPrice = [CurrentProduct.ProductPrice doubleValue];
        Money ProductQuantity = CurrentProduct.Quantity;
        TempSum += ProductPrice * ProductQuantity;
    }
    
    return TempSum;
}

- (void) AddBonus:(IMBonus*) BonusToAdd
{
    if (!Bonuses) Bonuses = [NSMutableArray arrayWithCapacity:0];
    [Bonuses addObject:BonusToAdd];
}
- (IMBonus*) GetBonusByIndex:(NSUInteger)Index
{
    return Bonuses[Index];
}
- (IMBonus*) GetBonusById:(NSUInteger)Index
{
    for (IMBonus* CurrentBonus in Bonuses)
    {
        if ([CurrentBonus GetId] == Index)
        {
            return CurrentBonus;
        }
    }

    return NULL;
}

- (NSUInteger) GetBonusesCount
{
    return [Bonuses count];
}

- (void) RemoveBonus:(IMBonus*)BonusToRemove
{
    [Bonuses removeObject:BonusToRemove];
}


- (NSString*) GetMoneyInCartString
{
    [DiscountManager IsDiscountActive];
    NSMutableString* CartMoney = [NSMutableString stringWithString:@"Корзина ("];
    NSString *Money = [[NSString alloc] initWithFormat:@"%.2f", [self GetMoneyInCart]];
    [CartMoney appendString:Money];
    [CartMoney appendString:@" Р.)"];
    NSString* FinalString = [NSString stringWithString:CartMoney];
    return FinalString;
}
- (void) SetUserData:(IMUserData*) Data
{
    UserData = Data;
}
- (IMUserData*) GetUserData
{
    return UserData;
}

- (void) SetMinimumOrderSum:(NSUInteger) Sum
{
    MinimumOrderSum = Sum;
}
- (BOOL) IsOrderSumEnough
{
    if (MoneyInCart < MinimumOrderSum)
        return NO;
    else
        return YES;
}

- (BOOL) IsEmpty
{
    if ([DataContainer count] == 0 && [Bonuses count] == 0)
    {
        return YES;
    }
    return NO;
}

- (void) ClearBonuses
{
    [Bonuses removeAllObjects];
}

@end
