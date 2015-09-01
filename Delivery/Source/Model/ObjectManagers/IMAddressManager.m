//
//  IMAdressManager.m
//  Delivery
//
//  Created by Peter on 22/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMAddressManager.h"

@implementation IMAddressManager

- (void) InitializeManager
{
}

- (void) InsertItem:(NSObject*) ItemToInsert AtIndex:(NSUInteger)InsertIndex
{
    [DataContainer insertObject:ItemToInsert atIndex:InsertIndex];
}

- (void) AddItem:(NSObject*) ItemToAdd;
{
    IMAddress* ItemAsEvent = (IMAddress*) ItemToAdd;
    if ([ItemAsEvent isKindOfClass:[IMAddress class]])
    {
        [DataContainer addObject:ItemToAdd];
    }
}

- (id) GetItemByName:(NSString*) ProductName
{
    for (IMAddress* CurrentAddress in DataContainer)
    {
        if ([[CurrentAddress GetName] isEqualToString:ProductName])
        {
            return CurrentAddress;
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


@end
