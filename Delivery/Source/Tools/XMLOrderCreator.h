//
//  XMLOrderCreator.h
//  Delivery
//
//  Created by Peter on 23/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMUserData.h"

@interface XMLOrderCreator : NSObject

- (NSString*) CreateXML:(IMUserData*)UserData;

@end
