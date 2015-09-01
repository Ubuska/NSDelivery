//
//  XMLOrderCreator.m
//  Delivery
//
//  Created by Peter on 23/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "XMLOrderCreator.h"

#import "XMLWriter.h"
#import "IMCartManager.h"
#import "IMProduct.h"


@implementation XMLOrderCreator

- (NSString*) CreateXML:(IMUserData*)UserData
{
    // allocate serializer
    XMLWriter* xmlWriter = [[XMLWriter alloc]init];
    
    // start writing XML elements
    [xmlWriter writeStartElement:@"data"];
    
    // USER INFO START
    [xmlWriter writeStartElement:@"userinfo"];
    
    // name
    [xmlWriter writeStartElement:@"name"];
    [xmlWriter writeCharacters:UserData.UserName];
    [xmlWriter writeEndElement];
    
    // street
    if (UserData.UserStreet.length > 0)
        {
            [xmlWriter writeStartElement:@"street"];
            [xmlWriter writeCharacters:UserData.UserStreet];
            [xmlWriter writeEndElement];
        }
    
    // house
    if (UserData.UserHouse.length > 0)
        {
            [xmlWriter writeStartElement:@"house"];
            [xmlWriter writeCharacters:UserData.UserHouse];
            [xmlWriter writeEndElement];
        }
    
    // apartment
    if (UserData.UserApartment.length > 0)
        {
            [xmlWriter writeStartElement:@"apartment"];
            [xmlWriter writeCharacters:UserData.UserApartment];
            [xmlWriter writeEndElement];
        }
    
    // phone number
    [xmlWriter writeStartElement:@"phone"];
    [xmlWriter writeCharacters:UserData.UserPhoneNumber];
    [xmlWriter writeEndElement];
    
    // USER INFO END
    [xmlWriter writeEndElement];
    
    // ORDERDATA
    [xmlWriter writeStartElement:@"orderdata"];
    
    for (int i = 0; i < [CartManager GetItemsCount]; i++)
    {
        IMProduct* Product = [CartManager GetItemByIndex:i];
        [xmlWriter writeStartElement:@"product"];
        
        [xmlWriter writeStartElement:@"name"];
        [xmlWriter writeCharacters:[Product GetName]];
        [xmlWriter writeEndElement];
        
        [xmlWriter writeStartElement:@"quantity"];
        [xmlWriter writeCharacters:[NSString stringWithFormat:@"%d", Product.Quantity]];
        [xmlWriter writeEndElement];
        
        [xmlWriter writeStartElement:@"price"];
        [xmlWriter writeCharacters:Product.ProductPrice];
        [xmlWriter writeEndElement];
        
        [xmlWriter writeEndElement];
    }
    
    [xmlWriter writeEndElement];
    
    if ([CartManager GetBonusesCount] > 0)
    {
        
    
    // Bonuses
    [xmlWriter writeStartElement:@"bonus_data"];
    
    for (int j = 0; j < [CartManager GetBonusesCount]; j++)
    {
        IMBonus* Bonus = [CartManager GetBonusByIndex:j];
        [xmlWriter writeStartElement:@"bonus"];
        
        [xmlWriter writeStartElement:@"bonus_id"];
        [xmlWriter writeCharacters:[NSString stringWithFormat:@"%d", [Bonus GetId]]];
        [xmlWriter writeEndElement];
        
        [xmlWriter writeStartElement:@"bonus_quantity"];
        [xmlWriter writeCharacters:[NSString stringWithFormat:@"%i", 1]];
        [xmlWriter writeEndElement];
        
        [xmlWriter writeEndElement];
    }
    
    [xmlWriter writeEndElement];
    
    }
    [xmlWriter writeEndElement];
    // get the resulting XML string
    NSString* xml = [xmlWriter toString];
    return xml;
}

@end
