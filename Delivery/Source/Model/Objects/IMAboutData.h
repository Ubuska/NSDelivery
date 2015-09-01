//
//  IMAboutData.h
//  Delivery
//
//  Created by Peter on 06/08/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMItem.h"

@interface IMAboutData : IMItem
{
    NSMutableArray* SliderImages;
}

- (void) Initialize;
- (NSString*) GetImageURLByIndex:(NSInteger)Index;
- (void) AddImageURL:(NSString*)URL;
- (NSInteger) GetImagesCount;

@end
