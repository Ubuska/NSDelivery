//
//  IMAbstractOperation.m
//  Delivery
//
//  Created by Peter on 07/08/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMAbstractOperation.h"
#import "Tools.h"

@implementation IMAbstractOperation

- (void) main
{
    //[self performSelectorOnMainThread:@selector(PerformConnection) withObject:nil waitUntilDone:YES];
  // if (![self ConnectionPOST]) [self.NotificationsRecieverDelegate OperationFailed:@"Connection Error"];
    [self performSelectorOnMainThread:@selector(PerformConnection) withObject:nil waitUntilDone:YES];
}

- (void) PerformConnection
{
    [self ConnectionPOST];
    //if ([self ConnectionPOST]) [self.NotificationsRecieverDelegate OperationComplete];
    //else [self.NotificationsRecieverDelegate OperationFailed:@"Connection Error"];
    //if (![self ConnectionPOST]) [self.NotificationsRecieverDelegate OperationFailed:@"Connection Error"];
}

- (BOOL) ConnectionPOST;
{
    
    NSURL *RequestURL = [NSURL URLWithString:[Tools GetServerRequestURL]];
    Request = [NSURLRequest requestWithURL:RequestURL];
    if ([Params count] > 0)
    {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                        initWithURL:[Request URL]];
        request.timeoutInterval = 10;
        [request setHTTPMethod:@"POST"];
        
        NSMutableString *postString = [[NSMutableString alloc] init];
        NSArray *allKeys = [Params allKeys];
        for (int i = 0; i < [allKeys count]; i++)
        {
            NSString *key = [allKeys objectAtIndex:i];
            NSString *value = [Params objectForKey:key];
            [postString appendFormat:( (i == 0) ? @"%@=%@" : @"&%@=%@" ), value, key];
        }
        
        [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        Connection = [NSURLConnection connectionWithRequest:request delegate:self];
        [Connection scheduleInRunLoop:[NSRunLoop mainRunLoop]
                              forMode:NSDefaultRunLoopMode];
        
        if (Connection)
        {
            // соединение началось
            NSLog(@"Connecting...");
            Data = [NSMutableData dataWithCapacity:0];
            // создаем NSMutableData, чтобы сохранить полученные данные
            
            
        }
        else
        {
            // при попытке соединиться произошла ошибка
            NSLog(@"Connection error!");
            [self.NotificationsRecieverDelegate OperationFailed:@"Connection Error"];
        }
        
        
        
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL) isConcurrent
{
    return YES;
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    [self.NotificationsRecieverDelegate OperationReceivedResponse:response];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    Data = [data copy];
    [self.NotificationsRecieverDelegate OperationReceivedData:Data];
}


- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // выводим сообщение об ошибке
    NSString *ErrorString = [[NSString alloc] initWithFormat:@"Connection failed! Error - %@ %@ %@",
                             [error localizedDescription],
                             [error description],
                             [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]];
    [self.NotificationsRecieverDelegate OperationFailed:ErrorString];

}




@end
