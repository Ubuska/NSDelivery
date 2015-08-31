//
//  IMItem.h
//  Delivery
//
//  Created by Peter on 15/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMItem : NSObject
{
    NSString* Name;
    int Id;
    
    NSMutableArray* Children;
    IMItem* Parent;
}

@property NSString* ImageURL;
@property NSString* Description;

- (NSString*) GetName;
- (int) GetId;

- (void) SetName:(NSString*)NameToSet;
- (void) SetId:(int)IdToSet;

- (int) GetParentIndex;

- (void) AddChild:(IMItem*)Child;
- (void) AddParent:(IMItem*)ParentItem;

- (IMItem*) GetParent;

- (IMItem*) GetChildById;
- (IMItem*) GetChildByIndex:(int)Index;
- (NSMutableArray*) GetChildren;
- (NSMutableArray*) FilterChildrenByType:(Class)FilterClass;

@end
