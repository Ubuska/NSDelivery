//
//  IMSectionManager.m
//  Delivery
//
//  Created by Peter on 09/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMSectionManager.h"
#import "Section.h"
#import "IMProduct.h"

@implementation IMSectionManager

- (void) InitializeManager
{
}

- (void) InsertItem:(NSObject*) ItemToInsert AtIndex:(NSUInteger)InsertIndex
{
    if (!DataContainer) DataContainer = [NSMutableArray arrayWithCapacity:0];
    [DataContainer insertObject:ItemToInsert atIndex:0];
    Section* ItemAsSection = (Section*) ItemToInsert;
    //[Products insertObject:ItemToInsert atIndex:InsertIndex];
    NSLog(@"Inserted %@", [ItemAsSection GetName] );
    NSLog(@"Sections: %i", [DataContainer count]);
}

- (void) AddItem:(NSObject*) ItemToAdd;
{
    if (!DataContainer) DataContainer = [NSMutableArray arrayWithCapacity:0];
    Section* ItemAsSection = (Section*) ItemToAdd;
    if ([ItemAsSection isKindOfClass:[Section class]])
    {
        //NSLog(@"Added section %@", [ItemAsSection GetName], @" with Id: %@", [ItemAsSection GetId]);
        [DataContainer addObject:ItemAsSection];
    }
    NSLog(@"Added %@", [ItemAsSection GetName] );
    NSLog(@"Sections: %i", [DataContainer count]);
}

- (id) GetItemByName:(NSString*) ProductName
{
    for (Section* CurrentSection in DataContainer)
    {
        if ([[CurrentSection GetName] isEqualToString:ProductName])
        {
            return CurrentSection;
        }
    }
    return NULL;
}

- (id) GetItemById:(int) ItemId
{
    for (Section* CurrentSection in DataContainer)
    {
        if ([CurrentSection GetId] == ItemId && [CurrentSection GetItemIndex] == CurrentSectionIndex)
        {
            return CurrentSection;
        }
    }
    
    return NULL;
}

- (id) GetItemByIndex:(int) ItemIndex
{
    if (DataContainer && [DataContainer count] > 0)
    {
        Section* CurrentSection = DataContainer[ItemIndex];
        if ([CurrentSection GetItemIndex] == CurrentSectionIndex)
        {
            return CurrentSection;
        }
    }
    
    return NULL;
}

- (NSMutableArray*) FilterSectionsByIndex:(int)Index
{
    NSMutableArray* AllSections = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray* FilteredSections = [NSMutableArray arrayWithCapacity:0];
    
    AllSections = DataContainer;
    
    for (Section* CurrentSection in AllSections)
    {
        if ([CurrentSection GetItemIndex] == Index)
        [FilteredSections addObject:CurrentSection];
        
    }
    
    return FilteredSections;

}


- (NSUInteger) GetItemsCount
{
    NSUInteger Counter = 0;
    for (Section* CurrentSection in DataContainer)
    {
        if ([CurrentSection GetItemIndex] == CurrentSectionIndex)
        {
            Counter ++;
        }
    }
    return Counter;
}


- (void) ClearAll
{
    [DataContainer removeAllObjects];
}

// Section Manager Specific Behavior

- (void) SetActiveSection:(Section*)SectionToSet
{
    if (SectionToSet)
    {
        ActiveSection = SectionToSet;
    }
}

- (Section*) GetActiveSection
{
    return ActiveSection;
}

- (void) SetSectionIndex:(int)PathIndex
{
    CurrentSectionIndex = PathIndex;
}

- (NSMutableArray*) FilterChildrenByType:(Section*)SectionToFilter FilterClass:(Class)FilterType
{
    NSMutableArray* AllChildren = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray* FilteredChildren = [NSMutableArray arrayWithCapacity:0];
    
    AllChildren = [SectionToFilter GetChildren];
    
    for (NSObject* CurrentChild in AllChildren)
    {
        if ([CurrentChild isKindOfClass:FilterType])
        {
            [FilteredChildren addObject:CurrentChild];
        }
    }
    
    return FilteredChildren;
}

- (NSUInteger) GetItemCountInSection:(Section*)SectionToSearch FilterClass:(Class)FilterType
{
    NSUInteger Counter = 0;
    NSMutableArray *ChildrenInSection = [NSMutableArray arrayWithCapacity:0];
    ChildrenInSection = SectionToSearch.GetChildren;
    
    for (NSObject* CurrentItem in ChildrenInSection)
    {
        if ([CurrentItem isKindOfClass:FilterType])
        {
            Counter++;
        }
    }
    return Counter;
}

- (void) SortSectionHierarchy
{
    for (Section* CurrentSection in DataContainer)
    {
       if ([CurrentSection GetParentIndex] > 0)
       {
           Section* ParentSection = [self GetItemById:[CurrentSection GetParentIndex]];
           [CurrentSection AddParent:ParentSection];
           [CurrentSection SetItemIndex:[ParentSection GetItemIndex] + 1];
       }
        
    }
    NSLog(@"Sections Sorted");
}

- (NSMutableArray*) FilterSectionsByHandler:(id)SectionHandler
{
    NSMutableArray *FilteredSections = [NSMutableArray arrayWithCapacity:0];
    //IMAbstractManager* Handler = SectionHandler;
    for (Section* CurrentSection in DataContainer)
    {
        if ([CurrentSection GetSectionManagerHandler] == SectionHandler)
        {
            [FilteredSections addObject:CurrentSection];
        }
    }
    return FilteredSections;
}

@end
