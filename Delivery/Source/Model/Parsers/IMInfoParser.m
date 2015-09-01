//
//  IMInfoParser.m
//  Delivery
//
//  Created by Peter on 08/07/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMInfoParser.h"
#import "IMSectionManager.h"
#import "IMInfoManager.h"
#import "IMCartManager.h"
#import "IMItem.h"

@implementation IMInfoParser
{
    IMItem* CurrentInfo;
}

- (void) Initialize{}

- (void)DidStartElement
{
    IfElement(@"info")
    {
        CurrentInfo = [IMItem new];
        [InfoManager AddItem:CurrentInfo];
    }
}

- (void)DidEndElement
{
    IfElement(@"name") [CurrentInfo SetName:ElementValue];
    ElseIfElement(@"description") BindStr(CurrentInfo.Description);
    ElseIfElement(@"min_sum")[CartManager SetMinimumOrderSum:[ElementValue intValue]];
    
}

- (void)DidEndDocument
{
        Section* BonusSection = [Section new];
        IMItem* DeliveryConditionsItem = [InfoManager GetItemByIndex:0];
        [BonusSection SetName:[DeliveryConditionsItem GetName]];
        [BonusSection SetSectionManagerHandler:[InfoManager class]];
        [SectionManager AddItem:BonusSection];
    
    //[self performSelectorOnMainThread:@selector(NotifyApplication:) withObject:Products waitUntilDone:NO];
}


@end
