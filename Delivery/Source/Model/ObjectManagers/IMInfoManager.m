//
//  IMInfoManager.m
//  Delivery
//
//  Created by Peter on 08/07/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMInfoManager.h"
#import "IMItem.h"

@implementation IMInfoManager

- (void) AddItem:(NSObject*) ItemToAdd;
{
    
    IMItem* ItemAsBonus = (IMItem*) ItemToAdd;
    if ([ItemAsBonus isKindOfClass:[IMItem class]])
    {
        [DataContainer addObject:ItemToAdd];
    }
}

- (id) GetItemByIndex:(int) ItemIndex
{
    return DataContainer[ItemIndex];
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
