//
//  IMAboutUsManager.m
//  Delivery
//
//  Created by Peter on 05/08/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMAboutUsManager.h"
#import "IMAboutData.h"

@implementation IMAboutUsManager

- (void) InitializeManager
{
}
- (void) InsertItem:(NSObject*) ItemToInsert AtIndex:(NSUInteger)InsertIndex
{
    [DataContainer insertObject:ItemToInsert atIndex:InsertIndex];
}

- (void) AddItem:(NSObject*) ItemToAdd;
{
    
    IMAboutData* AboutUsItem = (IMAboutData*) ItemToAdd;
    if ([AboutUsItem isKindOfClass:[IMAboutData class]])
    {
        [DataContainer addObject:ItemToAdd];
    }
}

- (id) GetItemByIndex:(int) ItemIndex
{
    return DataContainer[ItemIndex];
}


- (NSUInteger) GetItemsCount
{
    return [DataContainer count];
}



- (void) ClearAll
{
    [DataContainer removeAllObjects];
}

- (UIImage*) GetCachedImage:(NSString*)URL
{
    return [CachedSliderImages objectForKey:URL];
}
- (void) CacheImage:(UIImage*) ImageToCache ImageURL:(NSString*)URL
{
    [CachedSliderImages setObject:ImageToCache forKey:URL];
}

@end
