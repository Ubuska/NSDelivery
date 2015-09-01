//
//  IMOperationSendOrder.h
//  Delivery
//
//  Created by Peter on 23/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMUserData.h"
#import "SCRFTPRequest.h"
#import "Protocols.h"

@interface IMOperationSendOrder : NSOperation <SCRFTPRequestDelegate>
{
    IMUserData* UserData;
    SCRFTPRequest* FTPRequest;
    
    NSDictionary *Params;
    NSURLRequest *BonusesUpdateRequest;
}

- (id)initWithData:(IMUserData*)Data;
@property (weak) id<UpdateProgress> ProgressUpdateDelegate;

@end
