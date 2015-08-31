//
//  IMAbstractManager.m
//  Delivery
//
//  Created by Peter on 08/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMAbstractManager.h"

// Dictionary that holds all instances of DOSingleton subclasses
static NSMutableDictionary *SharedInstances = nil;

@implementation IMAbstractManager

#pragma mark -
- (void) InitializeManager{}
- (void) ClearAll{}

+ (void)Initialize
{
    if (SharedInstances == nil)
    {
        SharedInstances = [NSMutableDictionary dictionary];
    }
}

+ (id)allocWithZone:(NSZone *)zone
{
    // Not allow allocating memory in a different zone
    return [self SharedInstance];
}

+ (id)copyWithZone:(NSZone *)zone
{
    // Not allow copying to a different zone
    return [self SharedInstance];
}

#pragma mark -

+ (instancetype)SharedInstance
{
    id sharedInstance = nil;
    
    @synchronized(self)
    {
        NSString *instanceClass = NSStringFromClass(self);
        
        // Looking for existing instance
        sharedInstance = [SharedInstances objectForKey:instanceClass];
        
        // If there's no instance – create one and add it to the dictionary
        if (sharedInstance == nil)
        {
            sharedInstance = [[super allocWithZone:nil] init];
            
            [SharedInstances setObject:sharedInstance forKey:instanceClass];
        }
    }
    
    return sharedInstance;
}

+ (instancetype)Instance
{
    return [self SharedInstance];
}

#pragma mark -

+ (void)DestroyInstance
{
    [SharedInstances removeObjectForKey:NSStringFromClass(self)];
}

#pragma mark -

- (id)init
{
    self = [super init];
    
    if (self && !self.bIsInitialized)
    {
        // Thread-safe because it called from +sharedInstance
        DataContainer = [NSMutableArray arrayWithCapacity:0];
        [IMAbstractManager Initialize];
        [self InitializeManager];
        _bIsInitialized = YES;
    }
    
    return self;
}

@end
