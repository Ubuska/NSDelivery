//
//  IMPaymentSystemPayOnline.m
//  Delivery
//
//  Created by Peter on 06/07/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMPaymentSystemPayOnline.h"
#import "PayOnlineConfiguration.h"
#import "PayOnlinePayRequest.h"
#import "PayOnlineProcessing.h"
#import "Tools.h"

@implementation IMPaymentSystemPayOnline

#pragma mark - PaymentSystem Delegate Methods

- (void) Initialize
{
    // Создать объект конфигурации PayOnlineConfiguration:
    
}

- (void) CommitPurchase:(id<PaymentInstigator>) Delegate
{
    PaymentInstigatorDelegate = Delegate;
    PayOnlineConfiguration* PayOnlineConfig = [PayOnlineConfiguration configurationWithMerchantId:70824 privateKey: @"af81b099-5ed5-4a88-8a34-4a94aecbbdb1"];
    
   /*
    // Создать объект платежа PayOnlinePayRequest:
    PayOnlinePayRequest *PayRequest = [[PayOnlinePayRequest alloc] init];
    PayRequest.email = @"petr.gubin@gmail.com";
    PayRequest.cardNumber = @"4111111111111111";
    PayRequest.ip = [Tools GetIPAddress];
    PayRequest.cardExpMonth = 10;
    PayRequest.cardExpYear = 2016;
    PayRequest.cardHolderName = @"PETR GUBIN";
    PayRequest.cardCvv = 123;
    PayRequest.amount = [NSDecimalNumber decimalNumberWithString:@"120.00"];
    PayRequest.currency = PayOnlineCurrencyRub;
    PayRequest.orderId = @"938g9fjkd04kd9";
    
    */

    // Создать объект PayOnlineProcessing на основе конфигурации среды выполнения и вызвать метод pay:
    PayOnlineProcessing *Processing = [PayOnlineProcessing processingWithConfig:PayOnlineConfig];
    [Processing pay:_Request delegate:self];
}

#pragma mark - PayOnline Delegate Methods

- (void) payOnlineSuccess:(PayOnlinePayResponse *)response
{
    [PaymentInstigatorDelegate PaymentSuccess];
}

- (void) payOnlineDeclined:(PayOnlinePayResponse *)response
{
    [PaymentInstigatorDelegate PaymentFail:@"Оплата отклонена"];
}

- (void) payOnlineThreeDsRequired:(PayOnlinePayResponse *)response
{
    NSLog(@"Test");
    //UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    //[self.view addSubview:webView];
    // открываем страницу банка-эмитента во встроенном браузере [self.processing navigateToAcsUrl:response delegate:self webView:webView]; }
}

- (void) payOnlineError:(PayOnlineError *)error
{
    [PaymentInstigatorDelegate PaymentFail:@"Проверьте введенные данные, либо интернет соединение."];
}

@end
