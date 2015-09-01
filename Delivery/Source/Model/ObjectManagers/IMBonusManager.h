//
//  IMBonusManager.h
//  Delivery
//
//  Created by Peter on 26/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMAbstractManager.h"

#define BonusManager [IMBonusManager SharedInstance]

@interface IMBonusManager : IMAbstractManager

- (void) ResetBonuses;

@end
