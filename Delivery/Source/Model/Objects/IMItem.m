//
//  IMItem.m
//  Delivery
//
//  Created by Peter on 15/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMItem.h"

@implementation IMItem

- (NSString*) GetName
{
    return Name;
}

- (int) GetId
{
    return Id;
}

- (void) SetName:(NSString*)NameToSet
{
    if ([NameToSet length] > 0)
    {
        Name = NameToSet;
    }
}
- (void) SetId:(int)IdToSet
{
    Id = IdToSet;
}



- (void) AddChild:(IMItem*)Child
{
    if (!Children)
    {
        Children = [NSMutableArray arrayWithCapacity:0];
    }
    [Children addObject:Child];
}


- (void) AddParent:(IMItem*)ParentItem
{
    Parent = ParentItem;
    if (Parent) [Parent AddChild:self];
}


- (IMItem*) GetParent
{
    return Parent;
}

- (IMItem*) GetChildById
{
    return NULL;
}

- (IMItem*) GetChildByIndex:(int)Index
{
    return Children[Index];
}

- (NSMutableArray*) GetChildren
{
    return Children;
}

- (NSMutableArray*) FilterChildrenByType:(Class)FilterClass
{
    NSMutableArray* FilteredChildren = [NSMutableArray arrayWithCapacity:0];
    for (IMItem* CurrentChild in Children)
    {
        if ([CurrentChild isKindOfClass:FilterClass])
        {
            [FilteredChildren addObject:CurrentChild];
        }
    }
    return FilteredChildren;
}

@end
