//
//  IMOperationCheckBonuses.m
//  Delivery
//
//  Created by Peter on 26/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMOperationCheckBonuses.h"
#import "IMBonusManager.h"
#import "IMProductManager.h"
#import "IMBonus.h"
#import "IMProduct.h"
#import "Tools.h"

@implementation IMOperationCheckBonuses

 NSURLConnection*  Connection;

- (void) InitializeWithNumber:(NSString*)Number
{
    PhoneNumber = Number;
    
    
}

- (void) main
{
    

    
    
    NSURL *url = [NSURL URLWithString:[Tools GetServerRequestURL]];
    Request = [NSURLRequest requestWithURL:url];

    Params = [[NSDictionary alloc]
                            initWithObjectsAndKeys:
                            @"phone", PhoneNumber,
                            @"query", @"bonuses",
                            @"application", @"1",nil];
    
    
    
    [self performSelectorOnMainThread:@selector(PerformConnection) withObject:nil waitUntilDone:YES];
    
       


}

- (void) PerformConnection
{
    [self ConnectionPOST:Request WithParams:Params];
}

- (BOOL)ConnectionPOST:(NSURLRequest *)aRequest
            WithParams:(NSDictionary *)aDictionary
{
    
    if ([aDictionary count] > 0)
    {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                        initWithURL:[aRequest URL]];
        request.timeoutInterval = 10;
        [request setHTTPMethod:@"POST"];
        
        NSMutableString *postString = [[NSMutableString alloc] init];
        NSArray *allKeys = [aDictionary allKeys];
        for (int i = 0; i < [allKeys count]; i++) {
            NSString *key = [allKeys objectAtIndex:i];
            NSString *value = [aDictionary objectForKey:key];
            [postString appendFormat:( (i == 0) ? @"%@=%@" : @"&%@=%@" ), value, key];
        }
        
        [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        Connection = [NSURLConnection connectionWithRequest:request delegate:self];
        
        if (Connection)
        {
            // соединение началось
            NSLog(@"Connecting...");
            // создаем NSMutableData, чтобы сохранить полученные данные
            ReceivedData = [NSMutableData data];
            
        }
        else
        {
            // при попытке соединиться произошла ошибка
            NSLog(@"Connection error!");
        }

        
        
        return YES;
    }
    else
    {
        return NO;
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // получен ответ от сервера
    [ReceivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // добавляем новые данные к receivedData
    [ReceivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // освобождаем соединение и полученные данные
    //[connection release];
    //[receivedData release];
    
    // выводим сообщение об ошибке
    NSString *errorString = [[NSString alloc] initWithFormat:@"Connection failed! Error - %@ %@ %@",
                             [error localizedDescription],
                             [error description],
                             [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]];
    NSLog(errorString);
    
    //[errorString release];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError* JSONError;
    // данные получены
    // здесь можно произвести операции с данными
    
    // можно узнать размер загруженных данных
    //NSString *dataString = [[NSString alloc] initWithFormat:@"Received %d bytes of data",[receivedData length]];
    
    // если ожидаемые полученные данные - это строка, то можно вывести её
    NSString *dataString = [[NSString alloc] initWithData:ReceivedData encoding:NSUTF8StringEncoding];
    
    NSDictionary* ReceivedJSON = [NSJSONSerialization JSONObjectWithData:ReceivedData options:0 error:&JSONError];
    //NSMutableArray *Bonuses = [[NSMutableArray alloc] init];
   
    
    NSArray *BonusesResults = [ReceivedJSON valueForKey:@"bonuses"];
    NSLog(@"Count %d", BonusesResults.count);
    
    for (NSDictionary *Bonus in BonusesResults)
    {
        NSString* Counter = [Bonus valueForKey:@"counter"];
        NSString* Award = [Bonus valueForKey:@"award"];
        NSString* BonusId = [Bonus valueForKey:@"bonus_id"];
        NSString* Sum = [Bonus valueForKey:@"sum"];
        
        IMBonus* Bonus = [BonusManager GetItemById:[BonusId intValue]];
        [Bonus SetQuantity:[Counter intValue]];
        [Bonus SetSum:[Sum intValue]];
        [Bonus SetAward:Award];
        //NSObject *group = [[NSObject alloc] init];
        /*
        for (NSString *key in groupDic) {
            if ([group respondsToSelector:NSSelectorFromString(key)]) {
                [group setValue:[groupDic valueForKey:key] forKey:key];
            }
        }*/
        
        //[Bonuses addObject:group];
    }
    
    
    
    
    
    
    
    if (JSONError)
    {
        NSLog(@"JSON ERROR: %@", [JSONError localizedDescription]);
    }
    else
    {
        NSLog(@"No JSON Parsing Errors");
    }
    
    NSLog(@"Received Data:");
    NSLog(dataString);
    
     AudioServicesPlaySystemSound(1054);
    
    [_InstigatorUpdateDelegate FinishLoading];
    
    // освобождаем соединение и полученные данные
    //[connection release];
    //[receivedData release];
   // [dataString release];
}

@end
