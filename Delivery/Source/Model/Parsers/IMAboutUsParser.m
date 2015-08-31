//
//  IMAboutUsParser.m
//  Delivery
//
//  Created by Peter on 05/08/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMAboutUsParser.h"
#import "IMAboutData.h"
#import "Section.h"
#import "IMAboutUsManager.h"
#import "IMSectionManager.h"

@implementation IMAboutUsParser
{
    IMAboutData* AboutUsText;
}

- (void) Initialize{}

- (void)DidStartElement
{
    IfElement(@"data")
    {
        AboutUsText = [IMAboutData new];
        [AboutUsText Initialize];
        [AboutUsManager AddItem:AboutUsText];
    }
}

- (void)DidEndElement
{
    IfElement(@"about") AboutUsText.Description = ElementValue;
    ElseIfElement(@"image") [AboutUsText AddImageURL:ElementValue];
}

- (void)DidEndDocument
{
    if ([SectionManager GetItemByName:@"Главная"] != NULL) return;
    Section* AboutUs = [Section new];
    [AboutUs SetName:@"Главная"];
    [AboutUs SetSectionManagerHandler:[AboutUsManager class]];
    [SectionManager AddItem:AboutUs];
    
    //[self performSelectorOnMainThread:@selector(NotifyApplication:) withObject:Products waitUntilDone:NO];
}
@end
