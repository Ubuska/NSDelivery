//
//  IMSectionManager.h
//  Delivery
//
//  Created by Peter on 09/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMAbstractManager.h"

#import "Section.h"

#define SectionManager [IMSectionManager SharedInstance]

@interface IMSectionManager : IMAbstractManager
{
    int CurrentSectionIndex;
    Section* ActiveSection;
}

- (void) SetSectionIndex:(int)PathIndex;

- (void) SetActiveSection:(Section*)SectionToSet;
- (Section*) GetActiveSection;
- (NSUInteger) GetItemCountInSection:(Section*)SectionToSearch FilterClass:(Class)FilterType;

- (NSMutableArray*) FilterChildrenByType:(Section*)SectionToFilter FilterClass:(Class)FilterType;
- (NSMutableArray*) FilterSectionsByHandler:(id)SectionHandler;
- (NSMutableArray*) FilterSectionsByIndex:(int)Index;

- (void) SortSectionHierarchy;

@end
