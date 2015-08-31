//
//  IMOperationCheckBonuses.h
//  Delivery
//
//  Created by Peter on 26/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "Protocols.h"

@interface IMOperationCheckBonuses : NSOperation <NSURLConnectionDelegate>
{
    NSString* PhoneNumber;
    NSMutableData* ReceivedData;
    
    NSDictionary *Params;
    NSURLRequest *Request;
    
    SystemSoundID FinishSound;
}

- (void) InitializeWithNumber:(NSString*)Number;

@property (weak) id<UpdateProgress> InstigatorUpdateDelegate;

@end
