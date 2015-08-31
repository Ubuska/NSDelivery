//
//  IMAbstractManager.h
//  Delivery
//
//  Created by Peter on 08/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Protocols.h"

typedef double Money;

@interface IMAbstractManager : NSObject <ManagerInterface>
{
    NSMutableArray* DataContainer;
}

@end
@interface IMAbstractManager()

+ (instancetype)SharedInstance;
+ (instancetype)Instance;
+ (void)DestroyInstance;

- (void) InitializeManager;

@property (assign, readonly) BOOL bIsInitialized;

@end