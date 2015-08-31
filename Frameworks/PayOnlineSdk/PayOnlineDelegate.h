//
// Created by PayOnline on 04.06.14.
// Copyright (c) 2014 PayOnline. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PayOnlineError;
@class PayOnlinePayResponse;

/**
Протокол обработчика результатов проведения платежа
*/
@protocol PayOnlineDelegate <NSObject>

@required

/** Авторизация прошла успешно */
- (void)payOnlineSuccess:(PayOnlinePayResponse *)response;

/** Отказ в авторизации средств */
- (void)payOnlineDeclined:(PayOnlinePayResponse *)response;

/** Необходимо пройти проверку 3DS */
- (void)payOnlineThreeDsRequired:(PayOnlinePayResponse *)response;

/** Ошибка при выполнении запроса */
- (void)payOnlineError:(PayOnlineError *)error;

@end