//
// Created by PayOnline on 04.06.14.
// Copyright (c) 2014 PayOnline. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
* Информация об ошибке, возникшей в процессе обработки запроса
*/
@interface PayOnlineError : NSObject

/** Код ошибки */
@property(nonatomic) NSInteger code;

/** Краткая информация об ошибке */
@property(nonatomic, copy) NSString* message;

- (instancetype)initWithCode:(NSInteger)code message:(NSString *)message;

+ (instancetype)errorWithCode:(NSInteger)code message:(NSString *)message;


@end