//
//  Tools.m
//  Delivery
//
//  Created by Peter on 02/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "Tools.h"
#include <ifaddrs.h>
#include <arpa/inet.h>


@implementation Tools

+ (UIColor *)ColorWithHexString:(NSString *)StringToConvert
{
    NSString *NoHashString = [StringToConvert stringByReplacingOccurrencesOfString:@"#" withString:@""]; // remove the #
    NSScanner *Scanner = [NSScanner scannerWithString:NoHashString];
    [Scanner setCharactersToBeSkipped:[NSCharacterSet symbolCharacterSet]]; // remove + and $
    
    unsigned Hex;
    if (![Scanner scanHexInt:&Hex]) return nil;
    int r = (Hex >> 16) & 0xFF;
    int g = (Hex >> 8) & 0xFF;
    int b = (Hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f];
}

+ (BOOL) IsEmailValid:(NSString*) Email
{
    NSString *EmailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *EmailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", EmailRegex];
    
    return [EmailTest evaluateWithObject:Email];
}

+ (BOOL) CanCreateDrawerButton
{
    
    // iPad
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return NO;
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            return YES;
        }
        else if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)
        {
            return NO;
        }
    }
    
    // iPhone
    else
    {
        return YES;
    }
    return NO;
    
}


+ (NSString*) GetIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}


+ (NSString *)GetMonthByIndex:(NSUInteger)Index
{
    NSString * DateString = [NSString stringWithFormat: @"%d", Index];
    NSDateFormatter* DateFormatter = [[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"MM"];
    NSDate* MonthDate = [DateFormatter dateFromString:DateString];
    
    NSDateFormatter *Formatter = [[NSDateFormatter alloc] init];
    [Formatter setDateFormat:@"MMMM"];
    NSString *StringFromMonthDate = [Formatter stringFromDate:MonthDate];
    return StringFromMonthDate;
}

+ (NSString *) GenerateUniqueUUID
{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    NSString *uuidStr = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return uuidStr;
}

+ (NSString *) GetServerRequestURL
{
    NSString *Path = [[NSBundle mainBundle] pathForResource:@"URL" ofType:@"plist"];
    NSDictionary *Dictionary = [[NSDictionary alloc] initWithContentsOfFile:Path];
    NSString *ServerRequestURL = [Dictionary objectForKey:@"ServerRequest"];
    return ServerRequestURL;
}


+ (NSString*) GetUserPhoneNumber
{
    NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
    NSString *UserPhoneNumber = [Defaults objectForKey:@"UserPhoneNumber"];
    return UserPhoneNumber;
}

+ (Money) GetPriceWithDiscount:(NSString*)Price Discount:(NSInteger)Discount
{
    Money ProductPrice = [Price doubleValue];
    Money DiscountAmount = (Money) Discount;
    Money ModifiedPriceDelta = (DiscountAmount / 100) * ProductPrice;
    Money FinalPrice = ProductPrice - ModifiedPriceDelta;
    return FinalPrice;
}
@end
