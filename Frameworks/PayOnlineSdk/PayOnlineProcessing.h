//
//  PayOnlineProcessing.h
//  PayOnlineSdk
//
//  Created by PayOnline on 02.06.14.
//  Copyright (c) 2014 PayOnline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>

@class PayOnlineConfiguration;
@class PayOnlinePayRequest;
@class PayOnlinePayResponse;
@protocol PayOnlineDelegate;

/** Список поддерживаемых валют */
typedef NS_ENUM(NSUInteger, PayOnlineCurrency) {
    /** Российский рубль */
    PayOnlineCurrencyRub = 0,

    /** Евро */
    PayOnlineCurrencyEur = 1,

    /** Доллар США */
    PayOnlineCurrencyUsd = 2,
};

/** Статус трансакции в платежной системе PayOnline */
typedef NS_ENUM(NSUInteger, PayOnlineStatus) {
    /** Успешная трансакция, деньги на карте авторизованы, но могут быть разблокированы */
    PayOnlineStatusPending = 0,

    /** Успешная трансакция, деньги авторизованы, однако необходимо подтверждение мерчанта */
    PayOnlineStatusPreAuthorized = 1,

    /** Отклоненная трансакция */
    PayOnlineStatusDeclined = 2,

    /** Успешная трансакция, операция по переводу денежных средств завершена */
    PayOnlineStatusSettled = 3,

    /** Трансакция отменена */
    PayOnlineStatusVoided = 4,

    /** Необходимо пройти проверку 3DS */
    PayOnlineStatusAwaiting3DAuthentication = 5,

    /** Неизвестный статус, возвращается, если трансакция не найдена */
    PayOnlineStatusUnknown = 6
};

/** Результат выполнения запроса к процессингову центру PayOnline */
typedef NS_ENUM(NSUInteger, PayOnlineResult) {
    /** Авторизация прошла успешно */
    PayOnlineResultSuccess = 0,

    /** В процессе выполнения запроса, произошли ошибки */
    PayOnlineResultError = 1,

    /** Запрос на авторизацию средств отклонен */
    PayOnlineResultDeclined = 2,

    /** Необходимо пройти дополнительную проверку на стороне банка-эмитента */
    PayOnlineResultCompleteValidation = 3,

    /** Трансакция не найдена */
    PayOnlineResultNotFound = 4
};

/**
* Представляет реализацию интерфейс процессингового центра PayOnline
*/
@interface PayOnlineProcessing : NSObject

/**
Операция проведения платежа

@param payRequest запрос на авторизацию средств на карте плательщика
@param delegate обработчик результата проведения платежа
*/
- (void)pay:(PayOnlinePayRequest *)payRequest delegate:(id <PayOnlineDelegate>)delegate;

/**
Переход на страницу банка-эмитента для прохождения проверки 3DS

@param payResponse полученный ранее результат выполнения авторизации
@param delegate обработчик результата прохождения проверки 3DS
*/
- (void)navigateToAcsUrl:(PayOnlinePayResponse *)payResponse delegate:(id <PayOnlineDelegate>)delegate webView:(UIWebView *)webView;

- (instancetype)initWithConfig:(PayOnlineConfiguration *)config;

+ (instancetype)processingWithConfig:(PayOnlineConfiguration *)config;


@end
