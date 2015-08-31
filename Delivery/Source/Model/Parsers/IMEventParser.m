
//  IMEventParser.m


#import "IMEventParser.h"
#import "IMEvent.h"
#import "IMAppDelegate.h"

#import "IMSectionManager.h"
#import "Section.h"

@implementation IMEventParser
{
    IMEvent* CurrentEvent;
}

- (void)Initialize
{
}

- (void)DidStartElement
{
    IfElement(@"event")
    {
        //NSLog(@"Found event!");
        CurrentEvent = [IMEvent new];
        [EventManager AddItem:CurrentEvent];
    }
}

- (void)DidEndElement
{
    IfElement(@"name") [CurrentEvent SetName:ElementValue];
    ElseIfElement(@"description") BindStr(CurrentEvent.Description);
    ElseIfElement(@"image") BindStr(CurrentEvent.ImageURL);
}

- (void)DidEndDocument
{
    [self performSelectorOnMainThread:@selector(ParsingEnd) withObject:nil waitUntilDone:NO];
}

- (void) ParsingEnd
{
        Section* EventsSection = [Section new];
        [EventsSection SetName:@"Акции"];
        [EventsSection SetSectionManagerHandler:[EventManager class]];
        [SectionManager AddItem:EventsSection];
}


@end
