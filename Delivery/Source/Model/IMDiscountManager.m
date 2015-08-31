//
//  IMUserInfoManager.m
//  Delivery
//
//  Created by Peter on 10/08/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMUserInfoManager.h"

@implementation IMUserInfoManager

static IMUserInfoManager *sSingleton = nil;

+ (IMUserInfoManager *) SharedInstance
{
    @synchronized(self)
    {
        if (sSingleton == nil)
        {
            sSingleton = [[super allocWithZone:nil] init];
        }
    }
    
    return sSingleton;
}

- (NSUInteger) GetCardNumber
{
    return DiscountCardInfo.CardNumber;
}
- (NSUInteger) GetDiscountAmount
{
    return DiscountCardInfo.CardDiscountAmount;
}
- (NSURL*) GetCardImageURL
{
    NSURL* URL = [NSURL URLWithString:DiscountCardInfo.CardImageURL];
    return URL;
}

- (void) SetCardNumber:(NSString*)Number
{
    DiscountCardInfo.CardNumber = [Number integerValue];
}
- (void) SetCardDiscountAmount:(NSString*)DiscountAmount
{
    DiscountCardInfo.CardDiscountAmount = [DiscountAmount integerValue];
}
- (void) SetCardImageURL:(NSString*)URL
{
    DiscountCardInfo.CardImageURL = URL;
}

@end
