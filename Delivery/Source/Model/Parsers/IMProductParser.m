
//  IMProductParser.m


#import "IMProductParser.h"
#import "IMProduct.h"
#import "Section.h"

#import "IMAppDelegate.h"

#import "IMSectionManager.h"
#import "IMProductManager.h"

@implementation IMProductParser
{
    Section* CurrentSection;
    IMProduct* CurrentProduct;
}

- (void)Initialize
{
}

- (void)DidStartElement
{
    IfElement(@"product")
    {
        CurrentProduct = [IMProduct new];
        [CurrentProduct AddParent:CurrentSection];
    }
    
    IfElement(@"category")
    {
        CurrentSection = [Section new];
        [CurrentSection SetSectionManagerHandler:[ProductManager class]];
    }
}

- (void)DidEndElement
{
    IfElement(@"name") [CurrentProduct SetName:ElementValue];
    IfElement(@"id") [CurrentProduct SetId:[ElementValue intValue]];
    ElseIfElement(@"description") BindStr(CurrentProduct.Description);
    ElseIfElement(@"image") BindStr(CurrentProduct.ImageURL);
    ElseIfElement(@"price") BindStr(CurrentProduct.ProductPrice);
    ElseIfElement(@"weight") BindStr(CurrentProduct.Weight);
    ElseIfElement(@"option_name") BindStr(CurrentProduct.OptionName);
    ElseIfElement(@"option_unit") BindStr(CurrentProduct.OptionUnit);
    ElseIfElement(@"status") BindStr(CurrentProduct.Status);
    
    IfElement(@"categoryname") [CurrentSection SetName:ElementValue];
    ElseIfElement(@"categoryid") [CurrentSection SetId:[ElementValue intValue]];
    
    ElseIfElement(@"parentcategoryid")
    {
        if ([ElementValue intValue] != 0)
            {
                [CurrentSection SetParentIndex:[ElementValue intValue]];
            }
        [SectionManager AddItem:CurrentSection];
    }
     IfElement(@"status")
    {
        
        [ObjectManager AddItem:CurrentProduct];
        
    }
}


- (void)DidEndDocument
{
    [SectionManager SortSectionHierarchy];
    [self performSelectorOnMainThread:@selector(NotifyApplication:) withObject:nil waitUntilDone:NO];
    //ifElement(@"item") [_items addObject:_item];
    //IfElement(@"image") (CurrentProduct.picurl);
    //elifElement(@"cdataValue") bindStr(_item.cDataValue);
    //elifElement(@"intValue") bindInt(_item.intValue);
    //elifElement(@"floatValue") bindFloat(_item.floatValue);
    //elifElement(@"number") bindNo(_item.number);
}

- (void) NotifyApplication:(NSMutableArray*)ParsedProducts
{
    IMAppDelegate *appDelegate = (IMAppDelegate*)[[UIApplication sharedApplication] delegate];
    //appDelegate.Products = [ParsedProducts copy];
    if (appDelegate.ControllerDelegate)[appDelegate.ControllerDelegate UpdateView];
}

@end
