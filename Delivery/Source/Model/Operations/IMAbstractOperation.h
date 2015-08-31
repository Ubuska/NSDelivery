//
//  IMAbstractOperation.h
//  Delivery
//
//  Created by Peter on 07/08/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Protocols.h"
#import "IMOperation.h"

@interface IMAbstractOperation : IMOperation <NSURLConnectionDelegate>
{
    NSString* URL;
    NSDictionary *Params;
    NSURLRequest *Request;
    NSURLConnection*  Connection;
    NSMutableData* Data;
    BOOL bIsInitialized;
}


- (BOOL) ConnectionPOST;

- (void) Initialize:(id<OperationNotifyReceiver>) Delegate;// RequestURL:(NSString*)RequestURL RequestParams:(NSDictionary*)RequestParams;

@end
