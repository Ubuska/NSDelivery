//
//  IMAppDelegate.h
//  Delivery
//
//  Created by Developer on 10.12.14.
//  Copyright (c) 2014 incodemobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMAbstractManager.h"
#import "IMAbstractParser.h"

#import "Tools.h"
#import "Protocols.h"
#import "IMOperationParse.h"

#import "IMProduct.h"
#import "IMEvent.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)



@class Section;
@interface IMAppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate, OperationNotifyReceiver>
{
    NSOperationQueue *Queue;
    NSArray* Operations;
    BOOL bError;
}

@property (nonatomic, strong) dispatch_group_t ParseDataDispatchGroup;
@property (nonatomic, strong) dispatch_semaphore_t ParseDataSemaphore;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIColor *MainAppColor;

- (UIViewController*) GetDestinationViewController:(Section*)ForSection Storyboard:(UIStoryboard*)ForStoryboard;

- (void) UpdateDataFromServer:(NSArray*)OperationsToProcess;
- (IMOperationParse*) CreateUpdateOperation:(IMAbstractManager*) Manager Parser:(IMAbstractParser*)ChosenParser URL:(NSString*)URLName;
- (BOOL) IsRegularStartup;
- (void) IncrementOperationsCount;

@property (weak) id<UpdateControllerView> ControllerDelegate;
@property (weak) id<UpdateProgress> ProgressUpdateDelegate;
@property (weak) id<NotificationRespondHandler> NotificationResponderDelegate;

@property IMItem* NotificationProduct;
@property IMItem* NotificationEvent;

@end
