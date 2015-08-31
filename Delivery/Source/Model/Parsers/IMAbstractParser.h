//
//  IMAbstractParser.h
//  Delivery
//
//  Created by Peter on 08/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Protocols.h"
#import "IMAbstractManager.h"

#define IfElement(str)    if ([ElementName isEqualToString:str])
#define ElseIfElement(str)  else if ([ElementName isEqualToString:str])
#define BindStr(obj)      obj = ElementValue
#define BindNumber(obj)       obj = [NSNumber numberWithDouble:[ElementValue doubleValue]]
#define BindDate(obj)     obj = [DateFormatter dateFromString:ElementValue]
#define BindDateTime(obj) obj = [DateTimeFormatter dateFromString:ElementValue]
#define BindNumberAsInt(obj)    obj = [NSNumber numberWithInteger:[ElementValue integerValue]]
#define BindNumberAsBool(obj)   obj = [NSNumber numberWithBool:[ElementValue boolValue]]
#define BindInt(obj)      obj = [ElementValue intValue]
#define BindFloat(obj)    obj = [ElementValue floatValue]
#define BindDouble(obj)   obj = [ElementValue doubleValue]


@interface IMAbstractParser : NSObject <NSXMLParserDelegate, ParserInterface>
{
    IMAbstractManager* ObjectManager;
    NSDictionary *AttributesDict;
    NSString *ElementValue;
    NSString *ElementName;
    NSXMLParser *Parser;
    NSMutableArray *Items;
    NSError *Error;
    NSDateFormatter *DateTimeFormatter;
    NSDateFormatter *DateFormatter;
    
    id UserInfo;
}

@end

#pragma mark - Protected

@interface IMAbstractParser ()


- (void)Initialize;

- (void)DidStartElement;
- (void)DidEndElement;
- (void)DidEndDocument;

- (NSString *)GetDateTimeFormat;
- (NSString *)GetDateFormat;


@end
