//
//  PayOnlinePayRequest.h
//  PayOnlineSdk
//
//  Created by PayOnline on 02.06.14.
//  Copyright (c) 2014 PayOnline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PayOnlineProcessing.h"

/**
* Запрос на авторизацию средств на карте плательщика
*/
@interface PayOnlinePayRequest : NSObject<NSCopying>

/** ID заказа в вашей системе */
@property(nonatomic, copy) NSString *orderId;

/** Сумма платежа */
@property(nonatomic, copy) NSDecimalNumber *amount;

/** Валюта платежа */
@property(nonatomic) enum PayOnlineCurrency currency;

/** Электронная почта плательщика */
@property(nonatomic, copy) NSString *email;

/** Имя держателя карты, указанное на банковской карте */
@property(nonatomic, copy) NSString *cardHolderName;

/** Номер банковской карты, указанный на банковской карте */
@property(nonatomic, copy) NSString *cardNumber;

/** IP адрес плательщика */
@property(nonatomic, copy) NSString *ip;

/** Месяц окончания действия банковской карты */
@property(nonatomic) NSInteger cardExpMonth;

/** Год окончания действия банковской карты */
@property(nonatomic) NSInteger cardExpYear;

/** Секретный код, указанный на обратной стороне банковской карты */
@property(nonatomic) NSInteger cardCvv;

@end
