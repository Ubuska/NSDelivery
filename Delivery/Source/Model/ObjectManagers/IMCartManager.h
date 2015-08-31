//
//  IMCartManager.h
//  Delivery
//
//  Created by Peter on 15/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IMAbstractManager.h"
#import "Section.h"
#import "IMBonus.h"
#import "IMUserData.h"

#define CartManager [IMCartManager SharedInstance]

@interface IMCartManager : IMAbstractManager
{
    int MoneyInCart;
    NSMutableArray* Bonuses;
    IMUserData* UserData;
    NSUInteger MinimumOrderSum;
}

// Specific methods
- (NSUInteger) GetItemsCount:(Section*)SectionToSearch;

- (void) AddBonus:(IMBonus*) BonusToAdd;
- (IMBonus*) GetBonusByIndex:(NSUInteger)Index;
- (IMBonus*) GetBonusById:(NSUInteger)Index;
- (NSUInteger) GetBonusesCount;
- (void) RemoveBonus:(IMBonus*)BonusToRemove;

- (Money) GetMoneyInCart;
- (Money) GetMoneyInCartWithoutDiscount;
- (NSString*) GetMoneyInCartString;

- (void) SetUserData:(IMUserData*) Data;
- (IMUserData*) GetUserData;

- (void) SetMinimumOrderSum:(NSUInteger) Sum;
- (BOOL) IsEmpty;
- (BOOL) IsOrderSumEnough;

- (void) ClearBonuses;

@end
