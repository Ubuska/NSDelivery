//
//  IMOperationParse.m
//  Delivery
//
//  Created by Peter on 03/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMOperationParse.h"
#import "IMAppDelegate.h"

@implementation IMOperationParse

// From UI
- (id)initWithData:(NSURL*)url ManagerInstance:(IMAbstractManager*) ObjectManager ParserInstance:(IMAbstractParser*) ObjectParser
{
    if (self = [super init])
        URL = url;
        Manager = ObjectManager;
        Parser = ObjectParser;
    return self;
}


// Background
- (void)main
{

    [Manager ClearAll];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLResponse *response = NULL;
    NSError *error = NULL;

    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                            if ([data length] >0 && error == nil)
                        {
                            
                            NSString *result = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
                            
                            if (data == NULL) //&& d != NULL && ![self isCancelled])
                            {
                                [self performSelectorOnMainThread:@selector(ParsingOperationDidFinishWithError)  withObject:nil waitUntilDone:YES];
                                //[d performSelectorOnMainThread:@selector(rssFetchOperationDidFailedWithError:) withObject:error waitUntilDone:NO];
                            }
                            else
                            {
                                [Parser ParseData:data Manager:Manager];
                               // [self ParsingOperationDidFinishWithItems];
                                //[self performSelectorOnMainThread:@selector(ParsingOperationDidFinishWithItems) withObject:nil];
                                [self performSelectorOnMainThread:@selector(ParsingOperationDidFinishWithItems)  withObject:nil waitUntilDone:YES];
                                //IMProductParser *parser = [IMProductParser new];
                                //[parser ParseData:data Manager:Manager];
                            }

                            
                        }
                        else
                        {
                            if (error)
                            {
                                [self performSelectorOnMainThread:@selector(ParsingOperationDidFinishWithError)  withObject:nil waitUntilDone:YES];
                            }
                            return;
                        }

}


// Main Thread
- (void) ParsingOperationDidFinishWithItems
{
    NSLog(@"Finished Operation : %@", Parser.class );    
    [self.NotificationsRecieverDelegate OperationComplete];
}

- (void) ParsingOperationDidFinishWithError
{
    NSLog(@"Operation throwed error : %@", Parser.class );
    [self.NotificationsRecieverDelegate OperationFailed:@"Parse Error"];
}




@end
