//
//  IMDiscountParser.m
//  Delivery
//
//  Created by Peter on 11/08/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMDiscountParser.h"
#import "IMDiscount.h"
#import "IMDiscountManager.h"

@implementation IMDiscountParser
{
    IMDiscount* CurrentDiscount;
}

- (void) Initialize{}

- (void)DidStartElement
{
    IfElement(@"outsum")
    {
        CurrentDiscount = [IMDiscount new];
        [ObjectManager AddItem:CurrentDiscount];
    }
}

- (void)DidEndElement
{
    IfElement(@"outsum")
    {
        [CurrentDiscount SetOutsum:[ElementValue integerValue]];
    }
    ElseIfElement(@"discount")
    {
        [CurrentDiscount SetDiscountPercent:[ElementValue integerValue]];
    }
}

- (void)DidEndDocument
{
    [DiscountManager SortDiscountsByOutsum];
    //[self performSelectorOnMainThread:@selector(NotifyApplication:) withObject:Products waitUntilDone:NO];
}

@end
