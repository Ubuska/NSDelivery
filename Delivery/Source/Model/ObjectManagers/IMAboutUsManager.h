//
//  IMAboutUsManager.h
//  Delivery
//
//  Created by Peter on 05/08/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMAbstractManager.h"

#define AboutUsManager [IMAboutUsManager SharedInstance]

@interface IMAboutUsManager : IMAbstractManager
{
    NSCache* CachedSliderImages;
}

- (UIImage*) GetCachedImage:(NSString*)URL;
- (void) CacheImage:(UIImage*) ImageToCache ImageURL:(NSString*)URL;

@end
