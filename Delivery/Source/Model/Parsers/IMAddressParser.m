
//  IMAdressParser.m

#import "IMAddressParser.h"
#import "IMAddress.h"
#import "IMAppDelegate.h"
#import "IMAddressManager.h"
#import "IMSectionManager.h"

@implementation IMAddressParser
{
    IMAddress* CurrentAddress;
}

- (void)Initialize
{
}

- (void)DidStartElement
{
    IfElement(@"restaraunt")
    {
        //NSLog(@"Found restaraunt!");
        CurrentAddress = [IMAddress new];
        [AddressManager AddItem:CurrentAddress];
    }
}

- (void)DidEndElement
{
    IfElement(@"name") [CurrentAddress SetName:ElementValue];
    ElseIfElement(@"address") [CurrentAddress SetAddress:ElementValue];
    ElseIfElement(@"phone") [CurrentAddress SetPhone:ElementValue];
    ElseIfElement(@"description") BindStr(CurrentAddress.Description);
    ElseIfElement(@"image") BindStr(CurrentAddress.ImageURL);
}

- (void)DidEndDocument
{

        Section* AddressSection = [Section new];
        [AddressSection SetName:@"Адреса"];
        [AddressSection SetSectionManagerHandler:[AddressManager class]];
        [SectionManager AddItem:AddressSection];
    //[self performSelectorOnMainThread:@selector(NotifyApplication:) withObject:Products waitUntilDone:NO];
}


@end
