//
//  IMAboutData.m
//  Delivery
//
//  Created by Peter on 06/08/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMAboutData.h"

@implementation IMAboutData


- (void) Initialize
{
    SliderImages = [NSMutableArray arrayWithCapacity:0];
}
- (NSString*) GetImageURLByIndex:(NSInteger)Index
{
    return SliderImages[Index];
}
- (void) AddImageURL:(NSString*)URL
{
    [SliderImages addObject:URL];
}

- (NSInteger) GetImagesCount
{
    return SliderImages.count;
}
@end
