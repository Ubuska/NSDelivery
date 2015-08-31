//
//  IMOperationRequestDiscount.m
//  Delivery
//
//  Created by Peter on 07/08/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMOperationRequestDiscount.h"
#import "Tools.h"
#import "IMDiscountManager.h"
#import "IMOperationRequestCardDiscount.h"
#import "IMSectionManager.h"
#import "Section.h"
#import "IMDiscountParser.h"

@implementation IMOperationRequestDiscount

- (void) main
{
    Params = [[NSDictionary alloc] initWithObjectsAndKeys:
            @"query", @"discount_type",
            @"application", @"1",nil];
    [super main];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}

// First request, requesting discount type.

// Here we requesting discount system active on a server.
// If we use outsum, we need to parse XML data from FTP.
// If we use card discounts, we have to send another request to server.

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSError* JSONError;
    NSDictionary* ReceivedJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONError];
    
    NSNumber* StatusNumber = [ReceivedJSON valueForKey:@"success"];
    int SuccessStatus = [StatusNumber intValue];
    
    if (SuccessStatus == 1)
    {
        NSString* DiscountTypeString = [ReceivedJSON valueForKey:@"discount_type"];
        
        
        if ([DiscountTypeString isEqualToString:@"outsum"])
        {
            [DiscountManager SetDiscountType:EDT_Outsum];
            // Get XML data from server
            NSData* DiscountsData = [self ObtainXML];
            
            // Parse actual obtained XML data.
            if (DiscountsData != NULL && DiscountsData.length > 0)
            {
                IMDiscountParser* DiscountParser = [IMDiscountParser new];
                [DiscountParser ParseData:DiscountsData Manager:DiscountManager];
                [self.NotificationsRecieverDelegate OperationComplete];
            }
            else [self.NotificationsRecieverDelegate OperationFailed:@"Ошибка при загрузке скидок."];

        }
        else if ([DiscountTypeString isEqualToString:@"card"])
        {
            [DiscountManager SetDiscountType:EDT_Card];
            // Send another request
            IMOperationRequestCardDiscount* CardDiscountRequest = [IMOperationRequestCardDiscount new];
            CardDiscountRequest.NotificationsRecieverDelegate = self;
            //[CardDiscountRequest Initialize:self];
            [CardDiscountRequest start];
        }
    }
}

- (void)OperationComplete
{
    
}

- (void)OperationReceivedResponse:(NSURLResponse *)Response
{
    
    
}

- (void)OperationReceivedData:(NSMutableData *)ReceivedData
{
    
    NSError* JSONError;
    NSDictionary* ReceivedJSON = [NSJSONSerialization JSONObjectWithData:ReceivedData options:0 error:&JSONError];
    
    NSNumber* StatusNumber = [ReceivedJSON valueForKey:@"success"];
    int SuccessStatus = [StatusNumber intValue];
    
    if (SuccessStatus == 1)
    {
        // Second request to server (we requesting card discount amount).
        [DiscountManager SetCardDiscountAmount:[ReceivedJSON valueForKey:@"discount"]];
        [DiscountManager SetCardNumber:[ReceivedJSON valueForKey:@"card_number"]];
        [DiscountManager SetCardImageURL:[ReceivedJSON valueForKey:@"card_url"]];
        
        // Also we need to create menu item for Discount Card.
        Section* DiscountSection = [Section new];
        [DiscountSection SetName:@"Скидки"];
        [DiscountSection SetSectionManagerHandler:[DiscountManager class]];
        [SectionManager AddItem:DiscountSection];

        [self.NotificationsRecieverDelegate OperationComplete];
    }
}

- (void)OperationFailed:(NSString *)Error
{
    
}

- (NSData*) ObtainXML
{
    NSString *Path = [[NSBundle mainBundle] pathForResource:@"URL" ofType:@"plist"];
    NSDictionary *Dictionary = [[NSDictionary alloc] initWithContentsOfFile:Path];
    NSString *ServerRequestURL = [Dictionary objectForKey:@"Discounts"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:ServerRequestURL]];
    
    NSURLResponse *response = NULL;
    NSError *error = NULL;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if ([data length] >0 && error == nil)
    {
        return data;
    }
    return NULL;
}


@end
