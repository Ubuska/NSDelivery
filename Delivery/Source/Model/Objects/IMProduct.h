//
//  IMProduct.h
//  Delivery
//
//  Created by Developer on 11.12.14.
//  Copyright (c) 2014 incodemobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMItem.h"

@interface IMProduct : IMItem

@property NSString* ProductPrice;
@property int Quantity;

@property NSString* Weight;
@property NSString* OptionName;
@property NSString* OptionUnit;
@property NSString* Status;
@end
