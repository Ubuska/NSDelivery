//
// Created by PayOnline on 05.06.14.
// Copyright (c) 2014 PayOnline. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
* Информация, возвращаемая платежной системой, для прохождения проверки на стороне банка-эмитента
*/
@interface PayOnlineThreeDsData : NSObject<NSCopying>

/** Запрос на аутентификацию плательщика */
@property(nonatomic, copy) NSString* pareq;

/** Страница сайта банка-эмитента */
@property(nonatomic, copy) NSString* acsurl;

/** Информация о мерчанте */
@property(nonatomic, copy) NSString* pd;

@end