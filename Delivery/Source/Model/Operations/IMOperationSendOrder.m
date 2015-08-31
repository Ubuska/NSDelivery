//
//  IMOperationSendOrder.m
//  Delivery
//
//  Created by Peter on 23/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMOperationSendOrder.h"
#import "XMLOrderCreator.h"
#import "IMCartManager.h"

@implementation IMOperationSendOrder

- (id)initWithData:(IMUserData*)Data
{
    UserData = Data;
    return self;
}

- (void)main
{
    // Create XML NSString
    XMLOrderCreator* XMLCreator = [XMLOrderCreator new];
    NSString* OrderXML = [XMLCreator CreateXML:UserData];
    
    // Get current date
    
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd_MM_yyyy_HH_mm"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    
    // Specify a custom upload file name
    NSString *FileName = [[@"orderdata_" stringByAppendingString:dateString] stringByAppendingString:@".xml"];
    
    
    // Saving XML NSString to file
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *FilePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, FileName];
    NSLog(@"filePath %@", FilePath);
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:FilePath])
    {
        // if file is not exist, create it.
        NSError *error;
        [OrderXML writeToFile:FilePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    }
    
    // Upload obtained FilePath via UploadFile method
    [self UploadFile:FileName FilePath:FilePath];
}

- (void) UploadFile:(NSString*)FileName FilePath:(NSString*)UploadPath
{
    NSString *Path = [[NSBundle mainBundle] pathForResource:@"FTP" ofType:@"plist"];
    
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:Path];
    NSString *ProductURL = [dictionary objectForKey:@"URL"];
    
    
    FTPRequest = [[SCRFTPRequest alloc] initWithURL:[NSURL URLWithString:ProductURL]
                                       toUploadFile:UploadPath];
    
    
    FTPRequest.username = [dictionary objectForKey:@"Username"];
    FTPRequest.password = [dictionary objectForKey:@"Password"];
    
    

    FTPRequest.customUploadFileName = FileName;
    
    // The delegate must implement the SCRFTPRequestDelegate protocol
    FTPRequest.delegate = self;
    [FTPRequest start];
}

- (void) UpdateBonusesOnServer
{
    NSString *Path = [[NSBundle mainBundle] pathForResource:@"URL" ofType:@"plist"];
    NSDictionary *Dictionary = [[NSDictionary alloc] initWithContentsOfFile:Path];
    NSString *TokenRequestURL = [Dictionary objectForKey:@"BonusesRequest"];
    
    NSURL *URL = [NSURL URLWithString:TokenRequestURL];
    BonusesUpdateRequest = [NSURLRequest requestWithURL:URL];
    
    Params = [[NSDictionary alloc]
              initWithObjectsAndKeys:
              @"query", @"update_bonus",
              @"application", @"1",nil];
    if ([Params count] > 0)
    {
        NSMutableURLRequest *ActualRequest = [[NSMutableURLRequest alloc]
                                        initWithURL:[BonusesUpdateRequest URL]];
        [ActualRequest setHTTPMethod:@"POST"];
        
        NSMutableString *PostString = [[NSMutableString alloc] init];
        NSArray *allKeys = [Params allKeys];
        for (int i = 0; i < [allKeys count]; i++)
        {
            NSString *key = [allKeys objectAtIndex:i];
            NSString *value = [Params objectForKey:key];
            [PostString appendFormat:( (i == 0) ? @"%@=%@" : @"&%@=%@" ), value, key];
        }
        
        [ActualRequest setHTTPBody:[PostString dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [NSURLConnection connectionWithRequest:ActualRequest delegate:nil];
    }
    
}


// Required delegate methods
- (void)ftpRequestDidFinish:(SCRFTPRequest *)request
{
    NSLog(@"Upload finished.");
    [CartManager ClearAll];
    // Update bonuses on server manually!
    [self UpdateBonusesOnServer];
    [_ProgressUpdateDelegate UpdateProgress:1.0f];
    [_ProgressUpdateDelegate FinishLoading];
}


- (void)ftpRequest:(SCRFTPRequest *)request didFailWithError:(NSError *)error
{
    [_ProgressUpdateDelegate FailedLoading];
    /*NSLog(@"Upload failed: %@", [error localizedDescription]);
    UIAlertView *Alert = [[UIAlertView new] initWithTitle:@"Ошибка" message:@"Не удалось подключиться" delegate:nil cancelButtonTitle:@"Назад" otherButtonTitles:nil, nil];
    [Alert show];*/
}

// Optional delegate methods
- (void)ftpRequestWillStart:(SCRFTPRequest *)request
{
    //NSLog(@"Will transfer %lld bytes.", request.fileSize);
    [_ProgressUpdateDelegate UpdateProgress:0.1f];
    
}

- (void)ftpRequest:(SCRFTPRequest *)request didWriteBytes:(NSUInteger)bytesWritten
{
    
    //NSLog(@"Transferred: %d", bytesWritten);
    [_ProgressUpdateDelegate UpdateProgress:0.6f];
}

- (void)ftpRequest:(SCRFTPRequest *)request didChangeStatus:(SCRFTPRequestStatus)status
{
    
    switch (status)
    {
        case SCRFTPRequestStatusOpenNetworkConnection:
            NSLog(@"Opened connection.");
            [_ProgressUpdateDelegate UpdateProgress:0.5f];
            break;
        case SCRFTPRequestStatusReadingFromStream:
            NSLog(@"Reading from stream...");
            [_ProgressUpdateDelegate UpdateProgress:0.6f];
            break;
        case SCRFTPRequestStatusWritingToStream:
            NSLog(@"Writing to stream...");
            [_ProgressUpdateDelegate UpdateProgress:0.8f];
            break;
        case SCRFTPRequestStatusClosedNetworkConnection:
            [_ProgressUpdateDelegate UpdateProgress:0.9f];
            NSLog(@"Closed connection.");
            break;
        case SCRFTPRequestStatusError:
        {
            
        }
            break;
        case SCRFTPRequestStatusNone:
        {
            NSLog(@"Error occurred - NONE.");
           // UIAlertView *Alert = [[UIAlertView new] initWithTitle:@"Ошибка" message:@"Не удалось подключиться" delegate:nil /cancelButtonTitle:@"Назад" otherButtonTitles:nil, nil];
           // [Alert show];
        }
            
            break;
            
    }
}

@end
