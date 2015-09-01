//
//  IMOperationParse.h
//  Delivery
//
//  Created by Peter on 03/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IMAbstractManager.h"
#import "IMAbstractParser.h"
#import "Protocols.h"
#import "IMOperation.h"

@interface IMOperationParse : IMOperation
{
    NSURL* URL;
    NSMutableArray* ProcessingItems;
    IMAbstractManager* Manager;
    IMAbstractParser* Parser;
}

- (id)initWithData:(NSURL*)url ManagerInstance:(IMAbstractManager*) ObjectManager ParserInstance:(IMAbstractParser*) ObjectParser;

- (void) ParsingOperationDidFinishWithItems;
@end
