//
//  UIImage+Helpers.h
//  Delivery
//
//  Created by Peter on 05/08/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

@interface UIImage( Helpers )

+ (void) LoadFromURL: (NSURL*) url callback:(void (^)(UIImage *image))callback;
@end
