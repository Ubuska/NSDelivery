//
//  IMEventManager.m
//  Delivery
//
//  Created by Peter on 17/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMEventManager.h"
#import "IMEvent.h"

@implementation IMEventManager

- (void) InitializeManager
{
}

- (void) InsertItem:(NSObject*) ItemToInsert AtIndex:(NSUInteger)InsertIndex
{
    [DataContainer insertObject:ItemToInsert atIndex:InsertIndex];
}

- (void) AddItem:(NSObject*) ItemToAdd;
{
    IMEvent* ItemAsEvent = (IMEvent*) ItemToAdd;
    if ([ItemAsEvent isKindOfClass:[IMEvent class]])
    {
        [DataContainer addObject:ItemToAdd];
    }
}

- (id) GetItemByName:(NSString*) ProductName
{
    for (IMEvent* CurrentEvent in DataContainer)
    {
        if ([[CurrentEvent GetName] isEqualToString:ProductName])
        {
            return CurrentEvent;
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
