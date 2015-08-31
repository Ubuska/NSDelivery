//
//  Section.m
//  Delivery
//
//  Created by Peter on 09/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "Section.h"

@implementation Section

- (int) GetChildCount
{
    return [Children count];
}

// Getters


- (int) GetItemIndex
{
    return SectionIndex;
}

- (int) GetParentIndex
{
    return ParentIndex;
}

- (id) GetSectionManagerHandler
{
    return SectionManagerHandler;
}

// Setters

- (void) SetSectionManagerHandler:(id)Handler
{
    SectionManagerHandler = Handler;
}

- (void) SetItemIndex:(int)IndexToSet
{
    SectionIndex = IndexToSet;
}

- (void) SetParentIndex:(int)IndexToSet
{
    ParentIndex = IndexToSet;
}








@end
