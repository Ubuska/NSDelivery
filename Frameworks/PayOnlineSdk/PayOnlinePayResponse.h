//
// Created by PayOnline on 04.06.14.
// Copyright (c) 2014 PayOnline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PayOnlineProcessing.h"

@class PayOnlineThreeDsData;

/**
* Результат выполнения авторизации денежных средств на банковской карте
*/
@interface PayOnlinePayResponse : NSObject

/** ID трансакции в системе PayOnline */
@property(nonatomic) long transactionId;

/** Результат выполнения операции */
@property(nonatomic) enum PayOnlineResult result;

/** Код ответа */
@property(nonatomic) NSInteger code;

/** Статус трансакции */
@property(nonatomic) enum PayOnlineStatus status;

/** Информация, возвращаемая платежной системой, для прохождения проверки на стороне банка эмитента */
@property(nonatomic, copy) PayOnlineThreeDsData *threeDsData;

/** Код ошибки, если она произошла в момент обработки запроса */
@property(nonatomic) NSInteger errorCode;

@end