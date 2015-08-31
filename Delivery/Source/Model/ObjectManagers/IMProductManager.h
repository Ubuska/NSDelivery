//
//  IMProductManager.h
//  Delivery
//
//  Created by Peter on 08/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMAbstractManager.h"
#import "Section.h"

#define ProductManager [IMProductManager SharedInstance]

@interface IMProductManager : IMAbstractManager

- (NSUInteger) GetItemsCountInSection:(Section*)SectionToSearch;
- (id) GetItemByIndex:(int) ItemIndex SectionToSearch:(Section*)InSection;
- (void) ModifyPricesWithDiscount;
@end
