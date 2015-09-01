//
//  IMAppDelegate.m
//  Delivery
//
//  Created by Developer on 10.12.14.
//  Copyright (c) 2014 incodemobile. All rights reserved.
//

#import "IMAppDelegate.h"
#import "IMProduct.h"
#import "IMProductViewController.h"
#import "IMOperationParse.h"

#import "IMSectionManager.h"
#import "IMAddressManager.h"
#import "IMProductManager.h"
#import "IMEventManager.h"
#import "IMBonusManager.h"
#import "IMInfoManager.h"
#import "IMAboutUsManager.h"
#import "IMDiscountManager.h"

#import "IMOperationRequestDiscount.h"
#import "IMOperationRequestCardDiscount.h"

@implementation IMAppDelegate
BOOL bIsFinished;

int FinishedOperationsCount;


// @protocol OperationNotifyReceiver <NSObject>
- (void) OperationComplete
{
    FinishedOperationsCount ++;
    [self performSelectorOnMainThread:@selector(UpdateProgress) withObject:nil waitUntilDone:NO];
}
- (void) OperationFailed:(NSString *)Error
{
    [Queue cancelAllOperations];
    bError = NO;
    UIAlertView *Alert = [[UIAlertView new] initWithTitle:@"Ошибка соединения" message:Error delegate:self cancelButtonTitle:@"Попробовать снова" otherButtonTitles:nil, nil];
    [Alert show];
    
    return;
}

- (BOOL) IsRegularStartup
{
    if (_NotificationEvent || _NotificationProduct)
        {
            [_NotificationResponderDelegate TransitionFromNotification];
            return false;
        }
    return true;
}

- (void) FinishLoading { [_ProgressUpdateDelegate FinishLoading]; }


- (void) UpdateProgress
{
    float FinishedOperations = [[NSNumber numberWithInt: [Operations count]] floatValue];
    float FinishedOperationsCountFloat = [[NSNumber numberWithInt: FinishedOperationsCount] floatValue];
    float ProgressFloat = (FinishedOperationsCountFloat / FinishedOperations);

    [_ProgressUpdateDelegate UpdateProgress:ProgressFloat];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [_ProgressUpdateDelegate FailedLoading];
}
- (void) UpdateDataFromServer:(NSArray*)OperationsToProcess
{
    bError = NO;
    Operations = OperationsToProcess;
    Queue = [[NSOperationQueue alloc] init];
    [Queue setMaxConcurrentOperationCount:1];
    /*[Queue setCompletion:
          ^{
              if (!bError) [self FinishLoading];
          }];
 
*/
    NSBlockOperation *operationObj = [NSBlockOperation blockOperationWithBlock:^{
        [self performSelectorOnMainThread:@selector(FinishLoading) withObject:nil waitUntilDone:NO];
    }];[operationObj setCompletionBlock:^{
        NSLog(@"Operation has finished...");
    }];
    
    for (IMOperation* CurrentOperation in Operations)
    {
        CurrentOperation.NotificationsRecieverDelegate = self;
        CurrentOperation.queuePriority = NSOperationQueuePriorityHigh;
        [Queue addOperation:CurrentOperation];
      
    }
    [Queue addOperation:operationObj];
}

-(IMOperationParse*) CreateUpdateOperation:(IMAbstractManager*) Manager Parser:(IMAbstractParser*)ChosenParser URL:(NSString*)URLName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"URL" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSString *URL = [dictionary objectForKey:URLName];
    NSURL *DataURL = [NSURL URLWithString:[URL
                                                  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    IMOperationParse *ParseOperation = [[IMOperationParse new] initWithData:DataURL ManagerInstance:Manager ParserInstance:ChosenParser];
    
   
    
    return ParseOperation;
    
}

- (UIViewController*) GetDestinationViewController:(Section*)ForSection Storyboard:(UIStoryboard*)ForStoryboard
{
    UIViewController* RightViewController;
    if ([ForSection GetSectionManagerHandler] == [ProductManager class])
    {
        RightViewController = [ForStoryboard instantiateViewControllerWithIdentifier: @"FIRST_TOP_VIEW_CONTROLLER"];
    }
    else if ([ForSection GetSectionManagerHandler] == [EventManager class])
    {
        RightViewController = [ForStoryboard instantiateViewControllerWithIdentifier: @"FOURTH_TOP_VIEW_CONTROLLER"];
    }
    else if ([ForSection GetSectionManagerHandler] == [AddressManager class])
    {
        RightViewController = [ForStoryboard instantiateViewControllerWithIdentifier:@"THIRD_TOP_VIEW_CONTROLLER"];
    }
    else if ([ForSection GetSectionManagerHandler] == [BonusManager class])
    {
        RightViewController = [ForStoryboard instantiateViewControllerWithIdentifier:@"BonusesController"];
    }
    
    else if ([ForSection GetSectionManagerHandler] == [AboutUsManager class])
    {
        RightViewController = [ForStoryboard instantiateViewControllerWithIdentifier:@"AboutUs"];
    }
    
    else if ([ForSection GetSectionManagerHandler] == [DiscountManager class])
    {
        RightViewController = [ForStoryboard instantiateViewControllerWithIdentifier:@"DiscountCard"];
    }
    
    if ([ForSection GetId] == 1111111)
    {
        RightViewController = [ForStoryboard instantiateViewControllerWithIdentifier:@"Settings"];
    }
    
    
    if ([ForSection GetSectionManagerHandler] == [InfoManager class])
    {
        RightViewController = [ForStoryboard instantiateViewControllerWithIdentifier:@"SECOND_TOP_VIEW_CONTROLLER"];
    }
    return RightViewController;
}

NSMutableData *ReceivedData;

- (BOOL)connectionPOST:(NSURLRequest *)aRequest
            withParams:(NSDictionary *)aDictionary {
    
    if ([aDictionary count] > 0)
    {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                        initWithURL:[aRequest URL]];
        [request setHTTPMethod:@"POST"];
        
        NSMutableString *postString = [[NSMutableString alloc] init];
        NSArray *allKeys = [aDictionary allKeys];
        for (int i = 0; i < [allKeys count]; i++) {
            NSString *key = [allKeys objectAtIndex:i];
            NSString *value = [aDictionary objectForKey:key];
            [postString appendFormat:( (i == 0) ? @"%@=%@" : @"&%@=%@" ), value, key];
        }
        
        [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        
        [NSURLConnection connectionWithRequest:request delegate:self];
        
        
        return YES;
    } else {
        return NO;
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
#if !(TARGET_IPHONE_SIMULATOR)
    NSString *path = [[NSBundle mainBundle] pathForResource:@"URL" ofType:@"plist"];
    
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSString *TokenRequestURL = [dictionary objectForKey:@"Token"];

    NSLog(@"My token is: %@", deviceToken);
    
    NSURL *url = [NSURL URLWithString:TokenRequestURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSString *TokenString =[NSString stringWithFormat:@"%@", deviceToken];
    NSString *FormattedString = [TokenString substringWithRange:NSMakeRange(1, [TokenString length]-2)];
    FormattedString = [FormattedString
                       stringByReplacingOccurrencesOfString:@" " withString:@""];
    // Send name=Mark&lastname=Smith
    
    // Get Phone Number to insert in Server Notification Registration Request
    NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
    NSString *UserPhoneNumber = [Defaults objectForKey:@"UserPhoneNumber"];
    
    NSDictionary *params = [[NSDictionary alloc]
                            initWithObjectsAndKeys:
                            @"key", FormattedString,
                            @"type", @"token",
                            @"phone", UserPhoneNumber,
                            @"application", @"1",
                            @"os", @"ios",nil];

    [self connectionPOST:request withParams:params];
#endif
       }

-(void)application:(UIApplication *)app didReceiveRemoteNotification:(NSDictionary *)userInfo
{
   // if([app applicationState] == UIApplicationStateInactive)
   // {
        //id ObjectEvent = [userInfo objectForKey:@"action_id"];
        if ([userInfo objectForKey:@"action_id"])
        {
            _NotificationEvent = [IMEvent new];
            [_NotificationEvent SetId:[[userInfo valueForKey:@"action_id"] intValue]];
            [_NotificationResponderDelegate TransitionFromNotification];
        }
        //If the application state was inactive, this means the user pressed an action button
        // from a notification.
        
        //Handle notification
   // }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{

    // данные получены
    // здесь можно произвести операции с данными
    
    // можно узнать размер загруженных данных
    //NSString *dataString = [[NSString alloc] initWithFormat:@"Received %d bytes of data",[receivedData length]];
    
    // если ожидаемые полученные данные - это строка, то можно вывести её
    NSString *dataString = [[NSString alloc] initWithData:ReceivedData encoding:NSUTF8StringEncoding];
    
    NSLog(dataString);
  
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
#if !(TARGET_IPHONE_SIMULATOR)
    NSLog(@"Failed to get token, error: %@", error);
#endif
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    
    NSArray *vComp = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[vComp objectAtIndex:0] intValue] == 7)
    {
        // Для iOS 7
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];

    }
    else
    {
        // Для iOS 8 и выше
         [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
         [[UIApplication sharedApplication] registerForRemoteNotifications];
    }

    // Notifications register
    
    
    
    // Color setup
    NSString *Path = [[NSBundle mainBundle] pathForResource:@"Colors" ofType:@"plist"];
    NSDictionary *Dictionary = [[NSDictionary alloc] initWithContentsOfFile:Path];
    NSString *ColorString = [Dictionary objectForKey:@"MainColor"];
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    _MainAppColor = [UIColor new];
    _MainAppColor = [Tools ColorWithHexString:ColorString];
    
    

    return YES;
}



							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}





@end
