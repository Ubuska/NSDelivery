//
//  PayOnlineConfiguration.h
//  PayOnlineSdk
//
//  Created by PayOnline on 02.06.14.
//  Copyright (c) 2014 PayOnline. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
Конфигурация среды выполнения
*/
@interface PayOnlineConfiguration : NSObject<NSCopying>

/** ID мерчанта, полученный при регистрации */
@property(nonatomic) NSInteger merchantId;

/** Приватный ключ, которым подписываются запросы */
@property(nonatomic, copy) NSString* privateKey;

/** Хост платежного шлюза */
@property(nonatomic, copy) NSString* host;

- (instancetype)initWithMerchantId:(NSInteger)merchantId privateKey:(NSString *)privateKey host:(NSString *)host;

+ (instancetype)configurationWithMerchantId:(NSInteger)merchantId privateKey:(NSString *)privateKey host:(NSString *)host;

- (id)copyWithZone:(NSZone *)zone;

+ (instancetype)configurationWithMerchantId:(NSInteger)merchantId privateKey:(NSString *)privateKey;


@end
