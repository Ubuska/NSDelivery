//
//  IMProductParser.h
//  Delivery
//
//  Created by Peter on 08/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMAbstractParser.h"

@interface IMProductParser : IMAbstractParser
- (void) NotifyApplication:(NSMutableArray*)ParsedProducts;
@end
