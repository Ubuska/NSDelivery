////
//  IMProductManager.m
//  Delivery
//
//  Created by Peter on 08/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMProductManager.h"
#import "IMProduct.h"
#import "Tools.h"
#import "IMDiscountManager.h"
#import "IMSectionManager.h"

@implementation IMProductManager

- (void) InitializeManager
{
}

- (void) InsertItem:(NSObject*) ItemToInsert AtIndex:(NSUInteger)InsertIndex
{
    [DataContainer insertObject:ItemToInsert atIndex:InsertIndex];
}

- (void) AddItem:(NSObject*) ItemToAdd;
{
    IMProduct* ItemAsProduct = (IMProduct*) ItemToAdd;
    if ([ItemAsProduct isKindOfClass:[IMProduct class]])
        {
            //NSLog(@"Added item %@", ItemAsProduct.name);
            [DataContainer addObject:ItemAsProduct];
        }
}

- (id) GetItemByName:(NSString*) ProductName
{
    for (IMProduct* CurrentProduct in DataContainer)
    {
        if ([[CurrentProduct GetName] isEqualToString:ProductName])
        {
            return CurrentProduct;
        }
    }
    return NULL;
}

- (id) GetItemByIndex:(int) ItemIndex
{
    if (DataContainer[ItemIndex]) return DataContainer[ItemIndex];
    
    return NULL;
}


- (id) GetItemById:(int)ItemId
{
    for (IMProduct* CurrentProduct in DataContainer)
    {
        if ([CurrentProduct GetId] == ItemId)
        {
            return CurrentProduct;
        }
    }
    return NULL;
}

- (NSUInteger) GetItemsCount
{
    return [DataContainer count];
}

- (id) GetItemByIndex:(int) ItemIndex SectionToSearch:(Section*)InSection
{
    
    if ([InSection GetChildByIndex:ItemIndex]) return [InSection GetChildByIndex:ItemIndex];
    
    return NULL;
}

- (NSUInteger) GetIndexOfItem:(IMItem*) Item
{
    
    Section* ParentSection = (Section*) [Item GetParent];
    NSMutableArray* FilteredItemsBySection = [ParentSection FilterChildrenByType:[IMProduct class]];
    NSUInteger Index = [FilteredItemsBySection indexOfObject:(IMProduct*)Item];
    return [FilteredItemsBySection indexOfObject:Item];
}

/*
- (NSUInteger) GetItemsCountInSection:(Section*)SectionToSearch
{
    return [SectionToSearch GetChildCount];
}
*/

- (void) ClearAll
{
    [DataContainer removeAllObjects];
    //[[IMSectionManager SharedInstance] ClearAll];
}

- (void) ModifyPricesWithDiscount
{
    if ([DiscountManager GetDiscountType] == EDT_Card)
    {
        for (IMProduct* CurrentProduct in DataContainer)
            {
                Money ModifiedPrice = [Tools GetPriceWithDiscount:CurrentProduct.ProductPrice Discount:[DiscountManager GetDiscountAmount]];
                CurrentProduct.ProductPrice = [NSString stringWithFormat:@"%f", ModifiedPrice];
            }
    }
}

@end
