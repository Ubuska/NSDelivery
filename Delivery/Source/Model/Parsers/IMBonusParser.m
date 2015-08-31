//
//  IMBonusParser.m
//  Delivery
//
//  Created by Peter on 26/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMBonusParser.h"

#import "IMBonus.h"
#import "Section.h"

#import "IMBonusManager.h"
#import "IMSectionManager.h"

@implementation IMBonusParser
{
    IMBonus* CurrentBonus;
}

- (void)Initialize
{
}

- (void)DidStartElement
{
    IfElement(@"bonus")
    {
        NSLog(@"BONUS ---=-----==-----!");
        CurrentBonus = [IMBonus new];
        
    }
}

- (void)DidEndElement
{
    IfElement(@"name") [CurrentBonus SetName:ElementValue];
    IfElement(@"id") [CurrentBonus SetId:[ElementValue intValue]];
    ElseIfElement(@"description") BindStr(CurrentBonus.Description);
    ElseIfElement(@"image") BindStr(CurrentBonus.ImageURL);
    ElseIfElement(@"productid") [CurrentBonus SetProductId:[ElementValue intValue]];
    ElseIfElement(@"sum") [CurrentBonus SetSum:[ElementValue intValue]];
    ElseIfElement(@"award")
    {
        [CurrentBonus SetAward:ElementValue];
        [BonusManager AddItem:CurrentBonus];
    }
    
}

- (void)DidEndDocument
{
        Section* BonusSection = [Section new];
        [BonusSection SetName:@"Бонусы"];
        [BonusSection SetSectionManagerHandler:[BonusManager class]];
        [SectionManager AddItem:BonusSection];
        
    //[self performSelectorOnMainThread:@selector(NotifyApplication:) withObject:Products waitUntilDone:NO];
}

@end
