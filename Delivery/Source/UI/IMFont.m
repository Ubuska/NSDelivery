//
//  IMFont.m
//  Delivery
//
//  Created by Peter on 02/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMFont.h"

@implementation IMFont 


+ (UIFont *)RegularFontOfSize:(CGFloat)Size
{
    return [UIFont fontWithName:@"HelveticaNeue-Thin"
                           size:Size];
}
+ (UIFont *)MediumFontOfSize:(CGFloat)Size
{
    return [UIFont fontWithName:@"HelveticaNeue"
                           size:Size];
}

#pragma mark - Style fonts

+ (UIFont *)Font_Header
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return [self RegularFontOfSize:28.f];
    }
    else
    {
        return [self RegularFontOfSize:20.f];
    }
}

+ (UIFont *)Font_SectionHeader
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return [self RegularFontOfSize:33.f];
    }
    else
    {
        return [self RegularFontOfSize:23.f];
    }
}

+ (UIFont *)Font_RegularText
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return [self RegularFontOfSize:20.f];
    }
    
    // iPhone normal text
    else
    {
        return [self RegularFontOfSize:15.f];
    }
}


@end
