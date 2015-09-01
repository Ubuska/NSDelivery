//
//  IMBonusManager.m
//  Delivery
//
//  Created by Peter on 26/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMBonusManager.h"
#import "IMBonus.h"

@implementation IMBonusManager

- (void) InitializeManager
{
}

- (void) InsertItem:(NSObject*) ItemToInsert AtIndex:(NSUInteger)InsertIndex
{
    [DataContainer insertObject:ItemToInsert atIndex:InsertIndex];
}

- (void) AddItem:(NSObject*) ItemToAdd;
{
    
    IMBonus* ItemAsBonus = (IMBonus*) ItemToAdd;
    NSLog(@"BONUS ADDED! %@", [ItemAsBonus GetName] );
    if ([ItemAsBonus isKindOfClass:[IMBonus class]])
    {
        [DataContainer addObject:ItemToAdd];
    }
}

- (id) GetItemByName:(NSString*) ProductName
{
    for (IMBonus* CurrentBonus in DataContainer)
    {
        if ([[CurrentBonus GetName] isEqualToString:ProductName])
        {
            return CurrentBonus;
        }
    }
    return NULL;
}

- (id) GetItemByIndex:(int) ItemIndex
{
    return DataContainer[ItemIndex];
    
    return NULL;
}

- (id) GetItemById:(int)ItemId
{
    for (IMBonus* CurrentBonus in DataContainer)
    {
        if ([CurrentBonus GetId] == ItemId)
        {
            return CurrentBonus;
        }
    }

    return NULL;
}

- (NSUInteger) GetItemsCount
{
    return [DataContainer count];
}



- (void) ClearAll
{
    [DataContainer removeAllObjects];
}

- (void) ResetBonuses
{
    for (IMBonus* CurrentBonus in DataContainer)
    {
        [CurrentBonus SetQuantity:0];
        //[CurrentBonus SetSum:0];
    }
}

@end
