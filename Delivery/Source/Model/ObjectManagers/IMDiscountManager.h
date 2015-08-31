//
//  IMUserInfoManager.h
//  Delivery
//
//  Created by Peter on 10/08/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMAbstractManager.h"
#import "IMDiscount.h"

#define DiscountManager [IMDiscountManager SharedInstance]

typedef struct
{
    NSUInteger CardNumber;
    NSUInteger CardDiscountAmount;
    __unsafe_unretained NSString* CardImageURL;
} SDiscountCardInfo;

typedef enum
{
    EDT_Outsum,
    EDT_Card
} EDiscountType;

@interface IMDiscountManager : IMAbstractManager <OperationNotifyReceiver>
{
    SDiscountCardInfo DiscountCardInfo;
    EDiscountType DiscountType;
    IMDiscount* CurrentDiscount;
}

- (NSUInteger) GetCardNumber;
- (NSUInteger) GetDiscountAmount;
- (NSURL*) GetCardImageURL;
-(EDiscountType) GetDiscountType;

- (void) SetCurrentDiscount:(IMDiscount*)Discount;
- (void) SetCurrentDiscountByIndex:(NSUInteger)Index;
- (IMDiscount*) GetCurrentDiscount;
- (IMDiscount*) GetNextDiscountAfterCurrent;
- (IMDiscount*) GetDiscountByOutsum;
- (BOOL) IsDiscountActive;

- (void) SetCardNumber:(NSString*)Number;
- (void) SetCardDiscountAmount:(NSString*)DiscountAmount;
- (void) SetCardImageURL:(NSString*)URL;
- (void) SetDiscountType:(EDiscountType)Type;

- (void) RequestDiscount;
- (void) SortDiscountsByOutsum;
@end
