//
//  IMUserInfoManager.h
//  Delivery
//
//  Created by Peter on 10/08/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UserInfoManager [IMUserInfoManager SharedInstance]

typedef struct
{
    NSUInteger CardNumber;
    NSUInteger CardDiscountAmount;
    __unsafe_unretained NSString* CardImageURL;
} SDiscountCardInfo;

@interface IMUserInfoManager : NSObject
{
    SDiscountCardInfo DiscountCardInfo;
}

- (NSUInteger) GetCardNumber;
- (NSUInteger) GetDiscountAmount;
- (NSURL*) GetCardImageURL;

- (void) SetCardNumber:(NSString*)Number;
- (void) SetCardDiscountAmount:(NSString*)DiscountAmount;
- (void) SetCardImageURL:(NSString*)URL;

+ (IMUserInfoManager *) SharedInstance;

@end
