//
//  Tools.h
//  Delivery
//
//  Created by Peter on 02/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMAbstractManager.h"

@interface Tools : NSObject

+ (UIColor *) ColorWithHexString:(NSString *)StringToConvert;
+ (BOOL) CanCreateDrawerButton;
+ (BOOL) IsEmailValid:(NSString*) Email;
+ (NSString *) GetIPAddress;

+ (NSString *) GetMonthByIndex:(NSUInteger)Index;
+ (NSString *) GenerateUniqueUUID;
+ (NSString *) GetServerRequestURL;


+ (NSString *) GetUserPhoneNumber;
+ (Money) GetPriceWithDiscount:(NSString*)Price Discount:(NSInteger)Discount;
@end
